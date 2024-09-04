return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			filetypes = {
				markdown = true,
				yaml = true,
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"zbirenbaum/copilot.lua",
		},

		opts = {},
	},
	{
		"smoka7/hop.nvim",
		version = "*",
		config = function()
			local hop = require("hop")
			local opts = {
				keys = "etovxqpdygfblzhckisuran",
				multi_windows = true,
			}

			hop.setup()
			-- set the HopChar2MW keymap
			vim.keymap.set("n", "<C-s>", function()
				hop.hint_char2(opts)
			end)
		end,
	},
	{ "ellisonleao/gruvbox.nvim" },
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0,
			},
			win_options = {
				wrap = true,
				winblend = 0,
			},
			keymaps = {
				["<C-c>"] = false,
				["<C-s>"] = false,
				["q"] = "actions.close",
			},
		},
		config = function(_, opts)
			require("oil").setup(opts)
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			-- vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Fold" })
			---@diagnostic disable-next-line: missing-fields
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "lsp", "indent" }
				end,
			})
		end,
	},
	{
		"danymat/neogen",
		config = function()
			require("neogen").setup({})
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap("n", "<leader>nf", ":lua require('neogen').generate()<CR>", opts)
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neogit").setup({
				disable_signs = false,
				disable_context_highlighting = false,
				disable_commit_confirmation = false,
				disable_builtin_notifications = false,
				-- customize displayed signs
				signs = {
					-- { CLOSED, OPENED }
					section = { ">", "v" },
					item = { ">", "v" },
					hunk = { "", "" },
				},
			})

			vim.keymap.set("n", "<leader>gg", "<CMD>Neogit<CR>", { desc = "Open parent directory" })
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
