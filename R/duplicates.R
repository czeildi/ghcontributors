collapse_duplicates <- function(commits, duplicates) {
  login_duplicates <- duplicates %>%
    select(author_login, author_login_2) %>%
    unique()
  commits %>%
    left_join(login_duplicates, by = "author_login") %>%
    mutate(author_login = ifelse(is.na(author_login_2), author_login, author_login_2)) %>%
    select(-author_login_2)
}

report_potential_duplicates <- function(commits, people_w_multiple_gh_users) {
  known_duplicates <- people_w_multiple_gh_users %>%
    tibble::enframe(name = "author_login_2", value = "author_login") %>%
    tidyr::unnest() %>%
    rbind(tibble::tibble(author_login = names(people_w_multiple_gh_users), author_login_2 = names(people_w_multiple_gh_users)))

  identify_duplicate_ids(commits) %>%
    full_join(known_duplicates, by = "author_login") %>%
    mutate(will_be_collapsed = !is.na(author_login_2)) %>%
    select(-n) %>%
    arrange(will_be_collapsed)
}

identify_duplicate_ids <- function(commits) {
  authors_with_login <- commits %>%
    filter(!is.na(author_login)) %>%
    select(author_login, standardized_author_name, commit_author_email) %>%
    unique()
  duplicate_author_names <- authors_with_login %>%
    group_by(standardized_author_name) %>%
    summarize(n = n_distinct(author_login)) %>%
    filter(n > 1) %>%
    inner_join(authors_with_login, by = "standardized_author_name")
  duplicate_author_emails <- authors_with_login %>%
    group_by(commit_author_email) %>%
    summarize(n = n_distinct(author_login)) %>%
    filter(n > 1) %>%
    inner_join(authors_with_login, by = "commit_author_email")
  rbind(duplicate_author_names, duplicate_author_emails)
}
