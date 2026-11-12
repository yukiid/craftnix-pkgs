{
  description = "Nix packages for Photocraft and  Effectcraft";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      apps = import ./pkgs.nix { inherit pkgs; };
    in {
      packages.${system} = apps // { default = apps.photocraft; };
    };
}
