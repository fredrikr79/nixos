{ config, pkgs, inputs, lib, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  home.username = "fredrikr";
  home.homeDirectory = "/home/fredrikr";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    htop
    dmenu
    alacritty
    # discord
    scrot
    brightnessctl
    python3
    sage
    quickemu
    maven
    vscode-fhs
    anki-bin
    tldr
    ripgrep
    xournalpp
    obsidian
    redshift
    pandoc
    typst
    # typstfmt
    typstyle
    uiua386
    uiua
    byzanz
    python3Packages.mdformat
    prismlauncher # minecraft
    ghc
    monocraft
    zsh-syntax-highlighting
    unityhub
    dotnet-sdk
    omnisharp-roslyn
    # emacs
    fd
    shellcheck
    cmigemo
    nodejs_22
    cmake
    clang-tools
    glslang
    csharpier
    haskell-language-server
    haskellPackages.hoogle
    cabal-cli
    nixfmt
    black
    python312Packages.pyflakes
    isort
    pipenv
    python312Packages.nose2
    python312Packages.pytest
    python312Packages.setuptools
    shfmt
    libtool
    tinymist
    emacsPackages.treesit-grammars.with-all-grammars
    librewolf
    cargo
    vulkan-tools
    mesa.drivers
    vulkan-loader
    python312Packages.python-lsp-server
    editorconfig-core-c
    inputs.zen-browser.packages."${system}".default
    fzf
    zoxide
    libgit2
    python312Packages.debugpy
    lldb
    nodePackages.prettier
    jujutsu
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/alacritty".source = home/config/alacritty;
    ".config/xmonad".source = home/config/xmonad;
    ".xmobarrc".source = home/.xmobarrc;
    ".config/xournalpp/plugins/vi-xournalpp" = {
      source = "${inputs.vi-xournalpp}";
      recursive = true;
    };
    ".config/gdb/gdbinit".source = home/config/gdb/gdbinit;
    # ".emacs.d".source = home/emacs.d;
    # ".config/emacs".source = home/config/emacs;
    ".doom.d".source = home/doom.d;
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  home.sessionPath = [ "/home/fredrikr/.config/emacs/bin/" ];

  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    keymaps = [
      # { # managed by easyescape plugin
      #   key = "jk";
      #   action = "<esc>";
      #   mode = [ "i" ];
      #   options = { noremap = true; };
      # }

      {
        key = "<leader>pv";
        action = ":Ex<cr>";
        mode = [ "n" ];
      }

      {
        key = "n";
        action = "nzzzv";
        mode = [ "n" ];
      }

      {
        key = "N";
        action = "Nzzzv";
        mode = [ "n" ];
      }

      {
        key = "<leader>u";
        action = ":UndotreeToggle<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>cs";
        action = ":ClangdSwitchSourceHeader<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>cff";
        action = ":Format<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>cfd";
        action = ":FormatDisable<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>cfe";
        action = ":FormatEnable<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>cft";
        action = ":FormatToggle<cr>";
        mode = [ "n" ];
      }

      {
        key = "<leader>w";
        action = "<C-w>";
        mode = [ "n" ];
      }

      # {
      #   key = "<leader>cp";
      #   action = ":CopilotChatToggle<cr>";
      #   mode = [ "n" ];
      # }
      #
      # {
      #   key = "<leader>gg";
      #   action = ":Fugit2<cr>";
      #   mode = [ "n" ];
      # }
      #
      # {
      #   key = "<leader>gl";
      #   action = ":Fugit2Graph<cr>";
      #   mode = [ "n" ];
      # }
      #
      # {
      #   key = "<leader>gb";
      #   action = ":Fugit2Blame<cr>";
      #   mode = [ "n" ];
      # }
      #
      # {
      #   key = "<leader>gd";
      #   action = ":Fugit2Diff<cr>";
      #   mode = [ "n" ];
      # }
      #
      # {
      #   key = "<leader>cdb";
      #   action = ":DBUIToggle<cr>";
      #   mode = [ "n" ];
      # }
      #
      {
        key = "<leader>cm";
        action = ":CompilerOpen<cr>";
        mode = [ "n" ];
        options = { 
          noremap = true; 
          silent = true; 
        };
      }

      {
        key = "<leader>cc";
        action = ":CompilerStop<cr>:CompilerRedo<cr>";
        mode = [ "n" ];
        options = {
          noremap = true; 
          silent = true; 
        };
      }

      {
        key = "<leader>ct";
        action = ":CompilerToggleResults<cr>";
        mode = [ "n" ];
        options = {
          noremap = true; 
          silent = true; 
        };
      }

      {
        key = "<leader>y";
        action = "\"+y";
        mode = [ "n" "v" ];
        options = {
          noremap = true;
          silent = true;
        };
      }

      {
        key = "<C-backspace>";
        action = "<C-w>";
        mode = [ "i" ];
      }

      {
        key = "<C-h>";
        action = "<C-w>";
        mode = [ "i" ];
      }
    ];

    colorschemes.dracula = {
      enable = true;
      # settings = {
      #     disable_background = true;
      # };
      colorterm = false;
    };

    viAlias = true;
    vimAlias = true;

    globals = { mapleader = " "; };

    opts = {
      termguicolors = true;

      number = true;
      # relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;

      swapfile = false;
      backup = false;
      undofile = true;

      hlsearch = false;
      incsearch = true;

      scrolloff = 8;

      signcolumn = "yes";

      updatetime = 50;

      textwidth = 80;
      formatoptions = "tcqjn1"; # auto-format
      # colorcolumn = "81";
      wrap = false;

      ignorecase = true;
      smartcase = true;

      foldlevel = 99;
    };

    plugins = {
      conform-nvim = {
        enable = true;

        settings = {
          format_on_save = {
            timeoutMs = 500;
            lspFallback = true;
          };
        };

        formattersByFt = {
          typst = [ "typstyle " ]; # "typstfmt"];
          python = [ "black" ];
          markdown = [ "prettier" ];
        };

        formatters = {
          prettier = {
            command = "prettier";
            filetypes = [ "markdown" ];
          };
          # typstfmt = {
          #     command = "typstfmt";
          #     filetypes = ["typst"];
          # };
          typstyle = {
            command = "typstyle";
            filetypes = [ "typst" ];
          };
          black = {
            command = "black";
            filetypes = [ "python" ];
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          sections = {
            # lualine_z = [ ''
            #       { 
            #         function() return require("battery").get_status_line() end
            #       }
            # '' ];
          };
        };
        # luaConfig.pre = ''
        #   require("battery").setup({
        #       update_rate_seconds = 30,           -- Number of seconds between checking battery status
        #       show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
        #       show_plugged_icon = true,           -- If true show a cable icon alongside the battery icon when plugged in
        #       show_unplugged_icon = true,         -- When true show a diconnected cable icon when not plugged in
        #       show_percent = true,                -- Whether or not to show the percent charge remaining in digits
        #       vertical_icons = true,              -- When true icons are vertical, otherwise shows horizontal battery icon
        #       multiple_battery_selection = "min", -- Which battery to choose when multiple found. "max" or "maximum", "min" or "minimum" or a number to pick the nth battery found (currently linux acpi only)
        #   });
        # '';
      };

      coq-nvim.enable = true;

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          experimental = { ghost_text = true; };
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          snippet = { expand = "luasnip"; };
          formatting = { fields = [ "kind" "abbr" "menu" ]; };
          sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            { name = "emoji"; }
            # {
            #   name = "buffer"; # text within current buffer
            #   option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            #   keywordLength = 3;
            # }
            {
              name = "calc";
            }
            {
              name = "conventionalcommits";
            }
            {
              name  = "treesitter"; # treesitter
            }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
            # {
            #   name = "copilot";
            # }
            # {
            #   name = "dadbod";
            # }
          ];

          window = {
            completion = {
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
              scrollbar = false;
              sidePadding = 0;
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
            };

            settings.documentation = {
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
            };
          };

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" =
              "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      cmp-nvim-lsp = { enable = true; }; # lsp
      # cmp-buffer = { enable = true; };
      cmp-treesitter = { enable = true; };
      cmp-path = { enable = true; }; # file system paths
      cmp_luasnip = { enable = true; }; # snippets
      cmp-cmdline = { enable = true; }; # autocomplete for cmdline
      cmp-conventionalcommits = { enable = true; };
      cmp-calc = { enable = true; };

      lsp-format.enable = true;

      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
            "<leader>e" = "open_float";
          };
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Goto Definition";
            };
            gr = {
              action = "references";
              desc = "Goto References";
            };
            gD = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            gI = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            gT = {
              action = "type_definition";
              desc = "Type Definition";
            };
            K = {
              action = "hover";
              desc = "Hover";
            };
            "<leader>cw" = {
              action = "workspace_symbol";
              desc = "Workspace Symbol";
            };
            "<leader>cr" = {
              action = "rename";
              desc = "Rename";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "code action";
            };
          };
        };
        servers = {
          pyright.enable = true;
          nil-ls.enable = true;
          lua-ls.enable = true;
          hls.enable = true;
          tinymist = {
            enable = true;
            settings = {
              exportPdf = "onType";
              fontPaths = [
                "$dir/"
                "./"
                "\${workspaceFolder}/fonts"
                "\${workspaceFolder}/"
              ];
              # formatterMode = "typstfmt";
              formatterMode = "typstyle";
            };
          };
          clangd.enable = true;
          vtsls.enable = true;
          marksman.enable = true;
          uiua.enable = true;
          omnisharp.enable = true;
        };
      };

      friendly-snippets.enable = true;
      luasnip.enable = true;

      harpoon = {
        enable = true;
        keymaps = {
          navFile = {
            "1" = "<C-h>";
            "2" = "<C-t>";
            "3" = "<C-n>";
            "4" = "<C-s>";
          };
          addFile = "<leader>ha";
          toggleQuickMenu = "<leader>hl";
        };
      };

      treesitter = { enable = true; };

      undotree.enable = true;

      comment.enable = true;

      surround.enable = true;

      presence-nvim.enable = true;

      which-key.enable = true;

      nvim-jdtls = {
        enable = true;
        data = "/home/fredrikr/.cache/jdtls/workspace";
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader> " = "find_files";
          "<leader>/" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      gitsigns.enable = true;

      typst-vim = {
        enable = true;
        settings = {
          pdf_viewer = null;
          conceal_math = null;
        };
      };

      sleuth.enable = true;

      # hardtime.enable = true;  # the dark souls of vim

      diffview = {
        enable = true;
        view.mergeTool.layout = "diff3_mixed";
      };

      markview = { enable = true; };

      rainbow-delimiters = {
        enable = true;
        highlight = [
          "DraculaRed" # "RainbowDelimiterRed"
          "DraculaYellow" # "RainbowDelimiterYellow"
          "DraculaBlue" # "RainbowDelimiterBlue"
          "DraculaOrange" # "RainbowDelimiterOrange"
          "DraculaGreen" # "RainbowDelimiterGreen"
          "DraculaViolet" # "RainbowDelimiterViolet"
          "DraculaCyan" # "RainbowDelimiterCyan"
        ];
      };

      # copilot-lua.enable = true;
      # copilot-cmp.enable = true;
      # copilot-chat.enable = true;
      #
      # fugit2 = {
      #   enable = true;
      #   settings.external_diffview = true;
      # };

      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
          };
          open_mapping = "[[<leader>ot]]";
          insert_mappings = false;
          close_on_exit = false;
        };
      };

      # autoclose.enable = true;
      #
      # leap = {
      #   enable = true;
      # };

      direnv.enable = true;


      smartcolumn = {
        enable = true;
        settings = {
          colorcolumn = "80";
          disabled_filetypes = [
            "checkhealth"
            "help"
            "lspinfo"
            "markdown"
            "neo-tree"
            "noice"
            "text"
          ];
          scope = "window";
        };
      };

      # zen-mode = {
      #   enable = true;
      #   settings = {
      #     window = {
      #       width = 92;
      #     };
      #   };
      # };
      #
      # twilight.enable = true;
      #
      # telekasten.enable = true;

      fzf-lua.enable = true;

      overseer = {  # depended on by compiler.nvim
        enable = true;
        settings = {
          strategy = "toggleterm";
        };
      };

      fidget = {
        enable = true;
        settings =
        {
          notification = {
            window = {
              winblend = 0;
            };
          };
          progress = {
            display = {
              done_icon = "";
              done_ttl = 7;
              format_message = inputs.nixvim.lib.nixvim.mkRaw "function(msg)\n  if string.find(msg.title, \"Indexing\") then\n    return nil -- Ignore \"Indexing...\" progress messages\n  end\n  if msg.message then\n    return msg.message\n  else\n    return msg.done and \"Completed\" or \"In progress...\"\n  end\nend\n";
            };
          };
        };
      };

      easyescape = {
        enable = true;
        settings = {
          chars = { 
            j = 1;
            k = 1;
          };
          timeout = 100;
        };
      };

      # debugprint.enable = true;

      # dap = {
      #   enable = true;
      #   adapters = {
      #     # gdb = {
      #     #   type = "executable";
      #     #   command = "gdb";
      #     #   name = "gdb";
      #     # };
      #   };
      #   configurations = {
      #     # cpp = [
      #     #   {
      #     #     name = "Launch file";
      #     #     type = "gdb";
      #     #     request = "launch";
      #     #     program = "''\${workspaceFolder}/a.out";
      #     #     cwd = "''\${workspaceFolder}";
      #     #     stopOnEntry = false;
      #     #     args = [];
      #     #   }
      #     # ];
      #   };
      # };
      # dap-virtual-text = {
      #   enable = true;
      #   settings = {
      #     commented = true;
      #   };
      # };
      # dap-ui = {
      #   enable = true;
      #   settings = {
      #     icons = {
      #       expanded = "▾";
      #       collapsed = "▸";
      #     };
      #   };
      # };
      # dap-python.enable = true;
      # dap-lldb.enable = true;

      cursorline.enable = true;

      compiler.enable = true;

      committia.enable = true;

      colorizer.enable = true;

      web-devicons.enable = true;

      # dashboard = {
      #   enable = true;
      #   settings = {
      #     change_to_vcs_root = true;
      #     config = {
      #       footer = [
      #         "Made with ❤️"
      #       ];
      #       header = [
      #           "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
      #           "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
      #           "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
      #           "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
      #           "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
      #           "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
      #       ];
      #       mru = {
      #         limit = 20;
      #       };
      #       project = {
      #         enable = false;
      #       };
      #       shortcut = [
      #       {
      #         action = {
      #           __raw = "function(path) vim.cmd('Telescope find_files') end";
      #         };
      #         desc = "Files";
      #         group = "Label";
      #         icon = " ";
      #         icon_hl = "@variable";
      #         key = "f";
      #       }
      #       ];
      #       week_header = {
      #         enable = true;
      #       };
      #     };
      #     theme = "hyper";
      #   };
      # };

      # vim-dadbod.enable = true;
      # vim-dadbod-completion.enable = true;
      # vim-dadbod-ui.enable = true;

      nvim-ufo.enable = true; # folds
    };
    extraConfigLua = ''
      luasnip = require("luasnip")

      kind_icons = {
          Text = "󰊄",
          Method = "",
          Function = "󰡱",
          Constructor = "",
          Field = "",
          Variable = "󱀍",
          Class = "",
          Interface = "",
          Module = "󰕳",
          Property = "",
          Unit = "",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
      }
    '';

    # extraPlugins = [
    #   (pkgs.neovimUtils.buildNeovimPlugin {
    #    luaAttr = pkgs.lua51Packages.buildLuarocksPackage {
    #      pname = "battery.nvim";
    #      version = "scm-1";
    #      src = pkgs.fetchFromGitHub {
    #        owner = "justinhj";
    #        repo = "battery.nvim";
    #        rev = "5b0fc97f8ae29ddd2668eced7f352337d5d07f52";
    #        sha256 = "sha256-RgCk/BFi8vb6SAq6NchcRm/Lshvvw7hymxGNY0A+M1U=";
    #      };
    #      propagatedBuildInputs = [ 
    #        pkgs.lua51Packages.plenary-nvim
    #      ];
    #      disabled = pkgs.lua51Packages.lua.luaversion != "5.1";
    #      knownRockspec = pkgs.writeText "battery.nvim-scm-1.rockspec" ''
    #        package = "battery.nvim"
    #        version = "scm-1"
    #        source = {
    #          url = "git://github.com/justinhj/battery.nvim",
    #        }
    #        dependencies = {
    #          "lua == 5.1",
    #          "plenary.nvim",
    #        }
    #        build = {
    #          type = "builtin",
    #          modules = {
    #            battery = "lua/battery/battery.lua",
    #          },
    #          copy_directories = {
    #            "doc",
    #            "plugin",
    #          }
    #        }
    #      '';
    #    };
    #    nvimRequiredCheck = "battery";
    #  })
    # ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "shrink-path" "direnv" ];
      # theme = "";
    };

    zplug = {
      enable = true;
      plugins = [{
        name = "dracula/zsh";
        tags = [ "as:theme" ];
      }];
    };

    shellAliases = {
      hibernate = "systemctl hibernate";
      suspend = "systemctl suspend";
      logout = "sudo pkill -u fredrikr";
      lock = "/home/fredrikr/.logout.sh";
      n = "nvim";
      e = "emacsclient -c -a 'emacs'";
    };

    defaultKeymap = "viins";

    zsh-abbr.enable = true;

    syntaxHighlighting = {
      highlighters = [ "main" "cursor" ];
      styles = { # dracula
        "comment" = "fg=#6272A4";
        "alias" = "fg=#50FA7B";
        "suffix-alias" = "fg=#50FA7B";
        "global-alias" = "fg=#50FA7B";
        "function" = "fg=#50FA7B";
        "command" = "fg=#50FA7B";
        "precommand" = "fg=#50FA7B,italic";
        "autodirectory" = "fg=#FFB86C,italic";
        "single-hyphen-option" = "fg=#FFB86C";
        "double-hyphen-option" = "fg=#FFB86C";
        "back-quoted-argument" = "fg=#BD93F9";
        "builtin" = "fg=#8BE9FD";
        "reserved-word" = "fg=#8BE9FD";
        "hashed-command" = "fg=#8BE9FD";
        "commandseparator" = "fg=#FF79C6";
        "command-substitution-delimiter" = "fg=#F8F8F2";
        "command-substitution-delimiter-unquoted" = "fg=#F8F8F2";
        "process-substitution-delimiter" = "fg=#F8F8F2";
        "back-quoted-argument-delimiter" = "fg=#FF79C6";
        "back-double-quoted-argument" = "fg=#FF79C6";
        "back-dollar-quoted-argument" = "fg=#FF79C6";
        "command-substitution-quoted" = "fg=#F1FA8C";
        "command-substitution-delimiter-quoted" = "fg=#F1FA8C";
        "single-quoted-argument" = "fg=#F1FA8C";
        "single-quoted-argument-unclosed" = "fg=#FF5555";
        "double-quoted-argument" = "fg=#F1FA8C";
        "double-quoted-argument-unclosed" = "fg=#FF5555";
        "rc-quote" = "fg=#F1FA8C";
        "dollar-quoted-argument" = "fg=#F8F8F2";
        "dollar-quoted-argument-unclosed" = "fg=#FF5555";
        "dollar-double-quoted-argument" = "fg=#F8F8F2";
        "assign" = "fg=#F8F8F2";
        "named-fd" = "fg=#F8F8F2";
        "numeric-fd" = "fg=#F8F8F2";
        "unknown-token" = "fg=#FF5555";
        "path" = "fg=#F8F8F2";
        "path_pathseparator" = "fg=#FF79C6";
        "path_prefix" = "fg=#F8F8F2";
        "path_prefix_pathseparator" = "fg=#FF79C6";
        "globbing" = "fg=#F8F8F2";
        "history-expansion" = "fg=#BD93F9";
        "back-quoted-argument-unclosed" = "fg=#FF5555";
        "redirection" = "fg=#F8F8F2";
        "arg0" = "fg=#F8F8F2";
        "default" = "fg=#F8F8F2";
        "cursor" = "standout";
      };
    };

    initExtra = ''
      bindkey -v
      export TERM=xterm-256color
    '' + "\n" + builtins.readFile ./jujutsuzsh.lotsofcode;
  };

  programs.git = {
    enable = true;
    userName = "fredrikr79";
    userEmail = "fredrikrobertsen7@gmail.com";
  };

  programs.java = {
    enable = true;
    package = (pkgs.jdk21.override { enableJavaFX = true; });
    # package = pkgs.jdk21;
  };

  programs.direnv = { enable = true; };

  services.redshift = {
    enable = true;

    # Display temperature settings
    temperature = {
      day = 5700;
      night = 3500;
    };

    # Location settings (replace with your coordinates)
    latitude = "63.410927";
    longitude = "10.382032";

    # Schedule settings
    # settings = {
    #     dawn-time = "6:00-7:45";
    #     dusk-time = "18:35-20:15";
    # };

    # General settings
    # brightness = {
    #     day = "1";
    #     night = "0.8";
    # };

    # extraOptions = [
    #     "-v"
    #     "-m randr"
    # ];
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 2;
      background_opacity = "0.85";
      background_blur = 5;
      disable_ligatures = "cursor";
      # symbol_map = let
      #   mappings = [
      #     "U+23FB-U+23FE"
      #     "U+2B58"
      #     "U+E200-U+E2A9"
      #     "U+E0A0-U+E0A3"
      #     "U+E0B0-U+E0BF"
      #     "U+E0C0-U+E0C8"
      #     "U+E0CC-U+E0CF"
      #     "U+E0D0-U+E0D2"
      #     "U+E0D4"
      #     "U+E700-U+E7C5"
      #     "U+F000-U+F2E0"
      #     "U+2665"
      #     "U+26A1"
      #     "U+F400-U+F4A8"
      #     "U+F67C"
      #     "U+E000-U+E00A"
      #     "U+F300-U+F313"
      #     "U+E5FA-U+E62B"
      #   ];
      # in
      #   (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      cursor_trail = 3;
    };
    font.name = "Monocraft Nerd Font";
    font.size = 16;
    # font.package = pkgs.monocraft;
    shellIntegration.enableZshIntegration = true;
    theme = "Dracula";
  };

  programs.emacs = {
    enable = true;
    # defaultEditor = true;
    package = pkgs.emacs-gtk;
    # extraConfig = "home/config/emacs/.doomrc";
  };
  services.emacs.enable = true;


  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
          '';
      }
      {
        plugin = tmuxPlugins.session-wizard;
      }
      {
        plugin = tmuxPlugins.battery;
        extraConfig = ''
          set -g status-right '#{battery_percentage} | %a %h-%d %H:%M '
        '';
      }
    ];
    shell = "${pkgs.zsh}/bin/zsh";
    newSession = true;
    terminal = "kitty";
  };
}
