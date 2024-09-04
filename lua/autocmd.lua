-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- NOTE: Originally tried to put this in FileType event autocmd but it is apparently too early for `set modifiable` to take effect
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("YOUR_GROUP_HERE", { clear = true }),
	desc = "allow updating quickfix window",
	pattern = "quickfix",
	callback = function(ctx)
		vim.bo.modifiable = true
		-- :vimgrep's quickfix window display format now includes start and end column (in vim and nvim) so adding 2nd format to match that
		vim.bo.errorformat = "%f|%l col %c| %m,%f|%l col %c-%k| %m"
		vim.keymap.set(
			"n",
			"<C-s>",
			'<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
			{ buffer = true, desc = "Update quickfix/location list with changes made in quickfix window" }
		)
	end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et
