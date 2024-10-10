{ config, pkgs, ... }:

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
            zathura
            python3
            sage
            quickemu
            maven
            vscode-fhs
            anki-bin
            tldr
            ripgrep
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
    };

    home.sessionVariables = {
        EDITOR = "nvim";
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

        colorschemes.nord = {
            enable = true;
            settings = {
                disable_background = true;
            };
        };

        viAlias = true;
        vimAlias = true;

        globals = {
            mapleader = " ";
        };

        opts = {
            termguicolors = true;

            number = true;

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

            colorcolumn = "80";

            ignorecase = true;
            smartcase = true;
        };

        plugins = {
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
                        pylsp.enable = true;
                        nil-ls.enable = true;
                        lua-ls.enable = true;
                        hls.enable = true;
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
            plugins = [ "git" "shrink-path" ];
            theme = "arrow";
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


}
