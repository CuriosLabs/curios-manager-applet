# CuriOS manager COSMIC applet

{ lib, stdenv, fetchFromGitHub, pkg-config, rustPlatform, just, libcosmicAppHook
, nix-update-script }:
rustPlatform.buildRustPackage rec {
  pname = "curios-manager-applet";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "CuriosLabs";
    repo = "curios-manager-applet";
    tag = "${version}";
    hash = "sha256-EeiEa/RZWtKv8DhVtusvU+KW9cwJtq28ZGUvtgIdU9Q=";
  };

  cargoHash = "sha256-25NW4zv29aSOebUZTr1E+E/uukCxJs+iYU5Fv6izbc0=";

  nativeBuildInputs = [ pkg-config just libcosmicAppHook ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/${pname}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CuriOS manager COSMIC applet";
    homepage = "https://github.com/CuriosLabs/curios-manager-applet";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "curios-manager-applet";
  };
}
