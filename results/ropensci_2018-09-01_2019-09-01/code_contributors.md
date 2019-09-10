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



### Top contributors


```r
author_summary %>% 
    filter(n_commit * n_repo >= 1000) %>% 
    select(author_id, author_name, n_commit, n_repo) %>% 
    knitr::kable()
```



|author_id        |author_name       | n_commit| n_repo|
|:----------------|:-----------------|--------:|------:|
|sckott           |Scott Chamberlain |     2365|     99|
|jeroen           |Jeroen Ooms       |      816|     83|
|maelle           |Maëlle Salmon     |      570|     39|
|Bisaloo          |Hugo Gruson       |       77|     13|
|cboettig         |Carl Boettiger    |      493|     12|
|adamhsparks      |Adam H. Sparks    |     1188|      7|
|mpadge           |mpadge            |      273|      7|
|richelbilderbeek |richelbilderbeek  |     1378|      6|
|noamross         |Noam Ross         |      192|      6|
|Rekyt            |Rekyt             |      225|      5|
|wlandau          |wlandau           |     1451|      3|
|Robinlovelace    |Robin Lovelace    |      442|      3|
|wlandau-lilly    |wlandau-lilly     |      727|      2|


**Total number of contributors in the past year: 312.**

### Authors by number of repositories they contributed to


|n_repo | n_author|
|:------|--------:|
|1      |      225|
|2      |       54|
|3      |       15|
|4      |        3|
|5      |        4|
|6-10   |        6|
|11-50  |        3|
|50+    |        2|

### Authors by number of commits they made


|n_commit | n_author|
|:--------|--------:|
|1        |       84|
|2-5      |       78|
|6-10     |       37|
|11-100   |       72|
|101-1000 |       37|
|1000+    |        4|

