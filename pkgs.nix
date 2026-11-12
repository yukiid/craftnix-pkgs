{ pkgs }:
let
  inherit (pkgs) lib stdenv stdenvNoCC;

  runtimeLibs = with pkgs; [
    alsa-lib
    dbus
    libGL
    libxcb
    libx11
    libxkbcommon
    libxcursor
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
  ];

  mkCraftApp =
    {
      pname,
      version,
      hash,
      description,
      bins ? [ pname "${pname}-cli" ],
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = pkgs.fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.tar.gz";
        inherit hash;
      };

      sourceRoot = "${pname}-${version}-linux-x86_64";
      nativeBuildInputs = with pkgs; [ autoPatchelfHook makeWrapper ];
      buildInputs = runtimeLibs;
      runtimeDependencies = runtimeLibs;

      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -a bin share $out/
        for b in ${lib.escapeShellArgs bins}; do
          wrapProgram "$out/bin/$b" \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
        done
        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://github.com/storytold/${pname}";
        license = with lib.licenses; [ mit asl20 ];
        mainProgram = pname;
        platforms = [ "x86_64-linux" ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
    };

  apps = {
    photocraft = {
      version = "0.23.1";
      hash = "sha256-Q4Ou9noHzDcK0lCm7WABUgXT5sRj+vP/Sw9nuBeMz8g=";
      description = "Image editing: layers, masks, type and real PSD files";
    };

    effectcraft = {
      version = "0.24.1";
      hash = "sha256-XOA5NpAUQif6kYboIwitY4pu9tn5dsmW5tA7W1G2Wns=";
      description = "Motion graphics and visual effects";
    };
  };
in
lib.mapAttrs (pname: args: mkCraftApp ({ inherit pname; } // args)) apps
