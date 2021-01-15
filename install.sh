#!/usr/bin/env bash

########################################################################
# Bash script to install wget, curl and Node js on different OS
# Written by Labake as a SCA CLOUD COMPUTUNG assessment

# DATE			    DETAILS
# --------------- --------------------------------
# 2021-01-15	    Initial version

########################################################################


set -x

OS="$(uname)"

checkOS() {
    echo "========================= Checking OS ============================="

    if [[ "$OS" == "Darwin" ]]; then
        echo "========================= MAC OS ============================="
        elif [[ "$OS" == "Linux" ]]; then
        echo "========================= LINUX ============================="
        elif [[ "$OS" == "msys" ]]; then
        echo "========================= WINDOWS ============================="
    else
        echo "There is no support for your OS at the moment, kindly check back soon!"
        exit 1
    fi

}

installBrew() {
    if [[ $(command -v brew) == "" ]]; then
        # Install Homebrew
        echo "========================= Installing Homebrew ========================="
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Updating Homebrew"
        brew update
    fi
}

installChocolatey() {
    if Test-Path -Path "$env:ProgramData\Chocolatey"
    then
        echo "========================= Chocolatey is already installed ========================="
        echo "========================= Updating Chocolatey ========================="
        choco upgrade chocolatey
    else
        echo "========================= Installing Chocolatey ========================="
        #  $(which powershell) Set-ExecutionPolicy Bypass -Scope Process -Force; [ System.Net.ServicePointManager ]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    fi
}

mac() {
    for pkg in curl wget node; do
        echo "====================== Install $pkg ======================="

        if ! which $pkg >/dev/null; then
            brew install $pkg

            $pkg -v

            echo "======================     $pkg has been installed.  ======================="
        else
            echo "======================  $pkg is already installed ====================== "
        fi
    done
}

linuxOS() {
    for pkg in curl wget nodejs; do

        echo "====================== Install $pkg ======================="

        if ! which $pkg >/dev/null; then

            sudo apt install $pkg
            $pkg -v

        else
            echo "======================  $pkg is already installed ====================== "
        fi

    done
}

windows() {
    for pkg in curl wget node; do
        echo "====================== Install $pkg ======================="

        if ! which $pkg >/dev/null; then
            choco install "pkg" -y

            $pkg -v

            echo "======================     $pkg has been installed.  ======================="
        else
            echo "======================  $pkg is already installed ====================== "
        fi
    done
}

installPackageManager() {
    OS=$1
    case ${OS} in
        Darwin)
            installBrew
            mac
        ;;
        Linux)
            linuxOS
        ;;
        msys)
            installChocolatey
            windows
        ;;
        *)
            echo "No package to be installed"
            exit
        ;;
    esac
}

checkOS;
installPackageManager $OS;