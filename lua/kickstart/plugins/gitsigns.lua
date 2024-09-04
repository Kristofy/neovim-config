-- See `:help gitsigns` to understand what the configuration keys do
return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				-- Navigation
				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange", buffer = bufnr })

				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange", buffer = bufnr })

				-- Actions
				-- visual mode
				vim.keymap.set("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "stage git hunk", buffer = bufnr })

				vim.keymap.set("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "reset git hunk", buffer = bufnr })
				-- normal mode
				vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk", buffer = bufnr })
				vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk", buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>hS",
					gitsigns.stage_buffer,
					{ desc = "git [S]tage buffer", buffer = bufnr }
				)
				vim.keymap.set(
					"n",
					"<leader>hu",
					gitsigns.undo_stage_hunk,
					{ desc = "git [u]ndo stage hunk", buffer = bufnr }
				)
				vim.keymap.set(
					"n",
					"<leader>hR",
					gitsigns.reset_buffer,
					{ desc = "git [R]eset buffer", buffer = bufnr }
				)
				vim.keymap.set(
					"n",
					"<leader>hp",
					gitsigns.preview_hunk,
					{ desc = "git [p]review hunk", buffer = bufnr }
				)
				vim.keymap.set("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line", buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>hd",
					gitsigns.diffthis,
					{ desc = "git [d]iff against index", buffer = bufnr }
				)
				vim.keymap.set("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit", buffer = bufnr })
				-- Toggles
				vim.keymap.set(
					"n",
					"<leader>tb",
					gitsigns.toggle_current_line_blame,
					{ desc = "[T]oggle git show [b]lame line", buffer = bufnr }
				)
				vim.keymap.set(
					"n",
					"<leader>tD",
					gitsigns.toggle_deleted,
					{ desc = "[T]oggle git show [D]eleted", buffer = bufnr }
				)
			end,
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
