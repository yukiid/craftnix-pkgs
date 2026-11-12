# craftnix-pkgs

A Nix flake that packages Storytold's Photocraft and Effectcraft desktop apps for Linux x86_64.

This repository fetches the upstream release archives from the official Storytold GitHub releases and wraps them as Nix packages with the required runtime libraries and executable wrappers.

## Included packages

- `photocraft` — Image editing: layers, masks, type, and real PSD files
- `effectcraft` — Motion graphics and visual effects
- `default` — points to `photocraft`

## Requirements

- Nix with flakes enabled
- Linux `x86_64-linux` only

## Quick start

Build either package locally:

```bash
nix build .#photocraft
nix build .#effectcraft
```

Run an app directly:

```bash
nix run .#photocraft
nix run .#effectcraft
```

Install an app to your profile:

```bash
nix profile install .#photocraft
```

Replace `photocraft` with `effectcraft` to install Effectcraft.

## Using in a NixOS flake

Add the input:

```nix
craftnix-pkgs = {
  url = "github:yukiid/craftnix-pkgs";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Add either or both packages to `environment.systemPackages`:

```nix
environment.systemPackages = [
  inputs.craftnix-pkgs.packages.${system}.photocraft
  inputs.craftnix-pkgs.packages.${system}.effectcraft
];
```

## Notes

- Upstream binaries are downloaded from the official Storytold release assets.
- Runtime libraries needed by the GUI apps are added automatically via Nix wrappers.
