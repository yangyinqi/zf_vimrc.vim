#!bash

# ============================================================
# global check
_git_exist=0
git --version >/dev/null && _git_exist=1 || _git_exist=0
if test "x$_git_exist" = "x0"; then
    echo "error: git not installed"
    exit
fi

_vim_exist=0
vim --version >/dev/null && _vim_exist=1 || _vim_exist=0
if test "x$_vim_exist" = "x0"; then
    echo "error: vim not installed"
    exit
fi

_old_dir=$(pwd)
cd ~

# ============================================================
# clean
if test "x$ZF_force" = "x1" ; then
    rm "~/.vimrc"
    rm "~/_vimrc"
    rm "~/.vim"
fi

# ============================================================
# vimrc
_vimrc=
if test -e ".vimrc"; then
    _vimrc=".vimrc"
elif test -e "_vimrc"; then
    _vimrc="_vimrc"
else
    _vimrc=".vimrc"
fi

_exist=0
grep -wq "zf_vimrc.vim" "$_vimrc" && _exist=1 || _exist=0

if test "x$_exist" = "x0"; then
    echo "" >> "$_vimrc"

    echo "\" * if any weird problem occurred, uncomment one of these:" >> "$_vimrc"
    echo "\"" >> "$_vimrc"
    echo "\"     set shell=cmd.exe" >> "$_vimrc"
    echo "\"     set shellcmdflag=/c" >> "$_vimrc"
    echo "\"" >> $_vimrc
    echo "\"     set shell=bash" >> "$_vimrc"
    echo "\"     set shellcmdflag=-c" >> "$_vimrc"
    _isCygwin=0
    uname | grep -iq "cygwin" && _isCygwin=1 || _isCygwin=0
    if test "x$_isCygwin" = "x1"; then
        echo "set shell=bash" >> "$_vimrc"
        echo "set shellcmdflag=-c" >> "$_vimrc"
    fi
    echo "" >> "$_vimrc"

    echo "\" * if your terminal support 256 color, uncomment this for better color" >> "$_vimrc"
    echo "\"     let g:zf_colorscheme_256=1" >> "$_vimrc"
    if test `tput colors` -ge 256 || test "x$ZF_256" = "x1" ; then
        echo "let g:zf_colorscheme_256=1" >> "$_vimrc"
    fi
    echo "" >> "$_vimrc"

    echo "\" * if you want the powerful YouCompleteMe, uncomment this and :PlugUpdate" >> "$_vimrc"
    echo "\"     let g:ZF_Plugin_YouCompleteMe=1" >> "$_vimrc"
    if test "x$ZF_YCM" = "x1" ; then
        echo "let g:ZF_Plugin_YouCompleteMe=1" >> "$_vimrc"
    fi
    echo "" >> "$_vimrc"

    echo "source \~/zf_vimrc.vim" >> "$_vimrc"
fi

# ============================================================
# git update
git config --global core.autocrlf false

echo "updating zf_vimrc..."
_tmpdir="_zf_vimrc_tmp_"
git clone --depth=1 https://github.com/ZSaberLv0/zf_vimrc.vim.git "$_tmpdir"
cp "$_tmpdir/zf_vimrc.vim" "zf_vimrc.vim"
rm -rf "$_tmpdir" >/dev/null 2>&1

echo "updating vim-plug..."
rm -rf ~/.vim/bundle/vim-plug >/dev/null 2>&1
# git clone --depth=1 --single-branch https://github.com/junegunn/vim-plug ~/.vim/bundle/vim-plug
git clone --depth=1 --single-branch https://github.com/ZSaberLv0/vim-plug ~/.vim/bundle/vim-plug

vim +PlugUpdate +qall

cd "$_old_dir"
