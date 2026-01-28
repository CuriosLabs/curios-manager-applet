# CuriOS manager COSMIC applet

{ lib, stdenv, fetchFromGitHub, rustPlatform, just, libcosmicAppHook }:
rustPlatform.buildRustPackage rec {
  pname = "curios-manager-applet";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "CuriosLabs";
    repo = "curios-manager-applet";
    tag = "${version}";
    hash = "";
  };

  cargoHash = "";

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
