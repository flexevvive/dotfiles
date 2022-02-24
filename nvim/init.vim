" Basic Settings: {{{
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

" Indentation problem solved
set nosmartindent
set cindent
set cinkeys-=0#
set indentkeys-=0#
autocmd FileType * set cindent "some file types override it"

let mapleader = " "
" }}}

" FLEX Settings: {{{
function Flex()
    set ft=json
    highlight! link jsonCommentError Comment
endfunction

augroup FLEX
    autocmd BufNewFile,BufRead *.flex call Flex()
    autocmd BufnewFile,BufRead *.flex.json call Flex()
augroup END
" }}}

" Colorscheme: {{{
function Colorscheme()
    hi! link SignColumn Normal
    hi! CursorLine gui=underline
    hi! Visual guibg=#ffffff guifg=#000000
    hi! link PMenuSel Visual

    return
endfunction

augroup COLORS
    autocmd Colorscheme * call Colorscheme()
augroup END

colorscheme hyper
" }}}

" Plugins: {{{
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-dispatch'

Plug 'editorconfig/editorconfig-vim'

Plug 'windwp/nvim-autopairs'
Plug 'alvan/vim-closetag'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp',
Plug 'hrsh7th/cmp-buffer',
Plug 'hrsh7th/cmp-path',
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'tami5/lspsaga.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'rcarriga/nvim-notify'

Plug 'ThePrimeagen/harpoon'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sbdchd/neoformat'

call plug#end()
filetype plugin indent on " Weird indentation problem
" }}}

" EditorConfig: {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}}

" Formatting: {{{
augroup FORMATTING
    autocmd BufWritePre * :%s/\s\+$//e
augroup END
" }}}

" Statusline: {{{
function! StatusLine()
    let g:statusline = ""
    " Filename (F -> full, f -> relative)
    let g:statusline .= "%f"
    " Buffer flags
    let g:statusline .= "%( %h%1*%m%*%r%w%) "
    " File format and type
    let g:statusline .= "(%{&ff}%(\/%Y%))"
    " Left/right separator
    let g:statusline .= "%="
    " Line & column
    let g:statusline .= "(%l,%c%V) "
    " Character under cursor (decimal)
    let g:statusline .= "%03.3b "
    " Character under cursor (hexadecimal)
    let g:statusline .= "0x%02.2B "
    " File progress
    let g:statusline .= "| %P %L"

    set statusline=%!statusline

    return
endfunction

call StatusLine()
" }}}

" Netrw: {{{
let g:netrw_banner=1        " enable banner
let g:netrw_liststyle=3     " tree view
" hide gitignore'd files
let g:netrw_list_hide=netrw_gitignore#Hide()
" }}}

" Dispatch: {{{
augroup DISPATCH
    autocmd FileType python let b:dispatch = 'python3 %'
    " autocmd FileType typescript let b:dispatch = 'tsc && node ./out/main.js'
    autocmd FileType javascript let b:dispatch = 'node %'
augroup END
" }}}

" Autopairs: {{{
lua <<EOF
    require("nvim-autopairs").setup{}
EOF
" }}}

" Autoclose Tag: {{{
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,php'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {}

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
" }}}

" Autocompletition LSP: {{{
lua <<EOF
    local cmp = require'cmp'

    cmp.setup {
        mapping = {},
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
        capabilities = capabilities
    }

    require('lspconfig').pylsp.setup {
        capabilities = capabilities
    }

    require('lspconfig').tsserver.setup {
        capabilities = capabilities
    }

    require('lspconfig').clangd.setup {
        capabilities = capabilities
    }
EOF
" }}}

" Lspsaga: {{{
lua <<EOF
    local lspsaga = require('lspsaga')

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
EOF
" }}}

" Telescope: {{{
lua <<EOF
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
            "__pycache__",
            "node_modules"
        }
    }

EOF
" }}}

" Treesitter: {{{
lua <<EOF
    local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "lua",
            "python",
            "vim",
            "markdown",
            "latex",
            "javascript",
            "jsdoc"
        },
        sync_install = false,

        highlight = {
            enable = true,
        }
    }
EOF
" }}}

" Mappings: {{{
nnoremap <silent> <leader>gg :Git<CR>
nnoremap <silent> <leader>gp :Git push<CR>

nnoremap <silent> <leader>d :Dispatch<CR>

nnoremap <silent> <leader>f :Neoformat<CR>

nnoremap <silent> <leader>e :e .<CR>

nnoremap <silent> <leader>c :Commentary<CR>
vnoremap <silent> <leader>c :Commentary<CR>

nnoremap <silent> <leader>ii :PlugInstall<CR>
nnoremap <silent> <leader>ic :PlugClean<CR>
nnoremap <silent> <leader>ir :so $MYVIMRC<CR>
nnoremap <silent> <leader>ie :e $MYVIMRC<CR>

nnoremap <silent> <C-h> :bn<CR>
nnoremap <silent> <C-l> :bp<CR>
nnoremap <silent> <leader>bd :bd<CR>

vnoremap <silent> < <gv
vnoremap <silent> > >gv

nnoremap <silent> <C-g> :Telescope git_files<CR>
nnoremap <silent> <C-p> :Telescope find_files<CR>
nnoremap <silent> <leader>th :Telescope help_tags<CR>

nnoremap <silent> <leader>ll :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> <leader>ln :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <leader>lp :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <leader>lc :Lspsaga code_action<CR>
nnoremap <silent> <leader>ld :Lspsaga hover_doc<CR>

nnoremap <silent> ,html :-1read $HOME/.config/nvim/snippets/helloworld.html<CR>3j4wcit
nnoremap <silent> ,flex :-1read $HOME/.config/nvim/snippets/helloworld.flex.json<CR>9jA<tab><tab>
nnoremap <silent> ,bsd3 :-1read $HOME/.config/nvim/snippets/LICENSE.BSD<CR>

nnoremap <silent> <leader>lD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>ld :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>lh :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>li :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>lr :lua vim.lsp.buf.references()<CR>

nnoremap <silent> <leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent> <leader>hq :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent> <f13> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent> <f14> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent> <f15> :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent> <f16> :lua require("harpoon.ui").nav_file(4)<CR>

nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <silent> J mzJ`z

inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . "k"
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . "j"

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

nnoremap <silent> <leader>p "+p
" }}}
