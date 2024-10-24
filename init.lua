--border Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
	vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)

	-- big files
	use { 'LunarVim/bigfile.nvim' }
	-- JAVA LSP
	use 'mfussenegger/nvim-jdtls'

	-- Package manager
	-- Catppuccin color-scheme
	use { 'catppuccin/nvim', as = 'catppuccin' }

	-- Silicon / App to take screenshots of code

	use { 'krivahtoo/silicon.nvim', run = "echo patito && ./install.sh build" }

	-- Conflict marker
	use "rhysd/conflict-marker.vim"

	-- Oil / Manage files like vim buffer
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end
	})

	-- Git worktreee

	use 'ThePrimeagen/git-worktree.nvim'

	use "lilydjwg/colorizer"
	use { 'iamcco/markdown-preview.nvim', run = "cd app && npm install", setup = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end, ft = { "markdown" } }
	use 'tpope/vim-sleuth'
	use { 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
	use 'ellisonleao/gruvbox.nvim'
	use 'Mofiqul/dracula.nvim'
	use 'wbthomason/packer.nvim'
	use 'tpope/vim-dispatch'
	use 'windwp/nvim-ts-autotag'
	use 'neoclide/vim-jsx-improve'
	use 'windwp/nvim-autopairs'
	use 'tpope/vim-surround'
	use { 'olrtg/nvim-emmet',
		config = function ()
			vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
		end

	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'v1.1'              -- optional, updated every week. (see issue #1193)
	}

	use {
		'j-hui/fidget.nvim',
		tag = 'v1.4.0',
		config = function()
			require("fidget").setup {
				-- options
			}
		end
	}

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			'folke/neodev.nvim',
		},
	}

	--Spelling
	use 'kamykn/spelunker.vim'

	use { -- Autocompletion
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	}

	use { -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		run = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	}

	use { -- Additional text objects via treesitter
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}

	-- Git related plugins
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	use 'lewis6991/gitsigns.nvim'

	use 'nvim-lualine/lualine.nvim'
	use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

	use { 'ThePrimeagen/harpoon', requires = { 'nvim-lua/plenary.nvim' } }

	-- Fuzzy Finder (files, lsp, etc)
	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

	--TODO comments
	use {
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	}

	-- Add indent blankline
	use { 'lukas-reineke/indent-blankline.nvim', tag = 'v3.3.8' }

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, 'custom.plugins')
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require('packer').sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print '=================================='
	print '    Plugins are being installed'
	print '    Wait until Packer completes,'
	print '       then restart nvim'
	print '=================================='
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Open split to the right
vim.o.splitright = true

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox]]

-- Set jk keymap to escape
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
	options = {
		icons_enabled = true,
		component_separators = '/',
		section_separators = { left = '', right = '' },
	},
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('ibl').setup {
	indent = {
		char = '!',
		tab_char = '|',
	}
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	},
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	file_ignore_patterns = { "node_modules/.*" },
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}


-- Setup autotags
require('nvim-ts-autotag').setup({
})

-- Git worktree
require('git-worktree').setup()
require('telescope').load_extension('git_worktree')
vim.keymap.set('n', '<leader>cd', function()
	require('telescope').extensions.git_worktree.git_worktrees()
end)
vim.keymap.set('n', '<leader>ad', function()
	require('telescope').extensions.git_worktree.create_git_worktree()
end)

-- Todo comments highlight
require('todo-comments').setup()

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sq', require('telescope.builtin').quickfix, { desc = '[S]earch [Q]uickfix' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'vim', 'javascript', 'tsx', 'css' },
	ignore_install = { "help" },

	highlight = { enable = true },
	indent = { enable = true, disable = { 'python', 'typescriptreact' } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<c-backspace>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', function()
		vim.lsp.buf.definition {
			on_list = function(options)
				vim.fn.setqflist({}, ' ', options)
				require('telescope.builtin').quickfix()
			end
		}
	end, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			if vim.fn.exists(':EslintFixAll') > 0 then
				vim.cmd('EslintFixAll')
			end
		end
	})
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	cssls = {},
	eslint = {},
	html = {},
	jsonls = {},
	volar = {},
	tailwindcss = {},
	graphql = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}

-- Turn on lsp status information
require('fidget').setup()
-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}


require('nvim-tree').setup({
	git = {
		enable = true,
		ignore = false,
		timeout = 1000
	},
	view = {
		number = true,
		relativenumber = true
	},
	actions = {
		open_file = {
			quit_on_open = true
		}
	}
})
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set({ 'n', 'i' }, '<C-b>', function() vim.cmd('NvimTreeToggle') end)
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', function() vim.cmd('wa') end)
vim.keymap.set({ 'n' }, '<leader>ff', function() vim.cmd('NvimTreeFindFile') end)
vim.keymap.set({ 'n' }, '<leader>c', function() vim.cmd('NvimTreeCollapse') end)

-- Harpoon commands
vim.keymap.set({ 'n', 'v' }, '<C-h>', function() require('harpoon.ui').toggle_quick_menu() end,
	{ desc = "Toggle Harpoon" })
vim.keymap.set({ 'n', 'v' }, '<leader>b', function()
	require('harpoon.mark').add_file()
	print("File marked!")
end)
vim.keymap.set({ 'n', 'v' }, '<leader>1', function()
	require('harpoon.ui').nav_file(1);
end)
vim.keymap.set({ 'n', 'v' }, '<leader>2', function()
	require('harpoon.ui').nav_file(2);
end)
vim.keymap.set({ 'n', 'v' }, '<leader>3', function()
	require('harpoon.ui').nav_file(3);
end)
vim.keymap.set({ 'n', 'v' }, '<leader>4', function()
	require('harpoon.ui').nav_file(4);
end)

-- Oil commands
vim.keymap.set({'n'}, '<leader>oo', function()
	require('oil').open();
end)

-- Show current file path
vim.keymap.set({ 'n' }, '<leader>o', function()
	print(vim.fn.expand('%'))
end)

require('nvim-autopairs').setup()
require('diffview').setup()
require('neogit').setup {
	integrations = {
		telescope = true,
		diffview = true
	}
}

-- Utility function for going through the colorschemes
vim.keymap.set({ 'n' }, '<leader>cs', function()
	local current_scheme = vim.g.colors_name
	-- print('color = %s', current_scheme)
	local schemes = vim.fn.getcompletion('', 'color')
	for i=0,(#schemes - 1) do
		local scheme = schemes[i]
		if(scheme == current_scheme) then
			local new_index = i + 1;
			if (new_index >= #schemes) then
				new_index = 1
			end
			print(string.format('[%s] - %d/%d', schemes[new_index], new_index, #schemes))
			vim.cmd(string.format('colorscheme %s', schemes[new_index]))
		end
	end
end)

-- Silicon config

-- require('silicon').setup({
-- 	output = {
-- 		format = "silicon_[hour][minute][second].jpg"
-- 	}
-- })

vim.o.tabstop = 4
