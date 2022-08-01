{ config, pkgs, nixos, lib, ... }:
let
  material-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "material-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "marko-cerovac";
      repo = "material.nvim";
      rev = "9ada17bb847a83f8356934a314a793bfe3c9a712";
      sha256 = "0rzpzr7l1fnd2fbx891s4zlxq87cm5rl4sw6ma9cf3szycll8sgc";
      fetchSubmodules = true;
    };
  };

  coc-elixir = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "coc-elixir";
    src = pkgs.fetchFromGitHub {
      owner = "SkyLeite";
      repo = "coc-elixir";
      rev = "90814bf5fc7cdd12de1409c00ccb9ca3c7b23514";
      sha256 = "09kicc0pxr5x3djbsilx3v6f61mpzvc2hdybva3v6xnva5y2m4hv";
      fetchSubmodules = true;
    };
    # buildInputs = [ pkgs.yarn pkgs.nodejs ];
    # configurePhase = "${pkgs.yarn}/bin/yarn install --offline";
    # buildPhase = "${pkgs.yarn}/bin/yarn prepack";
  };
in {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    coc = {
      enable = true;
      settings = {
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = true;

        "coc.preferences.formatOnSaveFiletypes" = [ ];

        "solargraph.promptDownload" = false;
        "solargraph.autoformat" = true;
        "solargraph.checkGemVersion" = false;

        languageserver = {
          elmLS = {
            command = "elm-language-server";
            filetypes = [ "elm" ];
            rootPatterns = [ "elm.json" ];
            "trace.server" = "verbose";
          };

          haskell = {
            command = "haskell-language-server-wrapper";
            args = [ "--lsp" ];
            rootPatterns = [
              ".stack.yaml"
              ".hie-bios"
              "BUILD.bazel"
              "cabal.config"
              "package.yaml"
            ];
            filetypes = [ "hs" "lhs" "haskell" ];
          };
        };

        "coc.preferences.codeLens.enable" = true;
      };
    };

    plugins = with pkgs.vimPlugins; [
      nerdtree
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight

      {
        plugin = supertab;
        config = ''let g:SuperTabDefaultCompletionType = "<c-n>"'';
      }

      vim-nix
      vim-devicons
      vim-dispatch-neovim
      vim-commentary
      vim-bbye
      vim-elixir
      vim-vue
      vim-elm-syntax
      vim-easymotion
      vim-fsharp
      kotlin-vim
      haskell-vim

      coc-nvim
      coc-solargraph
      coc-html
      coc-css
      coc-eslint
      coc-rust-analyzer
      coc-tsserver
      coc-elixir
      coc-tabnine
      coc-vetur

      plenary-nvim
      telescope-nvim
      material-nvim
      which-key-nvim
      nvim-treesitter
      nord-vim
      targets-vim
      editorconfig-vim
      argtextobj-vim

      auto-pairs
      tagbar
      neoformat
      surround
      neogit
      quick-scope
    ];

    extraConfig = ''
      let mapleader="\<Space>"

      nmap <Escape>

      nnoremap <ESC> :noh<CR><ESC>
      nmap <Leader>t <CMD>TagbarToggle<CR>
      nmap <Leader>op <CMD>NERDTreeToggle<CR>

      nmap <Leader>bk <CMD>Bwipeout<CR>
           
      nmap <Leader><Leader> <CMD>Telescope find_files<CR>
      nmap <Leader>sp       <CMD>Telescope live_grep<CR>
      nmap <Leader>pb       <CMD>Telescope buffers<CR>
      nmap <Leader>pt       <CMD>Telescope help_tags<CR>

      nmap <Leader>wh <C-w>h
      nmap <Leader>wj <C-w>j
      nmap <Leader>wk <C-w>k
      nmap <Leader>wl <C-w>l

      nmap <Leader>ca <CMD>CocAction<CR>
      nmap <Leader>cd <Plug>(coc-definition)
      nmap <Leader>cD <Plug>(coc-type-definition)
      nmap <Leader>cr <Plug>(coc-references)
      nmap <Leader>cR <Plug>(coc-rename)
      nmap <Leader>ci <Plug>(coc-implementation)

      nmap <Leader>gg <CMD>Neogit<CR>

      map  gs         <Plug>(easymotion-prefix)

      nmap <Leader>ri <CMD>source ~/.config/nvim/init.vim<CR>
      nmap <Leader>rh <CMD>!home-manager switch<CR>

      "" Ctags
      let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'

      "" Neoformat
      augroup fmt
        autocmd!
        autocmd BufWritePre * Neoformat
      augroup END 

      "" Coc
      set encoding=utf-8
      set hidden
      set nobackup
      set nowritebackup
      set cmdheight=2
      set updatetime=300
      set shortmess+=c

      " Use K to show documentation in preview window
      nnoremap <silent> K <CMD>call <SID>show_documentation()<CR>

      " Confirm completion with <CR> / Enter
      inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

      set nu
      set rnu
      set timeoutlen=500

      "" Use terminal background
      function! MyHighlights() abort
          highlight Normal ctermbg=none guibg=none
      endfunction

      augroup MyColors
          autocmd!
          autocmd ColorScheme * call MyHighlights()
      augroup END

      let g:material_style = 'darker'
      colorscheme material
    '';

    extraPackages = [
      pkgs.silver-searcher
      pkgs.universal-ctags
      pkgs.fd
      pkgs.elixir_ls
      #pkgs.dotnetPackages.FSharpAutoComplete
    ];
  };
}
