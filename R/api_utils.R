transform_commits_api_response_to_tibble <- function(commits_api_response, repo) {
    if (identical(as.character(commits_api_response), "")) {
        return(tibble::tibble(
            repo = character(0),
            commit_date = character(0),
            author_login = character(0)
        ))
    }
    purrr::map_df(commits_api_response, ~{
        tibble::tibble(
            repo = repo,
            commit_date = purrr::pluck(.x, "commit", "author", "date", .default = NA_character_),
            author_login = purrr::pluck(.x, "author", "login", .default = NA_character_)
        )
    })
}