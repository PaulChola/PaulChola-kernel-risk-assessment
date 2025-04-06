#!/bin/bash

echo "==== Linux Kernel Namespace Filesystem Exploit Checker ===="

# Get the current kernel version
kernel_ver=$(uname -r | cut -d '-' -f1)
echo "[+] Detected Kernel Version: $kernel_ver"

# Convert to comparable version
ver_major=$(echo $kernel_ver | cut -d '.' -f1)
ver_minor=$(echo $kernel_ver | cut -d '.' -f2)
ver_patch=$(echo $kernel_ver | cut -d '.' -f3)

# Check if unprivileged user namespaces are enabled
userns_enabled=$(cat /proc/sys/kernel/unprivileged_userns_clone)

echo "[+] Unprivileged User Namespaces: $( [ "$userns_enabled" -eq 1 ] && echo "ENABLED" || echo "DISABLED" )"

# Basic vulnerable range check (between 2.6.12 and 6.12.0)
vuln=true
if [ "$ver_major" -lt 2 ]; then
    vuln=false
elif [ "$ver_major" -eq 2 ] && [ "$ver_minor" -lt 6 ]; then
    vuln=false
elif [ "$ver_major" -ge 7 ]; then
    vuln=false
elif [ "$ver_major" -eq 6 ] && [ "$ver_minor" -gt 12 ]; then
    vuln=false
fi

# Final verdict
if [ "$vuln" = true ] && [ "$userns_enabled" -eq 1 ]; then
    echo "[!] Your system is POTENTIALLY VULNERABLE."
    echo "    -> Kernel version is within affected range."
    echo "    -> Unprivileged user namespaces are ENABLED."
else
    echo "[✓] Your system is likely NOT vulnerable based on current configuration."
fi

echo "============================================================"
