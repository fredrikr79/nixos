{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vi-xournalpp = {
        url = "github:raw-bacon/vi-xournalpp";
        flake = false;
    };

    # zen-browser.url = "github:Gurjaka/zen-browser-nix";

    #nbfc-linux = {
      #url = "github:nbfc-linux/nbfc-linux";
      #inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uiua = { 
      url = "github:uiua-lang/uiua";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # qotd = {
    #   url = "git+file:///home/fredrikr/Programming/uiua/qotd";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, uiua, ... } @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # overlays = [ qotd.overlays.default ];
      };
      lib = nixpkgs.lib;
    in 
    {
      nixosConfigurations = {
	#nixos = lib.nixosSystem {
	  #inherit system;
          #specialArgs = {inherit inputs;};
          #modules = [
            #./configuration.nix
          #];
        #};

          fredrikr = lib.nixosSystem {
              inherit system pkgs;
              specialArgs = {inherit inputs;};
              modules = [ 
                  ./configuration.nix 

                  home-manager.nixosModules.home-manager 

                  # qotd.nixosModules.default
                  # {
                  #   services.qotd.enable = true;
                  #   services.qotd.quotes = [ "hei" "hade" ];
                  # }

                  ({ ... }: {
                      home-manager = {
                          useGlobalPkgs = true;
                          useUserPackages = true;
                          backupFileExtension = "backup";
                          users.fredrikr = {
                              imports = [ 
                                  ./home.nix 
                                  nixvim.homeManagerModules.nixvim 
                              ];
                          };
                          extraSpecialArgs = {
                              inherit inputs;
                          };
                      };
                  })
              ];
          };

      };
    };
}
