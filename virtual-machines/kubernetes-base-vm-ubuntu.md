# Kubernetes Base VM (Ubuntu)

1. Download the latest version of Ubuntu from [Get Ubuntu Server].
2. Open Oracle VirtualBox application and click "New" to make a new VM, set the
   name to something like `ubuntu-server-lts-raccoon-amd64-efi`. Replace this with
   properties of the version ISO image you will be using.
3. Skip inserting any ISO and click.

   NOTE: If you insert the ISO, then it will automatically start the
   installation. We want to avoid that so that we can further customize the
   machine.
4. Click "Specify virtual hardware", set memory to `2048` memory and `1` CPU,
   and check UEFI box.
5. Click "Specify virtual hard disk", set it to 30 GB (since Ubuntu will
   take up about 4-5 GB), click "Finish".

   NOTE: Do not Pre-allocate. This will make the image 30GB in size as apposed
   to 1-2 GB.
6. Select the VM and click settings.
7. In "General" select the "Features" tab and change "Shared Clipboard" to
   "Host to Guest" to allow copy and paste from the host to the Guest OS.
8. Now select the "Description" tab and enter a relevant description, like:

   ```text
   Ubuntu Server 26.04 LTS Resolute Raccoon. User is "vagrant" with password "vagrant" with sudo access. SSH server is active on boot.
   ```
9. Find "System" and the "Motherboard" tab, then check the
   `Enable EFI (special OSes only)`, select "ICH9" Chipset, and set "TMP" to
   "v2.0".
10. Then select "Storage", click the "Empty" drive under "Controller IDE", a
    small circle drive Icon will appear. Click that and find the ISO image you
    downloaded and select it.
11. Go to "Network" section and click th "Adapter 2" tab, then select
    "NAT" and uncheck "Virtual Cable Connected" to prevent IP assignment.
12. Click the "Start" button to boot the machine and install the OS.
13. When the installation is done and before selecting reboot, select the
    "Devices" menu and "Remove Disk from Optical Drive", then click enter to reboot.
14. Login to the system, remember the username and password is `vagrant`.
15. Next allow [Password-less Sudo] for the vagrant:
    ```shell
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
    ```
16. Configure the network to continue, without blocking boot, when any card
    has DNS resolution:
    1. Edit the config
       ```shell
       sudo systemctl edit systemd-networkd-wait-online.service
       ```
    2. Add the lines:
       ```text
       [Service]
       ExecStart=
       ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any --dns -o routable -i enp0s8 -i enp0s3
       ```
    3. Save.

    NOTE: This was added to prevent the network from waiting for 2+ minutes for
    the second card with no network cable.
17. Set up the Vagrant [insecure key-pairs]
    ```shell
    wget https://raw.githubusercontent.com/hashicorp/vagrant/refs/heads/main/keys/vagrant.pub
    wget https://github.com/hashicorp/vagrant/refs/heads/main/keys/vagrant.pub
    cat vagrant.pub | tee -a ~/.ssh/authorized_keys
    ```
18. Ready the system for VirtualBox Guest add-ons:
    ```shell
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential dkms linux-headers-$(uname -r)
    ```
19. In the VirtualBox window menu, go to
    `Devices > Insert Guest Additions CD image...`, to Insert the Guest
    Additions ISO into the VM CD-ROM.

    NOTE: This enables Vagrant to spin the VM up and connect via SSH to replace
    with a private key-pair.
20. Mount the CD-ROM:
    ```shell
    sudo mkdir -p /mnt/cdrom
    sudo mount /dev/cdrom /mnt/cdrom
    ```
21. Run the installer `sudo /mnt/cdrom/VBoxLinuxAdditions.run`
22. To restart the system and complete the process, run
    ```shell
    sudo reboot
    ```
    NOTE: Unmount the guess editions from the CD-ROM.
23. Ensure `PasswordAuthentication yes` and `KbdInteractiveAuthentication yes`
    are set in the `/etc/ssh/sshd_config`.
24. Run `sudo systemctl poweroff` to shut down the machine.
25. Open a CLI terminal and move to a directory where you can work.
26. We can export the machine to Vagrant with the `package` command like so:
    ```shell
    vagrant package --base ubuntu-server-lts-raccoon-amd64-efi --debug --output ubuntu-server-lts-raccoon-amd64-efi.box
    ```
27. Now we can test this new box by adding it to Vagrant:
    ```shell
    vagrant box add --name ubuntu/ubuntu-server-lts-raccoon-amd64-efi .\ubuntu-server-lts-raccoon-amd64-efi.box
    ```
28. Use the Vagrantfile in the Kubernetes Learning repo to test it by chaning
    ```ruby
    BOX_IMG = "ubuntu/ubuntu-server-lts-raccoon-amd64-efi"
    BOX_VER = "0"
    ```
29. Once your sure its working, run `vagrant destroy`.
30. You'll need to calculate the MD5 for the box:
    ```shell
    # powershell
    certutil -hashfile .\ubuntu-server-lts-raccoon-amd64-efi.box MD5
    ```
31. Go log into [Vagrant Cloud]. Go to Vagrant. Click on your box registry.
32. If it is a new box, then click Create a box, or click an existing box
    then select `Version` on the left menu. Once the
    page loads there should be an "Add Version" button somewhere on the page,
    use the version of Ubuntu.
    Fill out the form and submit, wait for the upload to complete.
    NOTE: It helps the client if you set the actual version of Ubuntu.

You can [Discover Vagrant Boxes] and search for `b01` to find the ones
I've made in my videos.

---

[Get Ubuntu Server]: https://ubuntu.com/download/server#manual-install-tab
[Vagrant Cloud]: https://developer.hashicorp.com/vagrant/vagrant-cloud
[Discover Vagrant Boxes]: https://portal.cloud.hashicorp.com/vagrant/discover
[insecure key-pairs]: https://github.com/hashicorp/vagrant/tree/main/keys