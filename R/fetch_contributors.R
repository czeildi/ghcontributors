fetch_ropensci_package_repos <- function(gh_token = NULL, api_limit = 10000) {
  repos_in_org_api_response <- gh::gh(
    "GET /orgs/:org/repos",
    org = "ropensci", .token = gh_token, .limit = api_limit
  )
  repos_in_org <- purrr::map_chr(repos_in_org_api_response, "name")

  ro_registry <- jsonlite::read_json(
    "https://raw.githubusercontent.com/ropensci/roregistry/gh-pages/registry.json"
  )
  ro_registry_repos <- purrr::keep(ro_registry$packages, ~ grepl("/ropensci/", .[["url"]])) %>%
    purrr::map_chr("name")
  intersect(repos_in_org, ro_registry_repos)
}

fetch_commit_history_of_repos <- function(repos, end_date, cache_folder = NULL,
                                          verbose = TRUE,
                                          gh_token = NULL, api_limit = 10000) {
  purrr::imap_dfr(repos, ~ {
    if (verbose & .y %% 10 == 1) {
      message("Processed: ", .y - 1, "/", length(repos), " repository.")
    }
    fetch_commit_history(
      repo = .x, end_date = end_date, cache_folder = cache_folder,
      gh_token = gh_token, api_limit = api_limit
    ) %>%
      transform_commits_api_response_to_tibble(repo = .x)
  })
}

fetch_commit_history <- function(repo, end_date, cache_folder = NULL,
                                 gh_token = NULL, api_limit = 10000) {
  cache_filename <- file.path(
    cache_folder,
    glue::glue("commits_in_{repo}_until_{end_date}.rds")
  )
  if (isTRUE(file.exists(cache_filename))) {
    return(readRDS(cache_filename))
  }
  commits <- gh::gh(
    endpoint = "GET /repos/:owner/:repo/commits?until=:until",
    owner = "ropensci",
    repo = repo,
    until = format(end_date, "%Y-%m-%dT00:00:00"),
    .token = gh_token,
    .limit = api_limit
  )
  if (!is.null(cache_folder)) {
    dir.create(cache_folder, showWarnings = FALSE, recursive = TRUE)
    saveRDS(commits, cache_filename)
  }
  commits
}
