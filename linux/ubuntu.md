# Ubuntu

## Change User Password

If you have sudo as the user and you want to change its password, you can use:
```shell
sudo passwd <username>
```
It should ask you for a new password without asking for an old one. This is
great for EC2 instances where the user does not have a password setup.

## Change the System hostname

```shell
sudo hostname your-new-name
echo "your-new-name" | sudo tee /etc/hostname
```

or recently:

```shell
sudo hostnamectl set-hostname new-hostname
```

## Show all setting for a particular module:

This will print all setting that begin with this prefix.
```shell
sudo sysctl net.ipv4
```

## Change Console Settings
```shell
sudo vi /etc/default/console-setup
#and change the values for font type and font size to

FONTFACE="TER"
FONTSIZE="16x32"
```

## List IP routes
```shell
ip route list
ip route get <IP>
```