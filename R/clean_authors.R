unify_names_for_login <- function(commits) {
  commits %>%
    group_by(author_login, commit_author_name) %>%
    summarize(n_commit = n()) %>%
    group_by(author_login) %>%
    summarize(commit_author_name = first(commit_author_name, order_by = -n_commit)) %>%
    right_join(select(commits, -commit_author_name), by = "author_login")
}

identify_authors_by_name <- function(commits) {
  author_names_with_unique_login <- commits %>%
    filter(!is.na(author_login)) %>%
    group_by(standardized_author_name) %>%
    mutate(n_login = n_distinct(author_login)) %>%
    filter(n_login == 1) %>%
    select(author_login, standardized_author_name) %>%
    unique()
  commits %>%
    filter(is.na(author_login)) %>%
    select(-author_login) %>%
    left_join(author_names_with_unique_login, by = "standardized_author_name") %>%
    rbind(filter(commits, !is.na(author_login))) %T>%
    assert_no_commit_lost(commits)
}

identify_authors_by_email <- function(commits) {
  author_emails_with_unique_login <- commits %>%
    filter(!is.na(author_login)) %>%
    group_by(commit_author_email) %>%
    mutate(n_login = n_distinct(author_login)) %>%
    filter(n_login == 1) %>%
    select(author_login, commit_author_email) %>%
    unique()
  commits %>%
    filter(is.na(author_login)) %>%
    select(-author_login) %>%
    left_join(author_emails_with_unique_login, by = "commit_author_email") %>%
    rbind(filter(commits, !is.na(author_login))) %T>%
    assert_no_commit_lost(commits)
}

identify_authors_by_login_as_name <- function(commits) {
  author_logins <- commits %>%
    filter(!is.na(author_login)) %>%
    select(author_login) %>%
    unique()
  commits %>%
    filter(is.na(author_login)) %>%
    select(-author_login) %>%
    mutate(author_login = standardized_author_name) %>%
    left_join(author_logins, by = "author_login") %>%
    rbind(filter(commits, !is.na(author_login))) %T>%
    assert_no_commit_lost(commits)
}

assert_no_commit_lost <- function(cleaned_commits, commits) {
  if (nrow(commits) != nrow(cleaned_commits)) {
    stop(
      "Some commits were lost or duplicated during identifying commits ",
      "without author login specificed in API response, check the reason!"
    )
  }
}
