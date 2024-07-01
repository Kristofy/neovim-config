return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "[S]earch [C]olorschemes" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })


      vim.keymap.set("n", "<leader><leader>", function()
        local action_state = require('telescope.actions.state')
        local actions = require('telescope.actions')

        require("telescope.builtin").buffers {
          attach_mappings = function(prompt_bufnr, map)
            local delete_buf = function(mode)
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local multi_selections = current_picker:get_multi_selection()
              local _delete_buf = function(selection)
                if mode == 'save' then
                  vim.api.nvim_buf_call(selection.bufnr, function()
                    vim.cmd('silent! w')
                  end)

                  vim.api.nvim_buf_delete(selection.bufnr, { force = false })

                  actions.close(prompt_bufnr)
                elseif mode == 'force' then
                  vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                  actions.close(prompt_bufnr)
                else
                  if pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = false }) then
                    actions.close(prompt_bufnr)
                  else
                    -- Send a message to the user that the buffer can't be deleted
                    vim.api.nvim_echo(
                      { { 'Unsaved changes in  ' .. selection.bufnr .. ', can\'t be deleted', 'WarningMsg' } }, true,
                      {})
                  end
                end
              end

              if next(multi_selections) == nil then
                local selection = action_state.get_selected_entry()
                _delete_buf(selection)
              else
                for _, selection in ipairs(multi_selections) do
                  _delete_buf(selection)
                end
              end
            end

            map('i', '<C-q>', function()
              delete_buf('force')
            end)
            map('n', '<C-q>', function()
              delete_buf('force')
            end)
            map('i', '<C-w>', function()
              delete_buf('save')
            end)
            map('n', '<C-w>', function()
              delete_buf('save')
            end)
            map('i', '<C-d>', function()
              delete_buf('default')
            end)
            map('n', '<C-d>', function()
              delete_buf('default')
            end)
            return true
          end
        }
      end, { desc = "[ ] Find existing buffers" })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
