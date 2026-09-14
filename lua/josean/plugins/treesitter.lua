return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()

    treesitter.install({
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
    })

    vim.treesitter.language.register("bash", "zsh")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("josean-treesitter", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        if not pcall(vim.treesitter.language.add, lang) then
          return
        end
        pcall(vim.treesitter.start, buf, lang)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    require("nvim-ts-autotag").setup()

    local selection = {}

    local function select_range(node)
      local sr, sc, er, ec = node:range()
      vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
      vim.cmd("normal! v")
      vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
    end

    vim.keymap.set({ "n", "x" }, "<C-space>", function()
      local node
      if vim.fn.mode() ~= "v" or #selection == 0 then
        selection = {}
        node = vim.treesitter.get_node()
      else
        node = selection[#selection]:parent()
      end
      if not node then
        return
      end
      selection[#selection + 1] = node
      vim.cmd("normal! \27")
      select_range(node)
    end, { desc = "Increment selection" })

    vim.keymap.set("x", "<BS>", function()
      if #selection < 2 then
        return
      end
      table.remove(selection)
      vim.cmd("normal! \27")
      select_range(selection[#selection])
    end, { desc = "Decrement selection" })
  end,
}
