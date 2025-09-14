{
  pkgs ?
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz";
      })
      {
        overlays = [
          (import (
            builtins.fetchTarball {
              url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
            }
          ))
        ];
      },
}:

pkgs.mkShell {
  strictDeps = true;
  nativeBuildInputs = with pkgs; [
    rust-bin.stable.latest.default
    rust-bin.nightly.latest.rust-analyzer
    rustPlatform.bindgenHook

    python313
    (with python313Packages; [
      matplotlib
      pandas
    ])
  ];
}
