# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  user="fredrikr";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./nbfc.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  # boot.kernel.sysctl = {
  #   "net.ipv6.conf.all.disable_ipv6" = 1;
  #   "net.ipv6.conf.default.disable_ipv6" = 1;
  # };

  # DUAL BOOT SETUP
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.loader = {
  #  efi = {
  #    canTouchEfiVariables = true;
  #    efiSysMountPoint = "/boot";
  #  };
  #  grub = {
  #    enable = true;
  #    devices = ["nodev"];
  #    efiSupport = true;
  #    useOSProber = true;                        
  #    configurationLimit = 5;
  #  };
  #  timeout = 3;
  #};   

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
  #  keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ 
          fcitx5-rime 
          fcitx5-mozc 
          fcitx5-gtk
          fcitx5-configtool
          libsForQt5.fcitx5-qt
      ];
  };
  # i18n.inputMethod.fcitx5.engines = with pkgs.fcitx-engines; [ mozc ];
  # i18n.inputMethod = {
  #   enabled = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [ mozc ];
  # };

  # TTY settings
  i18n = {
    # luckily this also changes the keyboard layout at boot (for e.g full disk encryption passwords)
    consoleKeyMap = "dvorak-programmer";
  };

  # GUI settings, this includes login screen
  #services.xserver.layout = "us";
  #services.xserver.xkbVariant = "dvp";
  #services.xserver.xkbOptions = "eurosign:e";
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Enable the X11 windowing system.
  services.autorandr.enable = true;
  services.xserver = {
    enable = true;
    autorun = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 24;
    
    # DVORAK + NO
    layout = "us,no";
    xkbVariant = "dvp,";
    xkbOptions = "compose:menu, grp:alt_shift_toggle, lv3:ralt_switch";

    exportConfiguration = true;

    desktopManager.runXdgAutostartIfNone = true;

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hpkgs: [
          hpkgs.xmobar
          # hpkgs.xmonad_0_17_0
          # hpkgs.xmonad-contrib_0_17_0
          # hpkgs.xmonad-extras_0_17_0
          # hpkgs.xmonad-screenshot
        ];
      };
    };
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm = {
        enable = true;
        greeters.enso = {
          enable = true;
          blur = true;
          extraConfig = ''
            default-wallpaper=/usr/share/nix.png
          '';
        };
      };
      # sessionCommands = '' '';
    };

    libinput = {
      enable = true;

      mouse = {
        accelProfile = "flat";
      };

      touchpad = {
        accelProfile = "flat";
        naturalScrolling = true;
        disableWhileTyping = true;
        accelSpeed = "0.7";
      };
    };

    synaptics = {
      minSpeed = "7.0";
      maxSpeed = "8.0";
    };
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound = {
    # enable = true; deprecated
    # mediaKeys.enable = true; deprecated
  };
  # hardware.pulseaudio.enable = true; use pipewire
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.actkbd = let
  volumeStep = "1%";
in {
  enable = true;
  bindings = [
    # "Mute" media key
    { keys = [ 113 ]; events = [ "key" ];       command = "amixer -q set Master toggle"; }

    # "Lower Volume" media key
    { keys = [ 114 ]; events = [ "key" "rep" ]; command = "amixer -q set Master ${volumeStep}- unmute"; }

    # "Raise Volume" media key
    { keys = [ 115 ]; events = [ "key" "rep" ]; command = "amixer -q set Master ${volumeStep}+ unmute"; }
  ];
};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # hsphfpd.enable = true; handled by pipewire
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    packages = with pkgs; [  # managed by home-manager
      # firefox
      discord
      #tree
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xorg.xkill
    haskellPackages.xmobar
    feh
    trayer
    xclip
    # xorg.xbacklight
    # htop
    usbutils
    udiskie
    udisks
    # javaPackages.openjfx17
    libGL
    gtk3
    zathura
    libgcc
    gcc
    gdb
    valgrind-light
    gnumake
    qemu_full
    powertop
    gamemode
    alsa-utils
    acpi
    # fcitx5
    # fcitx5-configtool
    dolphin
  ]);

  programs.steam.enable = true;

  programs.gamemode.enable = true;

  # nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3389 5900 ]; # rdp port
    # trustedInterfaces = [ 
    #   "wlp0s20f3"
    #   "lo" 
    #   "enp1s0" 
    # ];
    # extraCommands = ''
    #   iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
    # '';
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  # OVERLAYS

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
	  sha256 = "0k9sk5pmjw7xq68h2s80q8fg48p31albrqrqafmmrxik5f8f96rn";
        }; }
      ); 
    })
  ];

  nix = {
    # package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.picom = {
      enable = true;
      vSync = true;
      settings = {
        backend = "glx";
        blur = {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
      };
  };

  # systemd.services.background-image = {
  #   wantedBy = [ "multi-user.target" ];
  #   enable = true;
  #   serviceConfig = {
  #     User = "root";
  #     Group = "root";
  #     Type = "oneshot";
  #     # ExecStart = "~/.fehbg";
  #   };
  #   script = "/home/fredrikr/.fehbg &";
  # };

   # Power button invokes suspend, not shutdown.

  services.logind = {
    # extraConfig = "HandlePowerKey=hibernate";
    lidSwitch = "hybrid-sleep";
    powerKey = "hibernate";
  }; 


  # video acceleration
  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };
  # hardware.opengl = { # hardware.graphics on unstable
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-media-driver # LIBVA_DRIVER_NAME=iHD
  #     intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
  #     libvdpau-va-gl
  #   ];
  # };
  environment.sessionVariables = { 
    # LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # Some applications use GLFW
    INPUT_METHOD = "fcitx";
  }; 

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };


  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  fonts = {
    # enableDefaultFonts = true;

    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "Monoid" ]; })
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];

    fonts = with pkgs; [
      noto-fonts
      ubuntu_font_family
      unifont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
    ];
  
    fontconfig = {
      antialias = true;
      # defaultFonts = {
      #   serif = [ "Ubuntu" ];
      #   sansSerif = [ "Ubuntu" ];
      #   monospace = [ "Ubuntu Source" ];
      # };
      # defaultFonts = {
      #   monospace = [ "Monoid" ];
      # };
      defaultFonts = {
        monospace = [
          "DejaVu Sans Mono"
          "IPAGothic"
        ];
        sansSerif = [
          "DejaVu Sans"
          "IPAPGothic"
        ];
        serif = [
          "DejaVu Serif"
          "IPAPMincho"
        ];
      };
    };
  };

    xdg.mime = {
        enable = true;
        defaultApplications = {
            "application/pdf" = "org.pwmt.zathura.desktop";
        };
    };

  programs.ssh.startAgent = true;

  powerManagement.powertop.enable = true;
  # services.auto-cpufreq.enable = true;
}

