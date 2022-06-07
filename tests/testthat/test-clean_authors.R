describe("unify_names_for_login", {
  it("selects most frequent names", {
    commits <- tibble::tribble(
      ~repo,~author_login,~commit_author_name,
      "r1","a1","name2",
      "r2","a1","name1",
      "r3","a1","name1",
      "r4","a2","name2"
    )
    expect_equal(
      unify_names_for_login(commits),
      tibble::tribble(
        ~repo,~author_login,~commit_author_name,
        "r1","a1","name1",
        "r2","a1","name1",
        "r3","a1","name1",
        "r4","a2","name2"
      )
    )
  })
})

describe("identify authors", {
  describe("by_name", {
    it("replaces NA logins if login is unambiguous for name", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,
        "login1", "andrew",
        "login2", "andrew",
        "login3", "john",
        NA_character_, "john",
        NA_character_, "andrew",
        NA_character_, "peter"
      )
      expect_equal(
        identify_authors_by_name(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,
          "login1", "andrew",
          "login2", "andrew",
          "login3", "john",
          "login3", "john",
          NA_character_, "andrew",
          NA_character_, "peter"
        )
      )
    })
    it("disregards differences in name such as case of letters of space", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,~commit_author_name,
        "login3", "john", "John",
        NA_character_, "john", "john",
        NA_character_, "peter", "Peter"
      )
      expect_equal(
        identify_authors_by_name(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,~commit_author_name,
          "login3", "john", "John",
          "login3", "john", "john",
          NA_character_, "peter", "Peter"
        )
      )
    })
  })
  describe("by_email", {
    it("replaces NA logins if login is unambiguous for email", {
      commits <- tibble::tribble(
        ~author_login,~commit_author_email,
        "login1", "andrew@example.com",
        "login2", "andrew@example.com",
        "login3", "john@example.com",
        NA_character_, "john@example.com",
        NA_character_, "andrew@example.com",
        NA_character_, "peter@example.com"
      )
      expect_equal(
        identify_authors_by_email(commits),
        tibble::tribble(
          ~author_login,~commit_author_email,
          "login1", "andrew@example.com",
          "login2", "andrew@example.com",
          "login3", "john@example.com",
          "login3", "john@example.com",
          NA_character_, "andrew@example.com",
          NA_character_, "peter@example.com"
        )
      )
    })

  })
  describe("by_login_as_name", {
    it("replaces NA login if name found as login", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,
        "login1","peter",
        NA_character_,"login1"
      )
      expect_equal(
        identify_authors_by_login_as_name(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,
          "login1","peter",
          "login1","login1"
        )
      )
    })
  })
  describe("by name or email", {
    it("replaces NA login if name found for same email", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,~commit_author_email,
        "login1","andrew_love","andrew@example.com",
        NA_character_,"andrew_love","a@test.com",
        NA_character_,"andrew","a@test.com"
      )
      expect_equal(
        identify_unknown_authors(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,~commit_author_email,
          "login1","andrew_love","andrew@example.com",
          "login1","andrew_love","a@test.com",
          "login1","andrew","a@test.com"
        )
      )
    })
    it("uses name if no login found based on name or email", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,~commit_author_email,
        "login1","andrew_love","andrew@example.com",
        NA_character_,"john","johndoe@test.com"
      )
      expect_equal(
        identify_unknown_authors(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,~commit_author_email,
          "login1","andrew_love","andrew@example.com",
          "john","john","johndoe@test.com"
        )
      )
    })
    it("keeps NA login if name is NA too", {
      commits <- tibble::tribble(
        ~author_login,~standardized_author_name,~commit_author_email,
        "login1","andrew_love","andrew@example.com",
        NA_character_,NA_character_,NA_character_
      )
      expect_equal(
        identify_unknown_authors(commits),
        tibble::tribble(
          ~author_login,~standardized_author_name,~commit_author_email,
          "login1","andrew_love","andrew@example.com",
          NA_character_,NA_character_,NA_character_
        )
      )
    })
  })
})

