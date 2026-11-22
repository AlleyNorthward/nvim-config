return {
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
      },

      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicTest.*",
        },
      },

      contentProvider = {
        preferred = "fernflower",
      },

      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}
