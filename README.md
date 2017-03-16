@ikalnytskyi's dotfiles
=======================

Despite dotfiles can be installed independently by copying individual
files manually, it's a recommended way to install them by means of
GNU [stow] since it makes symlinks and allows to update them at once
by running `git pull`.


Installation
------------

* Clone the repo and switch to its root:

  ```bash
  $ git clone https://github.com/ikalnytskyi/dotfiles && cd dotfiles
  ```

* Run `stow` with dotfiles bundle you want to use:

  ```bash
  $ stow -t ~ {bundle}
  ```

where

  * `{bundle}` - a bundle to install (e.g. `bash` or `vim`)


Dependencies
------------

* **bash**

  Depends on [vcstatus] project in order to show VCS hints in your prompt.


[stow]: https://www.gnu.org/software/stow/
[vcstatus]: https://github.com/ikalnytskyi/vcstatus
