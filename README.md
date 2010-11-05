# Dotfiles

Install with `rake install`.

Files which can include private data, like `gitconfig` (GitHub credentials) and `gemrc` (Gemcutter credentials) are split into a public and a private file.  The rake task stitches them back together.

## Assumptions

* The repo is at `~/dotfiles`.
* You have MacVim installed at `/Applications/MacVim.app`.
* Probably a few other things too ;)

## Vim

My Vim configuration is in its own repository: [dotvim](https://github.com/airblade/dotvim)
