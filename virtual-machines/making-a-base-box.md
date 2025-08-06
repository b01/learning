## Making A Base Box

## VirtualBox

It will help to read [Creating a Base Box] and [VirtualBox Base Boxes] to gain
more understanding before/after using these instructions below. Also see
[Default User Settings] to understand the "why" behind the vagrant user set up.
Then there are more details about [Packaging the Box] you should review as well.

1. If you don't have one already, please [Make A New VM] as a clean starting
   point.
2. Make sure `sudo` command is installed and works, this can be checked when you
   run the command to update the system `sudo apt update`; which needs to be
   done anyway.
3. Now run `sudo apt upgrade` to upgrade the system to the latest stable
   packages and security updates.
4. Next allow [Password-less Sudo] for the vagrant user by adding
   `vagrant ALL=(ALL) NOPASSWD: ALL` to the end of the file `/etc/sudoers`:
   ```shell
   echo "vagrant ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
   ```
5. Set up the Vagrant [insecure key-pairs] so it can gain access during boot
   to attempt SSH login into the machine. Upon success, it will add a new
   secure key-pair
   ```shell
   wget https://raw.githubusercontent.com/hashicorp/vagrant/refs/heads/main/keys/vagrant.pub
   cat vagrant.pub | tee -a ~/.ssh/authorized_keys
   ```
6. Ensure `PasswordAuthentication yes` and `KbdInteractiveAuthentication yes`
   are set in the `/etc/ssh/sshd_config` so we can use ssh-copy-id, at
   the time of writing this, both their defaults are yes.
7. Optionally set the `root` account password to "vagrant" as suggested
   [Root Password: "vagrant"]
8. Run `sudo systemctl poweroff` to shut down the machine.
9. Open a CLI terminal and move to a directory where you can work.
10. We can export the machine to Vagrant with the `package` command like so:
    ```shell
    vagrant package --base ubuntu-lts-noble-64 --output ubuntu-lts-noble-64.box
    ```
    NOTE: Use the exact name you gave the machine in VirtualBox as the `--base`
    name. Vagrant will pick it up from VirtualBox and save it as "package.box".
    Using the `--output` option allows us to set a specific name. In this case the
    same name as the VirtualBox machine.
11. Now we can test the box out by adding it to Vagrant:
    vagrant box add --name ubuntu/lts-noble-64 .\ubuntu-lts-noble-64.box
    ```shell
    vagrant box add --name ubuntu/lts-noble-64 .\ubuntu-lts-noble-64.box
    ```
12. Generate a Vagrantfile, then run `vagrant up`:
    ```shell
    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    Vagrant.configure("2") do |config|

      config.vm.box = "ubuntu/lts-noble-64"

      config.vm.box_check_update = false

      config.vm.network "private_network", ip: "192.168.33.10"

      config.vm.provider "virtualbox" do |vb|
        # Customize the amount of memory on the VM:
        vb.memory = "2048"
        vb.cpus = 1
      end
    end
    ```
13. Once your sure its working, run `vagrant destroy`.
14. You'll need to calculate the MD5 for the box:
    ```shell
    # powershell
    # certutil -hashfile <filename> MD5
    certutil -hashfile .\ubuntu-lts-noble-64.box MD5
    ```
15. Go log into Vagrant Cloud. If it is a new box, then click Create a box,
    or add a version.
16. Fill out the form and submit, wait for the upload to complete.

---

[Password-less Sudo]: https://developer.hashicorp.com/vagrant/docs/boxes/base#password-less-sudo
[insecure key-pairs]: https://github.com/hashicorp/vagrant/tree/main/keys
[Root Password: "vagrant"]: https://developer.hashicorp.com/vagrant/docs/boxes/base#root-password-vagrant
[Packaging the Box]: https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes#packaging-the-box
[Creating a Base Box]: https://developer.hashicorp.com/vagrant/docs/boxes/base
[VirtualBox Base Boxes]: https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes
[Default User Settings]: https://developer.hashicorp.com/vagrant/docs/boxes/base#default-user-settings
[Make A New VM]: /virtual-machines/making-a-base-box.md
