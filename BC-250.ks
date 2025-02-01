#autopart --type=plain --fstype=ext4

user --name=bazzite --password=bazzite

#repo --install --name="Copr repo for bc250-mesa owned by @exotic-soc"  --baseurl=https://download.copr.fedorainfracloud.org/results/@exotic-soc/bc250-mesa/fedora-$releasever-$basearch/
#repo --install --name="Copr repo for system76-scheduler owned by kylegospo" --baseurl=https://download.copr.fedorainfracloud.org/results/kylegospo/system76-scheduler/fedora-$releasever-$basearch/

#network --bootproto=dhcp --device=link

#url --url=https://download.copr.fedorainfracloud.org/results/@exotic-soc/bc250-mesa/fedora-$releasever-$basearch/
#url --url=https://download.copr.fedorainfracloud.org/results/kylegospo/system76-scheduler/fedora-$releasever-$basearch/

#%packages --multilib
#dracut-live
#bc250-mesa
#steam
#gamescope
#system76-scheduler
#%end

%post
### All credits go to Mothenjoyer69, Segfault, and Neggles.
## Thank Neggles for the script.

# block any updates from main repos
echo -n "Adding mesa copr... "
sed -i '2s/^/exclude=mesa*\n/' /etc/yum.repos.d/fedora.repo
sed -i '2s/^/exclude=mesa*\n/' /etc/yum.repos.d/fedora-updates.repo

# make sure radv_debug option is set in environment
echo -n "Setting RADV_DEBUG option... "
echo 'RADV_DEBUG=nocompute' > /etc/environment

# make sure amdgpu and nct6683 options are in the modprobe files and update initrd
echo -n "Setting amdgpu module option... "
echo 'options amdgpu sg_display=0' > /etc/modprobe.d/options-amdgpu.conf
echo -n "Setting nct6683 module option... "
echo 'options nct6683 force=true' > /etc/modprobe.d/options-sensors.conf

# clear nomodeset from /etc/default/grub and update config
echo "Fixing up GRUB config..."
sed -i 's/nomodeset//g' /etc/default/grub
sed -i 's/amdgpu\.sg_display=0//g' /etc/default/grub
grub2-mkconfig -o /etc/grub2.cfg

# add config to gamescope to boot into big picture mode
echo "[Desktop Entry]\n
Name=Steam Big Picture Mode\n
Comment=Start Steam in Big Picture Mode\n
Exec=/usr/bin/gamescope -e -- /usr/bin/steam -tenfoot\n
Type=Application" > /usr/share/wayland-sessions/steam-big-picture.desktop
%end
