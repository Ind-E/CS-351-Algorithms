{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      eachSystem = lib.genAttrs systems;
      pkgsFor = eachSystem (
        system:
        import nixpkgs {
          localSystem.system = system;
        }
      );
    in
    {
      devShells = lib.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python313
            (with python313Packages; [
              pyglm
              manim
              ipython
              matplotlib
            ])
          ];
        };
      }) pkgsFor;
    };
}
