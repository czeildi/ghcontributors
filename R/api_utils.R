transform_commits_api_response_to_tibble <- function(commits_api_response, repo) {
  if (identical(as.character(commits_api_response), "")) {
    return(tibble::tibble(
      repo = character(0),
      commit_date = character(0),
      commit_author_name = character(0),
      commit_author_email = character(0),
      author_login = character(0)
    ))
  }
  purrr::map_df(commits_api_response, ~ {
    tibble::tibble(
      repo = repo,
      commit_date = purrr::pluck(.x, "commit", "author", "date", .default = NA_character_),
      commit_author_name = purrr::pluck(.x, "commit", "author", "name", .default = NA_character_),
      commit_author_email = purrr::pluck(.x, "commit", "author", "email", .default = NA_character_),
      author_login = purrr::pluck(.x, "author", "login", .default = NA_character_),
    )
  })
}
