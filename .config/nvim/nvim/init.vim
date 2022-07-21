set number
set mouse=a
syntax enable
set termguicolors
set background=dark
set winblend=0
set wildoptions=pum
set pumblend=5
set expandtab
set smarttab

autocmd!

if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  " Use NeoSolarized
  let g:neosolarized_termtrans=1
  runtime ./colors/NeoSolarized.vim
  colorscheme NeoSolarized
endif

nnoremap <C-f> <cmd>Telescope find_files<CR>
nnoremap <C-e> :NvimTreeFocus<CR>
nnoremap <C-u> :ToggleTerm<CR>
nnoremap <C-h> :Lspsaga hover_doc<CR>
nnoremap <C-o> :call CocAction('diagnosticInfo')<CR>

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap {<CR> {<CR>}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>


nnoremap <silent> <leader>? :call CocAction('diagnosticInfo') <CR>

runtime plug.vim

lua << EOF
require'lspconfig'.pyright.setup{}
EOF
