# dotfiles

My magic configuration for dots and configs.

Currently I manage my dotfiles with [gnu stow](http://www.gnu.org/software/stow/).
The *stow* -command is used to create symlinks for files in the parent directory.

## How-To

The setup assumes this repo is located in the root of your home directory `~/dotfiles`.
Stow defaults to creating symlinks to the parent directory, thus user configuration works without specifying the repo.

If your repo is in another location (e.g. `~/scm/dotfiles`) you'll need to use the `-d` flag with the repo directory location (`stow -d ~/scm/dotfiles`).

To setup configs to user `$HOME` see [Install Config](#install-config) (default).
For config in other locations (such as T440s clickpad configuration -> `/etc/X11`), see [root config](#custom-location--root-config).
To backup new config, see [here](#backup-new-config).

### Install Config

1. Navigate to home directory and copy the repo

    ```bash
    cd ~ && git clone git@github.com:MiriPii/dotfiles.git && cd dotfiles
    ```
2. Choose the config to install and simulate changes
 
   ```bash
   # (default) create link to parent directory
   stow -n zsh # For zsh config
   ```
   This will symlink all files inside `zsh` (currently `~/.zshrc`) into the parent directory.
   If the file already exist, *stow* will give a warning. 

3. Rename the old existing configurations if you received warnings
   
   Example given for `.zshrc`

    ```bash
    # append with '.old'
    mv ~/.zshrc ~/.zshrc.old
    ```

4. Make the changes and create symlinks

    After conflicts have been resolved and dry run gives no warnings run the command without `-n`-flag.

    ```bash
    cd ~/dotfiles
    stow zsh
    ```


### Custom Location / root config

1. Simulate a dry run to see conflicts
    ```bash
    # stow to custom target directory
    sudo stow -n -t / T440s-clickpad

    # custom repo location and custom target
    sudo stow -n -d /home/<user>/scm/dotfiles -t / T440s-clickpad
    ```

2. Fix conflicts and run without the `-n` flag

### Backup new config

To add new configurations to the backup create a new directory and copy the files (including the tree-path).
