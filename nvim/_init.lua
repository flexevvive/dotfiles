-- My init.lua

vim.cmd[[
set guicursor=
set termguicolors
set completeopt=menuone,noinsert,noselect
set updatetime=100
set timeoutlen=300
set noshowmode
set nolist
set background=dark
set number relativenumber
set nowrap
set list
set listchars+=eol:$
set tabstop=4
set shiftwidth=4
set noswapfile
set expandtab
set signcolumn=yes
set colorcolumn=80
set cursorline

let mapleader = " "

colorscheme hyper
hi! link SignColumn Normal
hi! CursorLine gui=underline
hi! Visual guibg=#ffffff guifg=#000000
hi! link jsonCommentError Comment " disable json comment error
]]

local packer = require('packer')

packer.init{}

packer.startup(function(use)

    use {
        "wbthomason/packer.nvim",

        opt = true
    }

    use {
        "mhinz/vim-startify",

         config = function()
            vim.cmd[[
                let g:startify_lists = [
                    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']           },
                    \ { 'type': 'sessions',  'header': ['   Sessions']            },
                    \ { 'type': 'files',     'header': ['   Files']               },
                    \ { 'type': 'dir',       'header': ['   Files in '. getcwd()] },
                    \ { 'type': 'commands',  'header': ['   Commands']            },
                    \ ]

                    let g:startify_custom_header = [
                        \ '    _   _         __     ___           ',
                        \ '   | \ | | ___  __\ \   / (_)_ __ ___  ',
                        \ '   |  \| |/ _ \/ _ \ \ / /| | `_ ` _ \ ',
                        \ '   | |\  |  __/ (_) \ V / | | | | | | |',
                        \ '   |_| \_|\___|\___/ \_/  |_|_| |_| |_|',
                        \ '             evvive neovim',
                        \ ]

                let g:startify_bookmarks = [ {'c': '~/.bashrc'}, {'t': "~/.tmux.conf"}, '~/.config/nvim/init.lua' ]

            ]]
         end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}
        },

        config = function()
            local actions = require("telescope.actions")

            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close
                        },
                    },
                },
                file_ignore_patterns = {
                    "__pycache__"
                }
            }

            vim.api.nvim_set_keymap('n', '<C-p>',  [[:Telescope find_files<cr>]], { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-g>',  [[:Telescope git_files<cr>]], { noremap = true, silent = true })


        end
    }

    use {
        'neovim/nvim-lspconfig',
    }

    use {
        'sbdchd/neoformat'
    }

    use {
        'tami5/lspsaga.nvim',

        config = function()
            local lspsaga = require 'lspsaga'

            lspsaga.setup { -- defaults ...
                debug = false,
                use_saga_diagnostic_sign = true,
                -- diagnostic sign
                error_sign = "!",
                warn_sign = "W",
                hint_sign = "H",
                infor_sign = "I",
                diagnostic_header_icon = " D  ",

                -- code action title icon
                code_action_icon = "A ",
                 code_action_prompt = {
                   enable = true,
                   sign = true,
                   sign_priority = 40,
                   virtual_text = true,
                 },
                 finder_definition_icon = "F  ",
                 finder_reference_icon = "F  ",
                 max_preview_lines = 10,
                 finder_action_keys = {
                   open = "o",
                   vsplit = "s",
                   split = "i",
                   quit = "q",
                   scroll_down = "<C-f>",
                   scroll_up = "<C-b>",
                 },
                 code_action_keys = {
                   quit = "q",
                   exec = "<CR>",
                 },
                 rename_action_keys = {
                   quit = "<C-c>",
                   exec = "<CR>",
                 },
                 definition_preview_icon = "P  ",
                 border_style = "single",
                 rename_prompt_prefix = "> ",
                 server_filetype_map = {},
                 diagnostic_prefix_format = "%d. ",
            }

            vim.cmd[[
                nnoremap <silent> <leader>ld :Lspsaga show_line_diagnostics<CR>
                nnoremap <silent> <leader>ln :Lspsaga diagnostic_jump_next<CR>
                nnoremap <silent> <leader>lp :Lspsaga diagnostic_jump_prev<CR>
                nnoremap <silent> <leader>lc :Lspsaga code_action<CR>
                nnoremap <silent> <leader>lh :Lspsaga hover_doc<CR>
            ]]
        end
    }

    use {
        'hrsh7th/nvim-cmp',

        requires = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'}
        },

        config = function()

            local cmp = require'cmp'

            cmp.setup {
                mapping = {
                    ['<C-b>'] = cmp.config.disable,
                    ['<C-f>'] = cmp.config.disable,
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-e>'] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                },
                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                }
            }

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer' },
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources {
                    { name = 'path' },
                    { name = 'cmdline' },
                }
            })

            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            require('lspconfig').vimls.setup {
                capabilities = capabilities,
            }

            require('lspconfig').pylsp.setup {
                capabilities = capabilities,
            }

            require'lspconfig'.tsserver.setup {
                capabilities = capabilities
            }

            require'lspconfig'.clangd.setup {
                capabilities = capabilities
            }

        end
    }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup{}
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',

        config = function()
            local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

            require('nvim-treesitter.configs').setup {
                ensure_installed = {"lua", "python", "vim", "markdown", "latex"},
                sync_install = false,

                highlight = {
                    enable = true,
                }
            }
        end
    }

    use { 'tpope/vim-commentary', -- old but gold

        config = function()
            vim.api.nvim_set_keymap('n', '<leader>c',  [[:Commentary<cr>]], { noremap = true, silent = true })
            vim.api.nvim_set_keymap('v', '<leader>c',  [[:'<,'>Commentary<cr>]], { noremap = true, silent = true })
        end
    }

    use {
        'tpope/vim-surround', -- old but gold
    }

    use {
        'tpope/vim-fugitive',

        config = function()
            vim.cmd[[
                nnoremap <silent> <leader>gg :Git<CR>
                nnoremap <silent> <leader>gp :Git push<CR>
            ]]
        end
    }

    use {
        'airblade/vim-gitgutter',

        config = function()
            vim.cmd[[
                let g:gitgutter_map_keys = 0

                nnoremap <silent> gs :GitGutterStageHunk
                nnoremap <silent> gp :GitGutterPreviewHunk
            ]]
        end
    }

    use {
        'liuchengxu/vim-which-key'
    }

    use {
        'tpope/vim-dispatch',

        config = function()
            vim.api.nvim_set_keymap('n', '<leader>d', [[:Dispatch<cr>]], { noremap = true, silent = true })

            vim.cmd[[
            augroup DISPATCH
                autocmd FileType python let b:dispatch= 'python3 %'
                autocmd FileType typescript let b:dispatch= 'ts-run %'
                autocmd FileType javascript let b:dispatch= 'node %'
            augroup END
            ]]
        end
    }
end)

vim.api.nvim_set_keymap('n', '<C-l>',  [[:bn<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>',  [[:bp<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bd',  [[:bd<cr>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ir',  [[:so $MYVIMRC<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ie',  [[:e $MYVIMRC<cr>]], { noremap = true, silent = true })

vim.cmd[[
" Snippets without plugins
" NOTE: Snippets are mapped with , because <space> is already used for
" other stuff
nnoremap <silent> ,html :-1read $HOME/.config/nvim/snippets/helloworld.html<CR>3j4wcit
nnoremap <silent> ,flex :-1read $HOME/.config/nvim/snippets/helloworld.flex.json<CR>9jA<tab><tab>

nnoremap <silent> <leader><leader> :WhichKey " "<CR>
]]

vim.cmd[[
augroup FORMATTING
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

function! MyStatusLine()
    let statusline = ""
    " Filename (F -> full, f -> relative)
    let statusline .= "%f"
    " Buffer flags
    let statusline .= "%( %h%1*%m%*%r%w%) "
    " File format and type
    let statusline .= "(%{&ff}%(\/%Y%))"
    " Left/right separator
    let statusline .= "%="
    " Line & column
    let statusline .= "(%l,%c%V) "
    " Character under cursor (decimal)
    let statusline .= "%03.3b "
    " Character under cursor (hexadecimal)
    let statusline .= "0x%02.2B "
    " File progress
    let statusline .= "| %P/%L"
    return statusline
endfunction

let sl=MyStatusLine()
set statusline=%!sl

]]
