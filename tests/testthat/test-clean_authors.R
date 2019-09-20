context("clean_authors")

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

  })
  describe("by_email", {

  })
  describe("by_login_as_name", {

  })
  describe("by name or email", {

  })
})

