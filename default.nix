# CuriOS manager COSMIC applet

{ lib, stdenv, fetchFromGitHub, rustPlatform, just, libcosmicAppHook }:
rustPlatform.buildRustPackage rec {
  pname = "curios-manager-applet";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "CuriosLabs";
    repo = "curios-manager-applet";
    tag = "${version}";
    hash = "sha256-XfQROcsbuSjS0HTA9N9SHWSO1Xio5xaV0/nVms6WbMY=";
  };

  cargoHash = "sha256-u1So+XOx/Urm08v7mBlaC4LQk1ckAzN8uXI2f4g6sQo=";

  nativeBuildInputs = [ just libcosmicAppHook ];

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

  meta = {
    description = "CuriOS manager COSMIC applet";
    homepage = "https://github.com/CuriosLabs/curios-manager-applet";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "curios-manager-applet";
  };
}
