---
title: "code contributors to GitHub org"
output: 
    html_document:
        keep_md: yes
params:
    org_name: "ropensci"
    report_start_date: !r as.Date("2018-09-01")
    report_end_date: !r as.Date("2019-09-01")
    bot_gh_users: !r c("web-flow", "ropenscibot")
    duplicates_yml_path: "scripts/people_w_multiple_gh_users.yml"
---





- Github organization: **ropensci**.
- Commits were considered from 2018-09-01 to 2019-09-01.
- Excluded users: web-flow, ropenscibot.





Potential duplicates (1 person with multiple GitHub logins) are identified based on commit name and email. Based on *scripts/people_w_multiple_gh_users.yml* those will be collapsed where the below `will_be_collapsed` column is `TRUE`.


|standardized_author_name |author_login      |commit_author_email                    |will_be_collapsed |
|:------------------------|:-----------------|:--------------------------------------|:-----------------|
|andrew                   |wabarr            |wabarr@users.noreply.github.com        |FALSE             |
|andrew                   |aammd             |a.a.m.macdonald@gmail.com              |FALSE             |
|marco                    |yomoseco          |msciain@gwdg.de                        |FALSE             |
|marco                    |marcosci          |sciaini.marco@gmail.com                |FALSE             |
|alanbutler               |rabutler-usbr     |rabutler@usbr.gov                      |TRUE              |
|alanbutler               |rabutler          |r.alan.butler@gmail.com                |TRUE              |
|barryrowlingson          |barryrowlingson   |b.rowlingson@lancs.ac.uk               |TRUE              |
|barryrowlingson          |spacedman         |b.rowlingson@gmail.com                 |TRUE              |
|dantonnoriega            |dantonnoriega     |dantonnoriega@users.noreply.github.com |TRUE              |
|dantonnoriega            |dantonnoriega     |danton.noriega@gmail.com               |TRUE              |
|dantonnoriega            |ultinomics        |ultinomics@users.noreply.github.com    |TRUE              |
|deanmarchiori            |deanmarchiori-irx |dean.marchiori@internetrix.com.au      |TRUE              |
|deanmarchiori            |deanmarchiori     |deanmarchiori@gmail.com                |TRUE              |
|willlandau               |wlandau           |will.landau@gmail.com                  |TRUE              |
|willlandau               |wlandau-lilly     |will.landau@lilly.com                  |TRUE              |

Commit data is cleaned: when GitHub login is not available, commits are identified based on commit author name or email. For each GitHub login, the most frequently used author name is used.




```
## 7 out of 91293 commits were discarded due to being unidentifiable
## between 2011-05-04 and 2019-09-01.
```

### Contributors in the report period





Total number of contributors in the report period: **286**. From this, **119** contributed for the first time in the report period.

### Top contributors


```r
author_summary %>%
  dplyr::filter(n_commit * n_repo >= 1000) %>%
  knitr::kable()
```



|author_login     |author_name       | n_commit| n_repo|
|:----------------|:-----------------|--------:|------:|
|sckott           |Scott Chamberlain |     2017|     81|
|jeroen           |Jeroen Ooms       |      729|     77|
|maelle           |Maëlle Salmon     |      282|     32|
|cboettig         |Carl Boettiger    |      445|     11|
|richelbilderbeek |richelbilderbeek  |     1378|      6|
|mpadge           |mpadge            |      272|      6|
|adamhsparks      |Adam H. Sparks    |     1186|      5|
|Robinlovelace    |Robin Lovelace    |      442|      3|
|wlandau          |wlandau           |     2176|      2|


### Authors by number of repositories they contributed to


|n_repo | n_author|
|:------|--------:|
|1      |      220|
|2      |       45|
|3      |        7|
|4      |        4|
|5      |        2|
|6-10   |        3|
|11-50  |        3|
|50+    |        2|

### Authors by number of commits they made


|n_commit | n_author|
|:--------|--------:|
|1        |       80|
|2-5      |       66|
|6-10     |       33|
|11-100   |       66|
|101-1000 |       37|
|1000+    |        4|

