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
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... } @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
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
              inherit system;
              specialArgs = {inherit inputs;};
              modules = [ 
                  ./configuration.nix 

                  home-manager.nixosModules.home-manager 

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
