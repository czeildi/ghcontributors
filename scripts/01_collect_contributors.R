# report params -----------------------------------------------------------

report_start_date <- as.Date("2018-09-01")
report_end_date <- report_start_date + lubridate::period(1, "year")
gh_token <- Sys.getenv("GH_CONTRIB_PAT")

stopifnot(Sys.Date() >= report_end_date)

# collect data ------------------------------------------------------------

if (!file.exists(get_ropensci_commit_history_filename(report_end_date))) {
  repos <- fetch_ropensci_package_repos(gh_token)
  commits <- fetch_commit_history_of_repos(
    repos, end_date = report_end_date,
    cache_folder = get_api_response_cache_folder(report_end_date),
    verbose = TRUE,
    gh_token = gh_token
  ) %T>%
    readr::write_csv(get_ropensci_commit_history_filename(report_end_date))
}

