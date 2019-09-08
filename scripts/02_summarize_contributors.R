library("dplyr")
library("magrittr")
source("R/clean_authors.R")

# report params -----------------------------------------------------------

org_name <- "ropensci"
report_start_date <- as.Date("2018-09-01")
report_end_date <- report_start_date + lubridate::period(1, "year")

bot_gh_users <- c("web-flow", "ropenscibot")

# summarize ---------------------------------------------------------------
result_folder <- file.path("results", glue::glue("{org_name}_{report_start_date}_{report_end_date}"))
dir.create(result_folder, recursive = TRUE, showWarnings = FALSE)

commits_in_report_period <- file.path("data", glue::glue("commits_{org_name}_{report_start_date}_{report_end_date}.csv")) %>%
    readr::read_csv() %>%
    filter(!author_login %in% bot_gh_users)

cleaned_commits <- commits_in_report_period %>%
    identify_authors_by_name() %>%
    unify_logins_by_email() %>%
    filter(!is.na(author_id))

authors <- cleaned_commits %>%
    group_by(author_id, commit_author_name, is_identifiable_by_login) %>%
    summarize(freq = n()) %>%
    group_by(author_id, is_identifiable_by_login) %>%
    summarize(author_name = first(commit_author_name, -freq))

author_summary <- cleaned_commits %>%
    group_by(author_id) %>%
    summarise(
        n_commit = n(),
        n_repo = n_distinct(repo)
    ) %>%
    ungroup() %>%
    inner_join(authors, by = "author_id") %>%
    arrange(-n_repo, -n_commit) %T>%
    readr::write_csv(file.path(result_folder, "authors.csv"))

author_summary %>%
    ungroup() %>%
    arrange(-n_repo) %>%
    mutate(n_repo = cut(
        n_repo,
        breaks = c(0:5, 10, 50, 1000),
        labels = c(as.character(1:5), "6-10", "11-50", "50+")
    )) %>%
    group_by(n_repo) %>%
    summarize(n_author = n()) %>%
    ungroup() %T>%
    readr::write_csv(file.path(result_folder, "authors_by_num_repo.csv"))

author_summary %>%
    ungroup() %>%
    arrange(-n_commit) %>%
    mutate(n_commit = cut(
        n_commit,
        breaks = c(0, 1, 5, 10, 100, 1000, 10000),
        labels = c("1", "2-5", "6-10", "11-100", "101-1000", "1000+")
    )) %>%
    group_by(n_commit) %>%
    summarize(n_author = n()) %>%
    ungroup() %T>%
    readr::write_csv(file.path(result_folder, "authors_by_num_commit.csv"))
