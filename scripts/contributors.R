library("magrittr")
source("R/api_utils.R")
# report params -----------------------------------------------------------

org_name <- "ropensci"
gh_token <- Sys.getenv("GH_CONTRIB_PAT")
report_start_date <- as.Date("2018-09-01")
report_end_date <- report_start_date + lubridate::period(1, "year")

# collect data ------------------------------------------------------------

repos_api_response <- gh::gh(
    "GET /orgs/:org/repos", org = org_name, .token = gh_token, .limit = 10000
)
repos <- purrr::map_chr(repos_api_response, "name")

commits_in_report_period <- purrr::imap_dfr(repos, ~{
    repo <- .x
    if ((.y - 1)%%10 == 0) {
        message(.y - 1, " repo's commit history requested, ", length(repos) - .y + 1, " left to go.")
    }
    commits_api_response <- gh::gh(
        endpoint = "GET /repos/:owner/:repo/commits?since=:since&until=:until",
        owner = org_name,
        repo = repo,
        since = format(report_start_date, "%Y-%m-%dT00:00:00"),
        until = format(report_end_date, "%Y-%m-%dT00:00:00"),
        .token = gh_token, .limit = 10000
    )
    transform_commits_api_response_to_tibble(commits_api_response, repo)
})

readr::write_csv(commits_in_report_period, "commits_in_report_period.csv")


# analyse -----------------------------------------------------------------

library("dplyr")
commits_in_report_period <- readr::read_csv("commits_in_report_period.csv")
