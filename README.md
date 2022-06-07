# GitHub contributors

<!-- badges: start -->
<!-- badges: end -->

The goal of ghcontributors is to summarize contributors to a GitHub organization over a period of time. The whole script is specific to the use case of ropensci annual report but many components could be used to summarize contributors of other GitHub organizations.

Note, that structurally this repository is a package but it is not intended to be used in other projects.

## Running

- Clone repository (do not install)
- Install dependencies with `devtools::install_dev_deps()`
- [Github personal access token](https://github.com/settings/tokens) with the following access:
  - `public_repo`
  - `read:org`
  - Store it in your `.Renviron` with name `GH_CONTRIB_PAT` or change this line in `scripts/01_collect_contributors.R` to reflect the name of your token.
- `devtools::load_all()`
- Commit history github api results are cached to disk by default because they take significant time to fetch. If you want to start fresh, delete the contents of `cached_data/commits_{report_end_date}`.
- Run `scripts/01_collect_contributors.R`, this can take up to 30 minutes (requesting commit history for each repository).
- call
```r
rmarkdown::render(
    "scripts/02_summarize_contributors.Rmd",
    params = list(
        org_name = "ropensci",
        report_start_date = as.Date("2018-09-01"),
        report_end_date = as.Date("2019-09-01")
    ),
    output_dir = "results/ropensci_2018-09-01_2019-09-01",
    output_file = "code_contributors"
)
```
(optionally change params in the yaml header)

## Results

- csv files in the results folder (in subfolder for dates + org)
- html + md report in the results folder (in subfolder for dates + org)

## Notes

- 1 person might use multiple github users, these are collapsed to the best of our knowledge based on `scripts/people_with_multiple_gh_users.yml`
- for some commits, no user identification is available
