# gh-contributors

<!-- badges: start -->
<!-- badges: end -->

The goal of gh-contributors is to summarize contributors to a GitHub organization over a period of time.

## Running

[Github personal access token](https://github.com/settings/tokens) with the following access:
- `public_repo`
- `read:org`

Store it in your `.Renviron` with name `GH_CONTRIB_PAT` or change this line in `scripts/01_collect_contributors.R` to reflect the name of your token.

- run `scripts/01_collect_contributors.R`, this can take up to 10 minutes (requesting commit history for each repository)
- knit `scripts/02_summarize_contributors.Rmd` (optionally change params in the yaml header) or call 
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

## Results

- csv files in the results folder (in subfolder for dates + org)
- html + md report in the results folder (in subfolder for dates + org)

## Notes

- 1 person might use multiple github users
- for some commits, no user identification is available
