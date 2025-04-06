# Disable unprivileged user namespaces
sudo sysctl -w kernel.unprivileged_userns_clone=0
echo "kernel.unprivileged_userns_clone=0" | sudo tee /etc/sysctl.d/99-disable-userns.conf
sudo sysctl --system
