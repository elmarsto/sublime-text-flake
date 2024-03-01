{
  inputs = {
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { flake-utils, gitignore, nixpkgs, ... }: flake-utils.lib.eachDefaultSystem (system:
      let
        app = p: { program = "${p}"; type = "app"; };
        pkgs = import nixpkgs { inherit system; };
        src = gitignore.lib.gitignoreSource ./.;
        st = pkgs.writeShellScript "sublime4" ''
          ${pkgs.sublime4}/bin/sublime $@
        '';
      in
      {
        apps.default = app st;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.sublime4 ];
        };
        packages.default = st;
      }
    );
}
