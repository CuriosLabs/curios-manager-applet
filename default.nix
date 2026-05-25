# CuriOS manager COSMIC applet

{ lib, stdenv, fetchFromGitHub, fetchurl, pkg-config, rustPlatform, just, libcosmicAppHook
, nix-update-script }:
rustPlatform.buildRustPackage rec {
  pname = "curios-manager-applet";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "CuriosLabs";
    repo = "curios-manager-applet";
    tag = "${version}";
    hash = "sha256-BIeSZuMbYL3mFNK39JRDV4q0p+14ZTGCKN4K3fJCdyQ=";
  };

  cargoLock = {
    lockFile = fetchurl {
      url = "https://raw.githubusercontent.com/CuriosLabs/curios-manager-applet/${version}/Cargo.lock";
      hash = "sha256-UMjQkogAnhiB3W6gOerqUUW4f/4nBsuEiYXCkrmEdCk=";
    };
    allowBuiltinFetchGit = true;
  };

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
