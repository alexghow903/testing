#!/bin/bash

### All credits go to Mothenjoyer69, Segfault, and Neggles.
## Thank Neggles for the script.

# install patched mesa + block any updates from main repos
echo -n "Adding mesa copr... "
sed -i '2s/^/exclude=mesa*\n/' /etc/yum.repos.d/fedora.repo
sed -i '2s/^/exclude=mesa*\n/' /etc/yum.repos.d/fedora-updates.repo
dnf5 copr enable @exotic-soc/bc250-mesa -y
dnf5 upgrade -y 

# make sure radv_debug option is set in environment
echo -n "Setting RADV_DEBUG option... "
echo 'RADV_DEBUG=nocompute' > /etc/environment

# install segfaults governor
echo "Installing GPU governor... "
dnf install libdrm-devel cmake make g++ git -y
git clone https://gitlab.com/TuxThePenguin0/oberon-governor.git && cd oberon-governor
cmake . && make && make install
systemctl enable oberon-governor.service

# make sure amdgpu and nct6683 options are in the modprobe files and update initrd
echo -n "Setting amdgpu module option... "
echo 'options amdgpu sg_display=0' > /etc/modprobe.d/options-amdgpu.conf
echo -n "Setting nct6683 module option... "
echo 'options nct6683 force=true' > /etc/modprobe.d/options-sensors.conf

# # clear nomodeset from /etc/default/grub and update config
# echo "Fixing up GRUB config..."
# sed -i 's/nomodeset//g' /etc/default/grub
# sed -i 's/amdgpu\.sg_display=0//g' /etc/default/grub
# grub2-mkconfig -o /etc/grub2.cfg

