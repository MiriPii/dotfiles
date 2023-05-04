# How To

## Backup

Create a new backup from all installed extension and save it to a file.

```sh
code --list-extensions >> vs_code_extensions_list.txt
```

## Reinstall

To enable the listed extenesions in a file named `vs_code_extensions_list.txt` execute the following command.

```sh
cat vs_code_extensions_list.txt | xargs -n 1 code --install-extension
```

