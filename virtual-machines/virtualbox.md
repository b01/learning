# VirtualBox

## Make A New VM

These steps enable the EFI on the Motherboard.

1. You need to have VirtualBox installed
   NOTE: New VirtualBox requires Python pre-installed. I'm OK with that,
   normally I would not be because I don't want to install additional software.
   I'm learning to break the eggs to make the omelet. That was hard for me
   before, and I'm not sure why.
2. Start VirtualBox and select `Machine > New...`
3. Give it a name you like, for example `ubuntu-lts-noble-64`
   NOTE: VirtualBox gave me a hard time about using this name the second time
         around. Apparently when I told it to delete all the files from before,
         it left the directory
         `C:\Users\Khalifah\VirtualBox VMs\ubuntu-lts-noble-64`. I had to
         delete it manually.
4. Skip inserting any ISO, otherwise when you click "Finish" it will
   automatically start the installation. We don't want that since we are going
   to customize.
5. For Hardware select `2048` memory and `1` CPU
   NOTE: If you can spare more and do not plan to share this machine, then feel
         free to add more of either.
6. Make sure that for "Hard Disk" you at least use 20 GB (since Ubuntu will
   take up about 4-5 GB). Do not check the `Pre-allocate Full Size` option, so
   that the disk only allocates space as it fills up
   WARNING: You can change the hard-drive type to VHD to make it compatible
   with HyperV, but VHD cannot be imported to Vagrant.
7. Click "Finish", then select your new machine and click "Settings..."
8. In "General" select the "Advanced" tab and change "Shared Clipboard" to
   "Host to Guest" to allow copy and page from the host to the Guest OS.
9. Find "System" and the "Motherboard" tab, then check the
   `Enable EFI (special OSes only)` box
   NOTE: I also selected "ICH9" Chipset and set "TMP" to "v2.0".
10. Then select "Storage", click the "Empty" drive under "Controller IDE", a
    small circle drive Icon will appear. Click that and find the ISO image you
    downloaded
11. Go to "Network" section and click th "Adapter 2" tab, then select
    "Host-only Adapter"
12. Click the "OK" button to close the settings dialog.
13. Click the "Start" button to boot the machine, the installation process
    should begin shortly, follow the prompts to complete the installation
    NOTE: Before you reboot, remove the ISO from the CD-ROM, or the system will
    do it for you, but in an unintuitive way.
14. Ready the system for VirtualBox Guest add-ons:
    ```shell
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential dkms linux-headers-$(uname -r)
    sudo systemctl poweroff
    ```
15. Start the machine again.
16. In the VirtualBox window menu, go to
    `Devices > Insert Guest Additions CD image...`, to Insert the Guest
    Additions ISO into the VM CD-ROM.
17. Mount the CD-ROM:
    ```shell
    sudo mkdir -p /mnt/cdrom
    sudo mount /dev/cdrom /mnt/cdrom
    ```
18. Run the installer `sudo /mnt/cdrom/VBoxLinuxAdditions.run`
19. Run `sudo reboot` to restart the system and complete this process.

---

[Insecure Keypairs]: https://github.com/hashicorp/vagrant/tree/main/keys
[Creating a Base Box]: https://developer.hashicorp.com/vagrant/docs/boxes/base
[VirtualBox Base Boxes]: https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes
[Default User Settings]: https://developer.hashicorp.com/vagrant/docs/boxes/base#default-user-settings
