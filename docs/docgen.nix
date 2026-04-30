{
  stdenvNoCC,
  mdbook,
  nixdoc,
  lib,
}:
stdenvNoCC.mkDerivation {
  name = "SkyOS-book";
  src = ./.;
  buildInputs = [
    mdbook
    nixdoc
  ];
  patchPhase =
    let
      excluded = [
        ".*flake\\.nix$"

        "docs/docgen.nix"
        "docs/server.nix"
      ];

      shouldExclude = relPath: lib.any (pattern: builtins.match pattern relPath != null) excluded;

      nixFiles =
        with lib.fileset;
        let
          allFiles = toList (fileFilter (f: f.hasExt "nix") ../.);
        in
        lib.filter (
          file:
          let
            relPath = lib.removePrefix (toString ../. + "/") (toString file);
          in
          !shouldExclude relPath
        ) allFiles;

      chapters = lib.sort (a: b: a.sortKey < b.sortKey) (
        map (
          file:
          let

            relPath = lib.removePrefix (toString ../. + "/") (toString file);
            mdPath =
              (
                if baseNameOf file == "default.nix" then
                  lib.removeSuffix "/" (dirOf relPath)
                else
                  lib.removeSuffix ".nix" relPath
              )
              + ".md";

            orderMap = {
              docs = 0;
              flake = 1;
              devShells = 2;
              hosts = 3;
            };
            order = orderMap.${lib.head (lib.splitString "/" relPath)};

            category = lib.removeSuffix ".md" (lib.replaceStrings [ "/" ] [ "." ] mdPath);
            title =
              let
                head = builtins.head (lib.splitString "\n" (builtins.readFile file));
              in
              if builtins.match "^# (.*)" head != null then
                lib.trim (lib.removePrefix "#" head)
              else
                lib.removeSuffix ".nix" (baseNameOf file);

            depth =
              let
                dirPart = dirOf mdPath;
              in
              if dirPart == "." then 0 else lib.length (lib.splitString "/" dirPart);
            indent = lib.concatStringsSep "" (lib.genList (x: "    ") depth);
          in
          {
            script = ''
              mkdir -p "src/${dirOf mdPath}"
              nixdoc \
                --prefix "" \
                --category "${category}" \
                --description "${title}" \
                --anchor-prefix "" \
                --file "${file}" > "src/${mdPath}"
            '';
            summaryLine = "${indent}- [${title}](${mdPath})";
            sortKey = builtins.toString order + mdPath;
          }
        ) nixFiles
      );

      summaryContent =
        "# Summary\n\n"
        + "[Introduction](README.md)\n"
        + builtins.concatStringsSep "\n" (map (c: c.summaryLine) chapters)
        + "\n";

      nixdocScripts = builtins.concatStringsSep "\n" (map (c: c.script) chapters);
    in
    ''
      cp ${../README.md} src/README.md
      cp -r ${../assets} src/assets
      cp src/assets/logo.png theme/favicon.png

      ${nixdocScripts}

      cat > src/SUMMARY.md <<EOF
      ${summaryContent} 
      EOF
    '';

  buildPhase = ''
    runHook preBuild
    mdbook build
    runHook postBuild
  '';

  postBuild = ''
    mkdir -p $out $out/theme
    cp -r book/* $out
    cp theme/catppuccin.css $out/theme
  '';
}
