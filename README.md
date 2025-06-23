# My dotfiles

This directory contains the dotfiles for my system

## Requirements

 * git: [Download Git Here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
 * GNU Snow: [GNU Stow docs](https://www.gnu.org/software/stow/manual/) 
    
## Installing dotfiles

First, check ou the dotfiles repo in your $HOME directory using git

```
git clone git@github.com/jmsMaupin1/dotfiles
cd dotfiles
```

Then use GNU stow to create symlinks

```
stow .
```
