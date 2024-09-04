return {
  { -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "[F]ormat buffer",
      },
      {
        "<leader>l",
        function()
          require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 1000 })
        end,
        mode = "v",
        desc = "Format [l]ines",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters = {
        ["clang-format"] = {
          args = { [[--style={
          BasedOnStyle: llvm,
          SortIncludes: false,
          AlignAfterOpenBracket: BlockIndent,
          BinPackArguments: false,
          PenaltyBreakBeforeFirstCallParameter: 1,
          PenaltyIndentedWhitespace: 1,
          AlignConsecutiveAssignments: true,
          ColumnLimit: 120
          }]] },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        markdown = { "prettierd" },
        nix = { "nixpkgs_fmt" },
        cpp = { "clang-format" },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
