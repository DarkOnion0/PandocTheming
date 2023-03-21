# PandocTheming

> *An over-engenired way to convert my Markdown documents to PDF in a reproductible way*

[![Latest release](https://shields.io/github/v/release/DarkOnion0/PandocTheming?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)](https://shields.io/github/v/release/DarkOnion0/PandocTheming?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)

# 🖥️ Usage

This app is heavily based on nix and can't be used without it

1. Install [Nix](https://nixos.org/download.html)
2. Enable [flake](https://nixos.wiki/wiki/Flakes#Enable_flakes) experimental feature
3. Run the flake
  ```sh
  nix run github:DarkOnion0/pandocTheming
  ```

# 📚 Doc

```text
-h/--help                       Prints help and exits
-f/--file                       Get a markdown file to convert to PDF
-s/--style                      Set some style overrides, /!\ Be aware that this will make the style less reproductible /!\
-o/--orientatation-portrait     Set the output pdf orientation, (portrait)/landscape
```

# ©️ Credits

|                  |                                                                                |
| ---------------- | ------------------------------------------------------------------------------ |
| Theme            | [Nord Theme](https://www.nordtheme.com)                                        |
| Conversion tool  | [Pandoc](https://pandoc.org/index.html) & [Weasyprint](https://weasyprint.org) |
| Styling          | [SASS](https://sass-lang.com)                                                  |
| Main Inspiration | [Craigbass76](https://github.com/craigbass76/pandoc-css-weasyprint-template)   |
