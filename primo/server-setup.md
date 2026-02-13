# 🚀 Ubuntu 24.04 Server — Wine & PRIMO with GUI (SSH X11 Forwarding)

This document guides you through installing a graphical environment,
Wine, and your PRIMO Windows application so the GUI is displayed locally
on your laptop via SSH X11 forwarding.

---

## Prerequisites

- A fresh **Ubuntu 24.04 Server**
- Your local machine must run an X server:
  - Windows: **VcXsrv** or **Xming**
  - macOS: **XQuartz**
  - Linux: already has X11
- Your laptop will connect with:
  ```
  ssh -Y <username>@<server_ip>
  ```

## Update the Server
  ```
    sudo apt update
    sudo apt upgrade -y
  ```

## Install Graphical Desktop (Xorg + LightDM)
- This installs a minimal X11 desktop environment:
  ```
sudo apt install -y xorg lightdm lightdm-gtk-greeter
  ```

- LightDM will start a desktop session on the server’s :0 display.

## Enable SSH X11 Forwarding
- Open the SSH configuration:
  ```
sudo nano /etc/ssh/sshd_config
  ```

- Ensure the following lines are present:
  ```
AllowTcpForwarding yes
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost yes
  ```

- Save and restart:
  ```
sudo systemctl restart sshd
  ```
## Install X11 Authentication Tools

  ```
sudo apt install -y xauth
  ```
## Install Wine

- Enable 32-bit support and install Wine:
  ```
sudo dpkg --add-architecture i386
su2do apt update
sudo apt install -y wine wine64 wine32 winetricks
  ```
- Verify:
  ```
wine --version
  ```
## Create Wine Prefix for PRIMO
- Configure a custom Wine environment:
  ```
export WINEPREFIX="$HOME/.wine-primo"
export WINEARCH=win64
winecfg
  ```
- A GUI should appear via X11 forwarding to configure Wine.

## Install PRIMO
- Copy your PRIMO Windows installer to the server, then run:
  ```
wine ~/path/to/PRIMO_installer.exe
  ```

- Use the GUI installer to complete installation.

## Add Launch Alias
- Append the following to ~/.bashrc:
  ```
# PRIMO Wine Settings
export WINEPREFIX="$HOME/.wine-primo"
export WINEARCH=win64
alias start_primo='wine "$WINEPREFIX/drive_c/PRIMO/PRIMO.exe"
  ```

  ```
source ~/.bashrc
  ```

## Run PRIMO
- Connect from your laptop with:
  ```
ssh -Y fysiker@<server_ip>
  ```
- Then launch:
  ```
start_primo
  ```
- The PRIMO GUI should appear on your laptop screen.

## Notes
- Ensure your SSH client allows X11 forwarding (-Y). 

- Your local X server must be running before connecting.
