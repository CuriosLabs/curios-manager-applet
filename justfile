name := 'curios-manager-applet'
appid := 'dev.curioslabs.CuriosManagerApplet'
owner := 'CuriosLabs'

rootdir := ''
prefix := '/usr'

# Installation paths
base-dir := absolute_path(clean(rootdir / prefix))
cargo-target-dir := env('CARGO_TARGET_DIR', 'target')
appdata-dst := base-dir / 'share' / 'appdata' / appid + '.metainfo.xml'
bin-dst := base-dir / 'bin' / name
bin-src := 'target' / 'release' / name
desktop-dst := base-dir / 'share' / 'applications' / appid + '.desktop'
icon-dst := base-dir / 'share' / 'icons' / 'hicolor' / 'scalable' / 'apps' / appid + '.svg'

# Default option list available recipes.
default:
  @just --list

# Runs `cargo clean`
clean:
  cargo clean

# Removes vendored dependencies
clean-vendor:
  rm -rf .cargo vendor vendor.tar

# `cargo clean` and removes vendored dependencies
clean-dist: clean clean-vendor

# Compiles with debug profile
build-debug *args:
  cargo build {{args}}

# Compiles with release profile
build-release *args: (build-debug '--release' args)

# Compiles release profile with vendored dependencies
build-vendored *args: vendor-extract (build-release '--frozen --offline' args)

# Runs a clippy check
check *args:
  cargo clippy --all-features {{args}} -- -W clippy::pedantic

# Runs a clippy check with JSON message format
check-json: (check '--message-format=json')

# Init rust on a NixOS machine for the first launch
init:
  rustup default stable
  rustup update

# Run the application for testing purposes
run *args:
  env RUST_BACKTRACE=full cargo run --release {{args}}

# Installs files
install:
  install -Dm0755 {{ bin-src }} {{bin-dst}}
  install -Dm0644 resources/app.desktop {{desktop-dst}}
  install -Dm0644 resources/app.metainfo.xml {{appdata-dst}}
  install -Dm0644 resources/icon.svg {{icon-dst}}

# Uninstalls installed files
uninstall:
  rm {{bin-dst}} {{desktop-dst}} {{icon-dst}}

# Vendor dependencies locally
vendor:
  mkdir -p .cargo
  cargo vendor --sync Cargo.toml | head -n -1 > .cargo/config.toml
  echo 'directory = "vendor"' >> .cargo/config.toml
  echo >> .cargo/config.toml
  #rm -rf .cargo vendor

# Extracts vendored dependencies
vendor-extract:
  #rm -rf vendor
  tar pxf vendor.tar

# Complete publish process: lint, tag then build and update hash signature, finally push on github.
publish VERSION:
  @if git rev-parse "{{VERSION}}" >/dev/null 2>&1; then echo "Warning: Tag {{VERSION}} already exists."; exit 1; fi
  git checkout testing
  sed '0,/^version/s/^version.*/version = "{{VERSION}}"/' -i ./Cargo.toml
  sed "s/version = \".*/version = \"{{VERSION}}\";/g" -i ./default.nix
  sed "s#hash = \".*#hash = \"\";#g" -i ./default.nix
  cargo check
  @just build-release
  @just tag {{VERSION}}
  sleep 5
  @just hash-update {{VERSION}}

# Bump cargo version, create git commit, and create tag
tag VERSION:
  cargo clean
  git add Cargo.lock
  git commit -a -m 'Release {{VERSION}}'
  git pull
  git tag -a {{VERSION}} -m 'Release {{VERSION}}'
  git push origin {{VERSION}}

# Update the Nix package hash signature, commit and push to git.
hash-update VERSION:
  #!/usr/bin/env bash
  set -euxo pipefail
  HASH=`nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(nix-prefetch-url --unpack https://github.com/{{owner}}/{{name}}/archive/{{VERSION}}.tar.gz)"`
  sed "s#hash = \".*#hash = \"${HASH}\";#g" -i ./default.nix
  git commit -a -m "Updated hash signature"
  git push

