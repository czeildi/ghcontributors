library("magrittr")
source(here::here("R/api_utils.R"))
# report params -----------------------------------------------------------

org_name <- "ropensci"
report_start_date <- as.Date("2018-09-01")
report_end_date <- report_start_date + lubridate::period(1, "year")
gh_token <- Sys.getenv("GH_CONTRIB_PAT")

# collect data ------------------------------------------------------------

stopifnot(Sys.Date() >= report_end_date)

api_response_cache_folder <- here::here("cached_data", glue::glue("commits_{org_name}_{report_start_date}_{report_end_date}")) %T>%
    dir.create(recursive = TRUE, showWarnings = FALSE)

repos_in_org_filename <- file.path(api_response_cache_folder, "repos.rds")
if (!file.exists(repos_in_org_filename)) {
    repos_api_response <- gh::gh(
        "GET /orgs/:org/repos", org = org_name, .token = gh_token, .limit = 10000
    ) %T>%
        saveRDS(repos_in_org_filename)
} else {
    repos_api_response <- readRDS(repos_in_org_filename)
}
repos <- purrr::map_chr(repos_api_response, "name")

commits_in_report_period <- purrr::imap_dfr(repos, ~{
    repo <- .x

    if ((.y - 1)%%10 == 0) {
        message(.y - 1, " repo's commit history requested, ", length(repos) - .y + 1, " left to go.")
    }

    filename <- file.path(api_response_cache_folder, glue::glue("{repo}.rds"))
    if (!file.exists(filename)) {
        commits_api_response <- gh::gh(
            endpoint = "GET /repos/:owner/:repo/commits?since=:since&until=:until",
            owner = org_name,
            repo = repo,
            since = format(report_start_date, "%Y-%m-%dT00:00:00"),
            until = format(report_end_date, "%Y-%m-%dT00:00:00"),
            .token = gh_token,
            .limit = 10000
        ) %T>%
            saveRDS(filename)
    } else {
        commits_api_response <- readRDS(filename)
    }

    transform_commits_api_response_to_tibble(commits_api_response, repo)
})

readr::write_csv(
    commits_in_report_period,
    here::here("cached_data", glue::glue("commits_{org_name}_{report_start_date}_{report_end_date}.csv"))
)
