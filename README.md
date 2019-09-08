# gh-contributors

<!-- badges: start -->
<!-- badges: end -->

The goal of gh-contributors is to summarize contributors to a GitHub organization over a period of time.

## Running

[Github personal access token](https://github.com/settings/tokens) with the following access:
- `public_repo`
- `read:org`

Store it in your `.Renviron` with name `GH_CONTRIB_PAT` or change this line in `scripts/01_collect_contributors.R` to reflect the name of your token.

- `scripts/01_collect_contributors.R`
- `scripts/02_summarize_contributors.R`

## Results

## Notes

- 1 person might use multiple github users
- for some commits, no user identification is available
