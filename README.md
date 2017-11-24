<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Quick Install](#quick-install)
* [Manual Install](#manual-install)
* [Uninstall](#uninstall)
* [Additional Requirement](#additional-requirement)
* [Platform Spec](#platform-spec)
    * [Cygwin](#cygwin)
    * [YouCompleteMe vs clang_complete](#youcompleteme-vs-clang_complete)
        * [minimal config](#minimal-config)
        * [YouCompleteMe](#youcompleteme)
        * [clang_complete](#clang_complete)
    * [neovim](#neovim)
    * [Android's VimTouch](#androids-vimtouch)
    * [For simulation plugins of IDE](#for-simulation-plugins-of-ide)

<!-- vim-markdown-toc -->

# Introduction

my personal vimrc config for vim

aiming to be used under multi platforms, low dependency, yet powerful for general usage

tested:

* vim version 7.3 or above
* Windows's gVim
* cygwin's vim
* Mac OS's vim and macvim (console or GUI)
* Ubuntu's vim
* Android's VimTouch (with full runtime)

may work: (search and see `g:zf_fakevim`)

* neovim (not fully tested, but should work for most case)
* Qt Creator's FakeVim (able to use, no plugin support, some keymap doesn't work)
* IntelliJ IDEA's IdeaVim (able to use, no plugin support, some keymap doesn't work)
* XCode's XVim (not recommended, some action have unexpected behavior)


for me, I use this config mainly for `C/C++` `markdown` `PHP` development,
as well as for default text editor and log viewer


# Quick Install

if you have `curl`, `git`, `vim` installed, here's a very simple command to install everything:

```
curl zsaber.com/vim | sh

# or, run the install script directly
sh zf_vim_install.sh

# optionally, change settings before running the shell script
export ZF_xxx=1
curl zsaber.com/vim | sh
```

settings:

* `ZF_256` : use 256 color colorscheme

    may looks incorrect if used in non-256 color terminal

* `ZF_YCM` : use `YouCompleteMe` instead of `clang_complete`

    see `YouCompleteMe vs clang_complete` below for detailed info

* `ZF_force` : remove all contents and perform clean install

    items to remove before install

    ```
    ~/.vimrc
    ~/_vimrc
    ~/.vim
    ```

once installed, you may press `z?` to view a quick tutorial for this config


# Manual Install

1. download or clone the `zf_vimrc.vim` file to anywhere
1. have these in your `.vimrc` (under linux) or `_vimrc` (under Windows):

    ```
    source path/zf_vimrc.vim
    ```

1. use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins

    install vim-plug:

    ```
    git clone https://github.com/junegunn/vim-plug $HOME/.vim/bundle/vim-plug
    ```

    after installed, update plugin manually:

    ```
    :PlugUpdate
    ```

1. it's recommended to modify platform-dependent settings in `.vimrc`, such as:

    ```
    au GUIEnter * simalt ~x
    set guifont=Consolas:h12
    set termencoding=cp936
    let g:zf_colorscheme_256=1
    source path/zf_vimrc.vim
    ```

for a list of plugins and configs, please refer to the
[zf_vimrc.vim](https://github.com/ZSaberLv0/zf_vimrc.vim/blob/master/zf_vimrc.vim) itself,
which is self described


# Uninstall

to uninstall, remove these lines in your `.vimrc`

```
source path/zf_vimrc.vim
```

and remove these dirs/files

```
$HOME/.vim
$HOME/.vim_cache
$HOME/zf_vimrc.vim
```


# Additional Requirement

* [cygwin](https://www.cygwin.com)

    not necessary, but strongly recommended for Windows users

* GNU grep (greater than 2.5.3)

    for [vim-easygrep](https://github.com/dkprice/vim-easygrep) if you want to use Perl style regexp

    note the FreeBSD version won't work due to the lack of `-P` option of `grep`

* [Pandoc](http://pandoc.org/)

    for Markdown preview and conversion

* [LLVM](http://llvm.org/)

    for [clang_complete](https://github.com/Rip-Rip/clang_complete), you should:

    * have python support
    * have `g:clang_library_path` been set properly

        the default config may suit most case, modify it if necessary

        recommended to install LLVM at default location,
        if so, this config would be able to config it automatically


# Platform Spec

## Cygwin

when used under different version of cygwin, you should concern these settings if weird problem occurred:

```
set shell=cmd.exe
set shellcmdflag=/c
```

or

```
set shell=bash
set shellcmdflag=-c
```

set it directly to `.vimrc`, choose the right one for you


## YouCompleteMe vs clang_complete

by default, we use [clang_complete](https://github.com/Rip-Rip/clang_complete) for C-family semantic completion,
because it has less dependency and easier to install (the default config should work for most case)

if you want the more powerful [YouCompleteMe](https://github.com/Valloric/YouCompleteMe):

* go [YouCompleteMe Installation](https://github.com/Valloric/YouCompleteMe#installation)
    to check whether your system matches the requirement (Windows not supported for this config)
* add `let g:plugin_YouCompleteMe=1` to your `.vimrc` before `source zf_vimrc.vim`
* manually update plugin by `:PlugUpdate`

### minimal config

supply `.clang_complete` to your project's root, and specify header search path, example:

```
-I/usr/lib/include
-I./my_src1/include
-I./my_src2/include
```

after this, the completion should work, for both plugin


### YouCompleteMe

* require much time to install the plugin for first time
* doesn't work under Windows, it's too hard to config it, and it would fallback to clang_complete in this config
* semantic complete keymap should be `<tab>`, and should trigger automatically when you start typing
* macro function's param doesn't support semantic complete
* use `<alt> + h` and `<alt> + l` to move between params after function completion

### clang_complete

* lightweight, easy and quick to install
* support most platform (including Windows)
* semantic complete should be triggered manually by pressing `<tab>`
* use `<tab>` to move between params after function completion


## neovim

* this config should work on neovim without any modification,
    to use, simply add this line to your `.config/nvim/init.vim`

    ```
    source ~/zf_vimrc.vim
    ```

## Android's VimTouch

* `VimTouch Full Runtime` is also required
* the vim config is placed under `/data/data/net.momodalo.app.vimtouch/files/.vimrc`
* you should manually copy all settings from other platform to VimTouch's folder,
    the result folder tree should looks like:

    ```
    /data/data/net.momodalo.app.vimtouch/files/
        .vim/
            bundle/
                ...
        .vimrc
        zf_vimrc.vim
    ```

**Note: vimrc may or may not work under Android 5 or above, reason unknown,
    this is VimTouch's problem, not this repo's problem**

## For simulation plugins of IDE

```
let g:zf_fakevim=1
```

* not fully tested
* some vim simulation plugins doesn't support `source` command,
  so you may need to paste directly to proper vimrc files (e.g. `.ideavim`, `.xvimrc`)
* some vim simulation plugins doesn't support `if-statement` and plugins,
  so you may need to manually delete all lines under the `if g:zf_no_plugin!=1` section

