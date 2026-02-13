#!/usr/bin/env bash

# ======================================================
# Ubuntu 24.04 Server Setup for Wine/PRIMO with X11 GUI
# How to run:
#   chmod +x install_primo_server.sh
#   ./install_primo_server.sh
# ======================================================

pause() {
  echo
  echo ">>> Press ENTER to continue ..."
  read -r
}

echo "→ Updating the server..."
sudo apt update
sudo apt upgrade -y
pause

echo "→ Installing Xorg and LightDM..."
sudo apt install -y xorg lightdm lightdm-gtk-greeter
pause

echo "→ Configuring SSH for X11 forwarding..."
sudo sed -i 's/^#*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*X11DisplayOffset.*/X11DisplayOffset 10/' /etc/ssh/sshd_config
sudo sed -i 's/^#*X11UseLocalhost.*/X11UseLocalhost yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
pause

echo "→ Installing X11 authentication tools..."
sudo apt install -y xauth
pause

echo "→ Installing Wine..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine wine64 wine32 winetricks
pause

echo "→ Check Wine version:"
wine --version
pause

echo "→ Setting up PRIMO Wine prefix..."
export WINEPREFIX="$HOME/.wine-primo"
export WINEARCH=win64
winecfg
pause

echo "→ Please now install PRIMO using its installer (GUI will show)."
echo "   E.g. copy the installer to ~/ then run:"
echo "      wine ~/PRIMO_installer.exe"
pause

echo "→ Adding PRIMO alias to ~/.bashrc..."
cat << 'EOF' >> ~/.bashrc

# PRIMO Wine Settings
export WINEPREFIX="$HOME/.wine-primo"
export WINEARCH=win64
alias start_primo='wine "$WINEPREFIX/drive_c/PRIMO/PRIMO.exe"'
EOF

echo "→ Reloading ~/.bashrc"
source ~/.bashrc
pause

echo "→ Installation complete!"
echo "   To run PRIMO, reconnect using:"
echo "     ssh -Y fysiker@<server_ip>"
echo "   Then run:"
echo "     start_primo"
