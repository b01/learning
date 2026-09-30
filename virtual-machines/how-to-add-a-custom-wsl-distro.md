# How To Add A Custom WSL Distro

See https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro#obtain-a-tar-file-for-the-distribution

## Prerequisites

1. WSL 2
2. Docker Desktop - Will ask to install WSL 2 during installation.

## Make an Alpine Distro

1. Open a PowerShell terminal and run a container with your distro of choice,
   like so:

   ```shell
   docker run -it --name wsl_export_ubuntu_26_04 ubuntu:26.04
   ```

2. Open another PowerShell Terminal and use docker to export the container to a tar file:

   ```shell
   docker export wsl_export_ubuntu_26_04 > "${Env:TEMP}\ubuntu-26-04.tar"
   ```

3. Cleanup by removing the container.

   ```shell
   docker rm wsl_export_ubuntu_26_04
   ```

## Import the Distro into WSL

1. Import the Alpine into WSL

   ```shell
   cd "${Env:TEMP}"
   mkdir D:\WslDistroStorage\Ubuntu-26.04
   wsl --import Ubuntu-26.04 --version "2"  D:\WslDistroStorage\Ubuntu-26.04 .\ubuntu-26-04.tar
   ```

2. Run the distro
   ```shell
   wsl -d Ubuntu-26.04
   ```

3. Make a default WSL User:
   ```shell
   apt update
   apt upgrade -y
   apt install -y passwd sudo adduser
   export myUsername="wsluser"
   adduser $myUsername sudo
   echo -e "[user]\ndefault=${myUsername}" >> /etc/wsl.conf
   passwd ${myUsername}
   exit
   ```
4. You must now quit out of that instance and ensure that all WSL instances are terminated. Start your distribution
again to see your new default user by running this command in PowerShell:

   ```shell
   wsl --terminate Ubuntu-26.04
   ```