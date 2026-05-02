# Documentation
Docs are generated from comments in `.nix` files.
This results in kind of weird config format, but
makes it easier to track configuration changes
and add/remove docs as required.

## How docs are generated

`nixdoc` utility enables us to generate documentation
from comments in `.nix` file, like `doxygen` and `rustdoc` do.

`nixdoc` requires this flags:
- category (derived from file's path)
- description (derived from file's first line if it's commented)

most hard part is to generate SUMMARY.md.
generator uses orderKey of type `{num}|{mdPath}` and derives indentation from path's depth,
so chapters have proper order.

run `nix build .#docBuild` to build documentation.
run `nix run .#docServe` to serve documentation site
