# Ubuntu

## Change the System hostname

```shell
sudo hostname your-new-name
echo "your-new-name" | sudo tee /etc/hostname
```

or recently:

```shell
hostnamectl set-hostname new-hostname
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
