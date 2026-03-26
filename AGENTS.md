# CuriOS Manager Applet Development Guide

This guide provides instructions and best practices for developers contributing
to the curios-manager-applet project. It is a NixOS package providing an applet
for the COSMIC Desktop Environment written in Rust using `libcosmic`.

## Context

You are an expert software architect and project analysis assistant. Analyze
the current project directory and help developers that interacts with this
project. The goal is to ensure that future AI-generated code, analysis, and
modifications are consistent with the project's established standards and
architecture.

## Applet Directory Structure

- `src/`: Rust source code.
- `i18n/`: Fluent translation files.
- `resources/`: Desktop entry, icons, and metainfo.

## Key Applet Files

- `Cargo.toml`: Rust package manifest.
- `justfile`: Command runner configuration (build, run, install).
- `src/app.rs`: Main application logic (Model-View-Update pattern).
- `src/config.rs`: Configuration struct and loading.
- `shell.nix`: A Nix configuration file for the `nix-shell` command. It will setup
a temporary environment with the specified dependencies, tools and configurations
for the `just` command.

## Applet Development Environment

**Important**: Development requires a Nix shell with specific library paths for
Wayland and OpenGL and to configure `LD_LIBRARY_PATH`.

**Enter the Shell**:

   ```bash
   nix-shell shell.nix
   ```

### Applet Build and Run Commands

- **Run locally**:

  ```bash
  nix-shell shell.nix --run "just run"
  ```

  *Note: This builds and runs the applet. Ensure you are in the `nix-shell`.*

- **Build Release**:

  ```bash
  nix-shell shell.nix --run "just build-release"
  ```

- **Lint/Check**:

  ```bash
  nix-shell shell.nix --run "just check"
  ```

## Applet Architecture

- **Framework**: `libcosmic` (based on `iced`).
- **Pattern**: The Elm Architecture (Model, Message, Update, View).
- **Interactions**:
  - The applet displays an icon in the COSMIC panel.
  - Clicking the icon triggers `Message::LaunchManagerApp`, which spawns
  `alacritty -e curios-manager`.

## COSMIC Source References

- [libcosmic](https://github.com/pop-os/libcosmic).
- [libcosmic book](https://pop-os.github.io/libcosmic-book/introduction.html).
- [cosmic-applet-template](https://github.com/pop-os/cosmic-applet-template).
- [cosmic-applets](https://github.com/pop-os/cosmic-applets).
- [COSMIC Widget module](https://pop-os.github.io/libcosmic/cosmic/widget/index.html).
- [cosmic-icons](https://github.com/pop-os/cosmic-icons).
- [COSMIC forecast app](https://github.com/cosmic-utils/forecast).

## Contributing

- **Project Source**: [curios-manager-applet GitHub](https://github.com/CuriosLabs/curios-manager-applet)
- **Contributing Policy**: See @CONTRIBUTING.md file.
- **Branching Strategy**: For new features, create a branch named
  `feature/<YourFeatureName>` (e.g., `git checkout -b feature/AmazingFeature`).
