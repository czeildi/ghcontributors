---
title: "summarize contributors"
output: 
    html_document:
        keep_md: yes
params:
    org_name: "ropensci"
    report_start_date: !r as.Date("2018-09-01")
    report_end_date: !r as.Date("2019-09-01")
    bot_gh_users: !r c("web-flow", "ropenscibot")
---





- Github organization: **ropensci**.
- Commits were considered from 2018-09-01 to 2019-09-01.
- Excluded users: web-flow, ropenscibot.




```
## 4 commits were discarded due to being unidentifiable.
```



**Total number of contributors in the past year: 286.**

### Top contributors


```r
author_summary %>% 
    dplyr::filter(n_commit * n_repo >= 1000) %>% 
    select(author_id, author_name, n_commit, n_repo) %>% 
    knitr::kable()
```



|author_id        |author_name       | n_commit| n_repo|
|:----------------|:-----------------|--------:|------:|
|sckott           |Scott Chamberlain |     2038|     81|
|jeroen           |Jeroen Ooms       |      729|     77|
|maelle           |Maëlle Salmon     |      282|     32|
|cboettig         |Carl Boettiger    |      444|     11|
|richelbilderbeek |richelbilderbeek  |     1378|      6|
|mpadge           |mpadge            |      272|      6|
|adamhsparks      |Adam H. Sparks    |     1186|      5|
|Robinlovelace    |Robin Lovelace    |      442|      3|
|wlandau-lilly    |wlandau-lilly     |      727|      2|
|wlandau          |wlandau           |     1449|      1|


### Authors by number of repositories they contributed to


|n_repo | n_author|
|:------|--------:|
|1      |      221|
|2      |       44|
|3      |        7|
|4      |        4|
|5      |        2|
|6-10   |        3|
|11-50  |        3|
|50+    |        2|

### Authors by number of commits they made


|n_commit | n_author|
|:--------|--------:|
|1        |       77|
|2-5      |       68|
|6-10     |       33|
|11-100   |       68|
|101-1000 |       36|
|1000+    |        4|

