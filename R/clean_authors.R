collapse_duplicates <- function(commits, duplicates) {
  commits %>%
    left_join(duplicates %>% select(author_login, author_login_2), by = "author_login") %>%
    mutate(author_login = ifelse(is.na(author_login_2), author_login, author_login_2)) %>%
    select(-author_login_2)
}

report_potential_duplicates <- function(commits, people_w_multiple_gh_users) {
  known_duplicates <- people_w_multiple_gh_users %>%
    tibble::enframe(name = "author_login_2", value = "author_login") %>%
    tidyr::unnest() %>%
    rbind(tibble::tibble(author_login = names(people_w_multiple_gh_users), author_login_2 = names(people_w_multiple_gh_users)))
  authors_with_login <- commits %>%
    filter(!is.na(author_login)) %>%
    select(author_login, commit_author_name, commit_author_email) %>%
    unique()
  duplicate_author_names <- authors_with_login %>%
    group_by(commit_author_name) %>%
    summarize(n = n_distinct(author_login)) %>%
    filter(n > 1) %>%
    inner_join(authors_with_login, by = "commit_author_name")
  duplicate_author_emails <- authors_with_login %>%
    group_by(commit_author_email) %>%
    summarize(n = n_distinct(author_login)) %>%
    filter(n > 1) %>%
    inner_join(authors_with_login, by = "commit_author_email")

  rbind(duplicate_author_names, duplicate_author_emails) %>%
    left_join(known_duplicates, by = "author_login") %>%
    mutate(will_be_collapsed = !is.na(author_login_2)) %>%
    select(-n) %>%
    arrange(will_be_collapsed)
}

unify_logins_by_email <- function(commits) {
  commits %>%
    group_by(commit_author_email) %>%
    mutate(n_login = n_distinct(author_id)) %>%
    mutate(author_id = if_else(n_login > 1, min(author_id), author_id)) %>%
    ungroup() %>%
    select(-n_login)
}

identify_authors_by_name <- function(commits) {
  authors_with_login <- commits %>%
    filter(!is.na(author_login)) %>%
    select(author_login, commit_author_name) %>%
    unique()
  identified_commits <- commits %>%
    filter(is.na(author_login)) %>%
    select(-author_login) %>%
    left_join(authors_with_login, by = "commit_author_name") %>%
    rbind(filter(commits, !is.na(author_login))) %>%
    mutate(is_identifiable_by_login = if_else(is.na(author_login), FALSE, TRUE)) %>%
    mutate(author_id = if_else(is.na(author_login), tolower(commit_author_name), author_login))
  if (nrow(commits) != nrow(identified_commits)) {
    stop("Some commits were lost or duplicates during identifying commits without author login specificed in API response, check the reason!")
  }
  identified_commits
}
