{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
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
    # sage
    # quickemu
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
    uiua386
    uiua-unstable
    byzanz
    slop
    prismlauncher # minecraft
    ghc
    monocraft
    # unityhub
    dotnet-sdk
    omnisharp-roslyn
    fd
    shellcheck
    cmigemo
    nodejs_22
    clang-tools
    glslang
    haskellPackages.hoogle
    cabal-cli
    libtool
    # librewolf
    # cargo
    # rustc
    vulkan-tools
    mesa
    vulkan-loader
    editorconfig-core-c
    # inputs.zen-browser.packages."${system}".default
    fzf
    zoxide
    libgit2
    jujutsu
    mpv
    # inputs.uiua.packages."${system}".default
    odin
    unzip
    xf86_input_wacom
    libwacom
    vivaldi
    sage
    godot
    gimp
    krita
    inkscape
    onlyoffice-desktopeditors
    proton-pass
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
    ".doom.d".source = home/doom.d;
    ".config/jj".source = home/config/jj;
    ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
    ".config/nushell/themes".source = home/config/nushell/themes;
    ".config/nushell/quitcd".source = home/config/nushell/quitcd;
    ".local/share/applications/qutebrowser-new.desktop".text = ''
      [Desktop Entry]
      Name=Qutebrowser New Window
      Exec=qutebrowser --target window %u
      Type=Application
      MimeType=text/html
      Icon=qutebrowser
    '';
  };

  xdg.configFile."luakit/userconf.lua".text = ''
    local settings = require "settings"
    settings.window.home_page = "https://kagi.com/"
    local engines = settings.window.search_engines
    engines.kagi = "https://kagi.com/search?q=%s"
    engines.default = engines.kagi
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    MOZ_USE_XINPUT2 = "1";
  };

  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    autoCmd = [
      {
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = [ "*.ua" ];
        command = "setfiletype uiua";
      }
      {
        event = "FileType";
        pattern = [ "uiua" ];
        command = "setlocal commentstring=#\\ %s";
      }
    ];

    diagnostic.settings = {
      # virtual_lines = {
      #   current_line = true;
      # };
      virtual_text = true;
    };

    keymaps = [
      {
        key = "<leader>cpm";
        action = ":lua vim.lsp.buf.execute_command({ command = 'tinymist.pinMain', arguments = { vim.api.nvim_buf_get_name(0) } })<CR>";
        options.silent = true;
        options.desc = "pin main file in tinymist";
      }
      {
        key = "<leader>e";
        action.__raw = "vim.diagnostic.open_float";
        options.silent = true;
        options.desc = "Show Diagnostic";
      }
      {
        key = "<leader>j";
        action.__raw = "vim.diagnostic.goto_next";
        options.silent = true;
        options.desc = "Next Diagnostic";
      }
      {
        key = "<leader>k";
        action.__raw = "vim.diagnostic.goto_prev";
        options.silent = true;
        options.desc = "Previous Diagnostic";
      }

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
        key = "<leader>y";
        action = "\"+y";
        mode = [
          "n"
          "v"
        ];
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

      # harpoon2 syntax
      {
        mode = "n";
        key = "<leader>ha";
        action.__raw = "function() require'harpoon':list():add() end";
      }
      {
        mode = "n";
        key = "<leader>hl";
        action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
      }
      {
        mode = "n";
        key = "<C-h>";
        action.__raw = "function() require'harpoon':list():select(1) end";
      }
      {
        mode = "n";
        key = "<C-t>";
        action.__raw = "function() require'harpoon':list():select(2) end";
      }
      {
        mode = "n";
        key = "<C-n>";
        action.__raw = "function() require'harpoon':list():select(3) end";
      }
      {
        mode = "n";
        key = "<C-s>";
        action.__raw = "function() require'harpoon':list():select(4) end";
      }
    ];

    colorschemes.dracula = {
      enable = true;
      # settings = {
      #     disable_background = true;
      # };
      settings.colorterm = false;
    };

    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
    };

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

    lsp = {
      servers = {
        "*".config.root_markers = [
          ".git"
          ".jj"
        ];
        pyright.enable = true;
        nil_ls.enable = true;
        lua_ls.enable = true;
        hls.enable = true;
        clangd.enable = true;
        vtsls.enable = true;
        marksman.enable = true;
        tinymist = {
          enable = true;
          config = {
            root_markers = [
              "main.typ"
            ];
          };
        };
        uiua = {
          enable = true;
          settings = {
            capabilities = {
              textDocument = {
                semanticTokens = {
                  multilineTokenSupport = true;
                  overlappingTokenSupport = false;
                  serverCancelSupport = true;
                  augmentsSyntaxTokens = true;
                  formats = [ "relative" ];
                  requests = {
                    range = true;
                    full = {
                      delta = true;
                    };
                  };
                  tokenTypes = [
                    "namespace"
                    "type"
                    "class"
                    "enum"
                    "interface"
                    "struct"
                    "typeParameter"
                    "parameter"
                    "variable"
                    "property"
                    "enumMember"
                    "event"
                    "function"
                    "method"
                    "macro"
                    "keyword"
                    "modifier"
                    "comment"
                    "string"
                    "number"
                    "regexp"
                    "operator"
                    "decorator"
                  ];
                  tokenModifiers = [
                    "declaration"
                    "definition"
                    "readonly"
                    "static"
                    "deprecated"
                    "abstract"
                    "async"
                    "modification"
                    "documentation"
                    "defaultLibrary"
                  ];
                };
              };
            };
          };
        };
        omnisharp.enable = true;
        ols.enable = true;
        rust_analyzer.enable = true;
        superhtml.enable = true;
        metals.enable = true;
      };
      keymaps = [
        # LSP buffer actions
        {
          key = "gd";
          lspBufAction = "definition";
          options.desc = "Goto Definition";
        }
        {
          key = "gr";
          lspBufAction = "references";
          options.desc = "Goto References";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "Goto Declaration";
        }
        {
          key = "gI";
          lspBufAction = "implementation";
          options.desc = "Goto Implementation";
        }
        {
          key = "gT";
          lspBufAction = "type_definition";
          options.desc = "Type Definition";
        }
        {
          key = "K";
          lspBufAction = "hover";
          options.desc = "Hover Documentation";
        }
        {
          key = "<leader>cw";
          lspBufAction = "workspace_symbol";
          options.desc = "Workspace Symbol";
        }
        {
          key = "<leader>cr";
          lspBufAction = "rename";
          options.desc = "Rename Symbol";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "Code Action";
        }
      ];
    };

    plugins = {
      lspconfig.enable = true;

      conform-nvim = {
        enable = true;

        settings = {
          format_on_save = {
            timeoutMs = 500;
            lspFallback = true;
          };

          formatters_by_ft = {
            typst = [ "typstyle" ];
            python = [
              "isort"
              "black"
            ];
            markdown = [ "prettier" ];
            html = [ "prettier" ];
            htmldjango = [
              "djlint"
              "prettier"
            ];
            css = [ "prettier" ];
            json = [ "prettier" ];
            nix = [ "nixfmt" ];
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

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          experimental = {
            ghost_text = true;
          };
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          snippet = {
            expand = "luasnip";
          };
          formatting = {
            fields = [
              "kind"
              "abbr"
              "menu"
            ];
          };
          sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            { name = "emoji"; }
            {
              name = "buffer"; # text within current buffer
              # option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              # keywordLength = 3;
            }
            {
              name = "calc";
            }
            {
              name = "conventionalcommits";
            }
            {
              name = "treesitter"; # treesitter
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
              winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
              scrollbar = false;
              sidePadding = 0;
              border = [
                "╭"
                "─"
                "╮"
                "│"
                "╯"
                "─"
                "╰"
                "│"
              ];
            };

            settings.documentation = {
              border = [
                "╭"
                "─"
                "╮"
                "│"
                "╯"
                "─"
                "╰"
                "│"
              ];
              winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
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
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      cmp-nvim-lsp = {
        enable = true;
      }; # lsp
      # cmp-buffer = { enable = true; };
      cmp-treesitter = {
        enable = true;
      };
      cmp-path = {
        enable = true;
      }; # file system paths
      cmp_luasnip = {
        enable = true;
      }; # snippets
      cmp-cmdline = {
        enable = true;
      }; # autocomplete for cmdline
      cmp-conventionalcommits = {
        enable = true;
      };
      cmp-calc = {
        enable = true;
      };

      lsp-format.enable = true;

      friendly-snippets.enable = true;
      luasnip.enable = true;

      harpoon.enable = true;

      treesitter.enable = true;

      undotree.enable = true;

      comment.enable = true;

      vim-surround.enable = true;

      presence.enable = true;

      which-key.enable = true;

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
          pdf_viewer = "zathura";
          conceal_math = 1;
          auto_open_quickfix = 0;
        };
      };

      sleuth.enable = true;

      # hardtime.enable = true;  # the dark souls of vim

      diffview = {
        enable = true;
        settings.view.merge_tool.layout = "diff3_mixed";
      };

      # markview = {
      #   enable = true;
      # };

      rainbow-delimiters.settings = {
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
            "typst"
          ];
          scope = "window";
        };
      };

      fzf-lua.enable = true;

      fidget = {
        enable = true;
        settings = {
          notification = {
            window = {
              winblend = 0;
            };
          };
          progress = {
            display = {
              done_icon = "";
              done_ttl = 7;
              format_message = inputs.nixvim.lib.nixvim.mkRaw ''
                function(msg)
                  if msg.title and string.find(msg.title, "Indexing") then
                    return nil
                  end
                  if msg.message then
                    return msg.message
                  else
                    return msg.done and "Completed" or "In progress..."
                  end
                end
              '';
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

      cursorline.enable = true;

      committia.enable = true;

      colorizer.enable = true;

      web-devicons.enable = true;

      nvim-ufo.enable = true; # folds

      godot.enable = true;

      typst-preview = {
        enable = true;
        settings = {
          # dependencies_bin = {
          #   tinymist = "tinymist";
          #   websocat = "websocat";
          # };
          port = 8000;
          open_cmd = ''qutebrowser "%s" --target window --no-err-windows --loglines 0 --loglevel critical --override-restore --nocolor'';
        };
      };
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

      -- LSP Semantic Token highlighting for Uiua with Dracula colors
      vim.api.nvim_set_hl(0, "@lsp.type.stack_function.uiua", { fg = "#f8f8f2" })
      vim.api.nvim_set_hl(0, "@lsp.type.noadic_function.uiua", { fg = "#ff5555" })
      vim.api.nvim_set_hl(0, "@lsp.type.monadic_function.uiua", { fg = "#50fa7b" })
      vim.api.nvim_set_hl(0, "@lsp.type.dyadic_function.uiua", { fg = "#8be9fd" })
      vim.api.nvim_set_hl(0, "@lsp.type.triadic_function.uiua", { fg = "#bd93f9" })
      vim.api.nvim_set_hl(0, "@lsp.type.monadic_modifier.uiua", { fg = "#f1fa8c" })
      vim.api.nvim_set_hl(0, "@lsp.type.dyadic_modifier.uiua", { fg = "#ff79c6" })
      vim.api.nvim_set_hl(0, "@lsp.type.uiua_number.uiua", { fg = "#ffb86c" })
      vim.api.nvim_set_hl(0, "@lsp.type.uiua_string.uiua", { fg = "#8be9fd" })
      vim.api.nvim_set_hl(0, "@lsp.type.variable.uiua", { fg = "#f8f8f2" })

    '';

    extraPackages = with pkgs; [
      nodePackages.prettier
      typstyle
      csharpier
      haskell-language-server
      nixfmt-rfc-style
      black
      scalafmt
      metals
      python3Packages.pyflakes
      isort
      shfmt
      python3Packages.python-lsp-server
      ols
      djlint
      superhtml
      tinymist
    ];
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "fredrikr79";
      email = "fredrikrobertsen7@gmail.com";
    };
    ignores = [
      ".direnv"
      ".jj"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  services.redshift = {
    enable = true;

    # Display temperature settings
    temperature = {
      day = 5700;
      night = 3000;
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
      background_opacity = "0.5";
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
    themeFile = "Dracula";
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-b"; # default
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-plugins "ssh-session"
          set -g @dracula-show-left-icon session
        '';
      }
      {
        plugin = tmuxPlugins.tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'C-s'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'on'
        '';
      }
    ];
    shell = "${pkgs.nushell}/bin/nu";
    newSession = true;
    terminal = "kitty";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "git.pvv.ntnu.no" = {
        hostname = "git.pvv.ntnu.no";
        user = "gitea";
        addressFamily = "inet";
        port = 2222;
        proxyJump = "hildring";
        addKeysToAgent = "1h";
      };

      "hildring" = {
        hostname = "hildring.pvv.ntnu.no";
        user = "frero";
        addressFamily = "inet";
      };
    };
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./home/config/nushell/config.nu;
    shellAliases = {
      jl = "jj log";
      jla = ''jj log -r "all()"'';
      jll = "jj log --no-pager --limit 5";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$character";

      directory = {
        truncation_length = 1;
        truncate_to_repo = false;
        format = "[$path]($style) ";
        style = "bold cyan";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
        symbol = "";
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };

      # Disable all other modules
      aws.disabled = true;
      gcloud.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;
      package.disabled = true;
      docker_context.disabled = true;
      kubernetes.disabled = true;
      terraform.disabled = true;
      cmd_duration.disabled = true;
      line_break.disabled = true;
      username.disabled = true;
      hostname.disabled = true;
      time.disabled = true;
    };
  };

  home.shell.enableNushellIntegration = true;

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

  services.protonmail-bridge.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  services.dunst = {
    enable = true;
    configFile = ./home/config/dunst/dunstrc;
    iconTheme.package = pkgs.dracula-icon-theme;
    iconTheme.name = "Dracula";
  };

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        hints = {
          bg = "#000000";
          fg = "#ffffff";
        };
        tabs.bar.bg = "#000000";
        webpage.darkmode.enabled = true;
      };
      # tabs.tabs_are_windows = true;
      url.start_pages = [ "https://kagi.com/" ];
      url.default_page = "https://kagi.com/";
    };
    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      g = "https://www.google.com/search?hl=en&q={}";
      DEFAULT = "https://kagi.com/search?q={}";
    };
    keyBindings = {
      normal = {
        ",v" = "spawn mpv {url}";
      };
    };
    perDomainSettings = {
      "accounts.google.com".content.headers.user_agent =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36";
    };
  };

  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # Memory optimization
        "dom.ipc.processCount" = 1;
        "dom.ipc.processCount.webIsolated" = 1;
        "fission.autostart" = false;
        "browser.cache.memory.capacity" = 2097152;

        # Hardware acceleration
        "gfx.webrender.all" = true;
        "media.hardware-video-decoding.force-enabled" = true;

        # UI customization
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;

        # uBlock Origin medium mode (blocks 3rd-party scripts by default)
        "extensions.webextensions.uuids" = ''{"[email protected]":"ublock0"}'';

        # Clean interface
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "browser.tabs.firefox-view" = false;

        # Privacy
        "privacy.resistFingerprinting" = true;
        "dom.security.https_only_mode" = true;
      };

      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
      ];

      # Working minimal userChrome.css (luakit/qutebrowser style)
      userChrome = ''
        @namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);

        /* Hide entire navigation toolbox by default */
        #navigator-toolbox {
          height: 0px !important;
          min-height: 0px !important;
          overflow: hidden !important;
          transition: height 0.2s ease !important;
        }

        /* Show navigation when focused (Ctrl+L works) */
        #navigator-toolbox:focus,
        #navigator-toolbox:focus-within,
        #navigator-toolbox:active {
          height: auto !important;
          overflow: visible !important;
        }

        /* Hide tabs when single tab */
        #tabbrowser-tabs {
          visibility: collapse !important;
        }

        /* Show tabs with multiple tabs */
        #tabbrowser-tabs[overflow="true"],
        #tabbrowser-tabs:not([overflow]) {
          visibility: visible !important;
        }

        /* Clean minimal styling */
        .tabbrowser-tab {
          min-height: 32px !important;
          background: #1d2021 !important;
          color: #ebdbb2 !important;
          border: none !important;
        }

        .tabbrowser-tab[selected="true"] {
          background: #458588 !important;
          color: #1d2021 !important;
        }

        /* Hide unnecessary UI elements */
        #identity-box, #tracking-protection-icon-container,
        #urlbar-zoom-button, #star-button-box,
        #pageActionButton, #pageActionSeparator,
        #firefox-view-button {
          display: none !important;
        }

        /* Remove window decorations */
        .titlebar-buttonbox-container {
          display: none !important;
        }
      '';
    };
  };
}
