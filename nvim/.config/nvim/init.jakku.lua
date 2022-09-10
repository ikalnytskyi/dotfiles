local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
   settings = {
      pyright = {
         disableOrganizeImports = true,
      },
      python = {
         analysis = {
            autoImportCompletions = false,
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = false,
            typeCheckingMode = "off",
         },
      },
   },
})
