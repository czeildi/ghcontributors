unify_logins_by_email <- function(commits) {
    commits %>%
        group_by(commit_author_email) %>%
        mutate(n_login = n_distinct(author_id)) %>%
        mutate(author_id = if_else(n_login > 1, min(author_id), author_id)) %>%
        ungroup() %>%
        select(-n_login)
}

identify_authors_by_name <- function(commits) {
    authors_with_login <- commits_in_report_period %>%
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
        stop("Some commits were lost during identifying commits without author login specificed in API response, check the reason!")
    }
    identified_commits
}
