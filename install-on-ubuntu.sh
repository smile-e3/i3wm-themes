#!/bin/bash
###
 # @Author: smile alchemist_clb@163.com
 # @Date: 2023-06-30 14:46:57
 # @LastEditors: smile-e3 2278215957@qq.com
 # @LastEditTime: 2023-07-04 14:30:57
 # @FilePath: \i3wm-themes\install-on-ubuntu.sh
 # @Description: auto i3wm
###
config_directory="$HOME/.config"
fonts_directory="$HOME/.fonts"
scripts_directory="/usr/local/bin"
gtk_theme_directory="/usr/share/themes"

green='\033[0;32m'
no_color='\033[0m'
date=$(date +%s)

sudo apt install dialog -y

system_update(){
    echo -e "${green}[*] Doing a system update, cause stuff may break if it's not the latest version...${no_color}"
    sudo apt update -y
}

# 安装相关程序
install_pkgs(){
    echo -e "${green}[*] Installing packages with apt.${no_color}"
    # 安装Terminal终端
    sudo apt install kitty -y
    # 安装polybar
    sudo apt install polybar -y
    # 安装feh
    sudo apt install feh -y
    # 安装net网络工具
    sudo apt install net-tools -y
    # 安装neovim编辑工具
    # sudo apt install neovim -y
    # 安装相关依赖
    sudo apt install meson ninja-build cmake cmake-data pkg-config git make\
     autoconf automake flex bison check rofi-dev libpango1.0-dev libxkbcommon-dev \
     libgdk-pixbuf-2.0-dev libxcb-util-dev libxkbcommon-x11-dev libxcb-icccm4-dev libxcb-cursor-dev \
     libstartup-notification0-dev -y
}

# 创建相关默认目录
create_default_directories(){
    echo -e "${green}[*] Copying configs to $config_directory.${no_color}"
    mkdir -p "$HOME"/.config
    sudo mkdir -p  /usr/local/bin
    sudo mkdir -p  /usr/share/themes
    mkdir -p "$HOME"/Pictures/wallpapers
}

# 安装rofi程序
install_rofi(){
    echo -e "${green}[*] Installing rofi package.${no_color}"
    cd ~
    sudo apt install libxcb-ewmh-dev libxcb-randr0-dev libxcb-xinerama0-dev-y
    echo -e "${green}[*] Installing rofi package.${no_color}"
    git clone https://github.com/davatorium/rofi/
    cd rofi && meson setup build && ninja -C build && sudo ninja -C build install
}

# 安装picom程序
install_picom(){
    sudo apt install libx11-xcb-dev libdbus-1-dev -y
    cd ~
    echo -e "${green}[*] Installing picom package.${no_color}"
    git clone https://github.com/jonaburg/picom
    cd picom && meson --buildtype=release . build && sudo ninja -C build && sudo ninja -C build install
}

# 安装VSCODE
install_packages_from_file(){
    cd ~/i3wm-themes
    sudo dpkg -i packages/code_1.79.2-1686734195_amd64.deb
}

# 配置字体文件
copy_fonts(){
    cd ~/i3wm-themes
    echo -e "${green}[*] Copying fonts to $fonts_directory.${no_color}"
    sudo cp -r ./fonts/* "$fonts_directory"
    fc-cache -fv
}

# 配置其他配置文件
copy_other_configs(){
    cd ~/i3wm-themes
    echo -e "${green}[*] Copying wallpapers to "$HOME"/Pictures/wallpapers.${no_color}"
    cp -rf ./wallpapers/* "$HOME"/Pictures/wallpapers/
}

copy_scripts(){
    cd ~/i3wm-themes
    echo -e "${green}[*] Copying scripts to $scripts_directory.${no_color}"
    sudo cp -r ./scripts/* "$scripts_directory"
}

copy_configs(){
    cd ~/i3wm-themes
    echo -e "${green}[*] Copying configs to $config_directory.${no_color}"
    cp -r ./config/* "$config_directory"
}

# 安装i3-gaps
install_i3_gaps(){
    echo -e "${green}[*] Install i3-gaps tool.${no_color}"
    cd ~
    sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
    libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
    libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
    libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake \
    libxcb-shape0-dev libxcb-xrm-dev
    git clone https://github.com/Airblader/i3 i3-gaps
    cd i3-gaps && mkdir -p build && cd build
    meson --prefix /usr/local && ninja
    sudo ninja install
}

# 安装相关开发相关编辑器
install_code_tools(){
    echo -e "${green}[*] Install neovim.${no_color}"
    sudo apt install libfuse2
    wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && sudo mv nvim.appimage /usr/bin/nvim
    sudo chmod 777 /usr/bin/nvim
    nvim +PackerSync
}

cmd=(dialog --clear --separate-output --checklist "Select (with space) what script should do.\\nChecked options are required for proper installation, do not uncheck them if you do not know what you are doing." 26 86 16)
options=(1 "System update" on
         2 "Install basic packages" on
         3 "Create default directories" on
         4 "Install Rofi" on
         5 "Install picom" on
         6 "Copy configs" on
         7 "Copy scripts" on
         8 "Copy fonts" on
         9 "Copy other configs (gtk theme, wallpaper, vsc configs, zsh configs)" on
         10 "Install package from file" on
         11 "Install i3-gaps" on
         12 "Install code tools" on
        )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear

for choice in $choices
do
    case $choice in
        1) system_update;;
        2) install_pkgs;;
        3) create_default_directories;;
        4) install_rofi;;
        5) install_picom;;
        6) copy_configs;;
        7) copy_scripts;;
        8) copy_fonts;;
        9) copy_other_configs;;
        10) install_packages_from_file;;
        11) install_i3_gaps;;
        12) install_code_tools;;
    esac
done