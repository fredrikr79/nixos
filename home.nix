{ config, pkgs, inputs, ... }:

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
# firefox
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
            uiua386
            uiua
            byzanz
            python3Packages.mdformat
            typstfmt
            prismlauncher # minecraft
            ghc
            monocraft
            zsh-syntax-highlighting
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
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    programs.firefox = {
        enable = true;

        policies = {
            # about:policies
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value= true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            SearchBar = "unified"; # alternative: "separate"

            # about:support
            ExtensionSettings = {
                "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
                # uBlock Origin:
                "uBlock0@raymondhill.net" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    installation_mode = "force_installed";
                };

                # dark reader
                "addon@darkreader.org" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                    installation_mode = "force_installed";
                };

                # kagi
                "search@kagi.com" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
                    installation_mode = "force_installed";
                };

                # vimium
                "vimium-store@googlegroups.com" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
                    installation_mode = "force_installed";
                };
            };

            # about:config
            Preferences = {
                "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
                "extensions.pocket.enabled" = lock-false;
                "extensions.screenshots.disabled" = lock-true;
                "browser.topsites.contile.enabled" = lock-false;
                "browser.formfill.enable" = lock-false;
                "browser.search.suggest.enabled" = lock-false;
                "browser.search.suggest.enabled.private" = lock-false;
                "browser.urlbar.suggest.searches" = lock-false;
                "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
                "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
                "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
                "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
                "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
                "browser.newtabpage.activity-stream.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
            };
        };
    };

    programs.home-manager.enable = true;

    programs.nixvim = {
        enable = true;
        defaultEditor = true;

        keymaps = [
        {
            key = "jk";
            action = "<esc>";
            mode = [ "i" ];
            options = {
                noremap = true;
            };
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

        globals = {
            mapleader = " ";
        };

        opts = {
            termguicolors = true;

            number = true;
            relativenumber = true;

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
            formatoptions = "tcqjn1";  # auto-format
            colorcolumn = "81";

            ignorecase = true;
            smartcase = true;
        };

        plugins = {
            conform-nvim = {
                enable = true;

                # deprecated
                # formatOnSave = {
                #     timeoutMs = 500;
                #     lspFallback = true;
                # };

                formattersByFt = {
                    typst = ["typstfmt"];
                    python = ["black"];
                    markdown = ["prettier"];
                };

                formatters = {
                    prettier = {
                        command = "prettier";
                        filetypes = ["markdown"];
                    };
                    typstfmt = {
                        command = "typstfmt";
                        filetypes = ["typst"];
                    };
                    black = {
                        command = "black";
                        filetypes = ["python"];
                    };
                };
            };

            lualine.enable = true;

            coq-nvim.enable = true;

            cmp = {
                enable = true;
                settings = {
                    autoEnableSources = true;
                    experimental = {ghost_text = true;};
                    performance = {
                        debounce = 60;
                        fetchingTimeout = 200;
                        maxViewEntries = 30;
                    };
                    snippet = {expand = "luasnip";};
                    formatting = {fields = ["kind" "abbr" "menu"];};
                    sources = [
                    {name = "git";}
                    {name = "nvim_lsp";}
                    {name = "emoji";}
                    {
                        name = "buffer"; # text within current buffer
                            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                        keywordLength = 3;
                    }
                    {
                        name = "path"; # file system paths
                            keywordLength = 3;
                    }
                    {
                        name = "luasnip"; # snippets
                            keywordLength = 3;
                    }
                    ];

                    window = {
                        completion = {
                            winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
                            scrollbar = false;
                            sidePadding = 0;
                            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
                        };

                        settings.documentation = {
                            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
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

            cmp-nvim-lsp = {enable = true;}; # lsp
            cmp-buffer = {enable = true;};
            cmp-path = {enable = true;}; # file system paths
            cmp_luasnip = {enable = true;}; # snippets
            cmp-cmdline = {enable = true;}; # autocomplete for cmdline


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
                                "$\{workspaceFolder}/fonts"
                                "$\{workspaceFolder}/"
                            ];
                            # formatterMode = "typstfmt";
                        };
                    };
                    clangd.enable = true;
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

            treesitter.enable = true;

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
                    "<leader>ff" = "find_files";
                    "<leader>fg" = "live_grep";
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

            hardtime.enable = true;

            diffview = {
                enable = true;
                view.mergeTool.layout = "diff3_mixed";
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
        '';
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
            plugins = [
                { name = "dracula/zsh"; tags = [ "as:theme" ]; }
            ];
        };

        shellAliases = {
            hibernate = "systemctl hibernate";
            suspend = "systemctl suspend";
            logout = "sudo pkill -u fredrikr";
            lock = "/home/fredrikr/.logout.sh";
        };

        defaultKeymap = "viins";
        initExtra = ''
            bindkey -v
            bindkey -M viins 'jk' vi-cmd-mode
            '';

        zsh-abbr.enable = true;

        syntaxHighlighting = {
            highlighters = ["main" "cursor"];
            styles = {  # dracula
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

    programs.direnv = {
        enable = true;
    };

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
        # dynamic_background_opacity = true;
        enable_audio_bell = false;
        mouse_hide_wait = "-1.0";
        window_padding_width = 2;
        background_opacity = "0.7";
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
      };
      font.name = "monocraft";
      font.size = 16;
      font.package = pkgs.monocraft;
      shellIntegration.enableZshIntegration = true;
      theme = "Dracula";
    };
}
