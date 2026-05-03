# Flake inputs

/**
  Declares configuration’s dependencies. Inputs
  are sorted by their purpose and functionality.
  See sub chapters to learn which inputs are intended for.

  > [!WARNING]
  > Because nix doesn’t support splitting flake inputs into several files,
  > `flake.nix` is generated via [flake-file](https://github.com/vic/flake-file). Then adding new input,
  > remember running `nix run .#write-flake` to apply changes!
  >
  > In next chapters, you'll see attributes of type `flake.inputs.{class}.{input}`.
  > Then accessing inputs in repl, remove {class}, so instead of calling e.g. `flake.inputs.core.nixpkgs`,
  > you call `flake.inputs.nixpkgs`.
*/
(import ./core.nix) // (import ./home.nix)
