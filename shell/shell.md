
## Encode string SHA256

```shell
echo -n "choose-one" | sha256sum
```

## Change User Password

If you have sudo as the user and you want to change its password, you can use:
```shell
sudo passwd <username>
```

NOTE: This should work for `root` even if it's locked.

It should ask you for a new password without asking for an old one. This is
great for EC2 instances where the user does not have a password setup.

## Date Formats

```shell
date +%F
# 2026-05-12
date +%FT%T
# 2026-05-12T16:49:40
```