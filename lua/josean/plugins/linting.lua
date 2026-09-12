return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    local function lint_available()
      local names = lint.linters_by_ft[vim.bo.filetype]
      if not names then
        return
      end

      local available = {}
      for _, name in ipairs(names) do
        local linter = lint.linters[name]
        local cmd = linter and linter.cmd
        if type(cmd) == "function" then
          cmd = cmd()
        end
        if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
          table.insert(available, name)
        end
      end

      if #available > 0 then
        lint.try_lint(available)
      end
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = lint_available,
    })

    vim.keymap.set("n", "<leader>l", lint_available, { desc = "Trigger linting for current file" })
  end,
}
