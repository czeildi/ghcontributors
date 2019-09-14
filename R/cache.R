get_ropensci_commit_history_filename <- function(end_date) {
  file.path(
    get_api_response_cache_folder(end_date),
    glue::glue("ropensci_commits_until_{end_date}.csv")
  )
}

get_api_response_cache_folder <- function(end_date) {
  here::here(
    "cached_data", glue::glue("commits_{end_date}")
  )
}
