# GPG

**WARNING:** Remember never to publish keys you mean to keep hidden from the
public. Always make separate keys for UIDs you wish to publish as opposed to
UIDs you want to keep hidden. For example, you may not want to publish your
personal or work email addresses to a PGP server. Which can open you up to
spammers.

GnuPG is a complete and free implementation of the OpenPGP standard as defined
by [RFC4880] (also known as PGP). Which helps people ensure the confidentiality,
integrity and assurance of their data.

Since its introduction in 1997, GnuPG is Free Software (meaning that it
respects your freedom). It can be freely used, modified and distributed under
the terms of the GNU General Public License .

It can be made to interoperate with anything from PGP 5 and onwards.

Using encryption helps to protect your privacy and the privacy of the people
you communicate with. Encryption makes life difficult for bulk surveillance
systems.

See [GNU Privacy Guard] for more in-depth information.

## Make a New GPG Key

1. Open a terminal and generate a new key with: `gpg --full-generate-key`,
   follow the prompts, for example you can enter:

(9) ECC (sign and encrypt) (default)

(1) Curve 25519 *default*

(0) = key does not expire

## Revocation Certificate

1. Generate a revoke certificate with:
   `gpg --output revoke.asc --gen-revoke mykey`
2. I think you import the certificate, then publish it to a server to have your
   key revoked.

## Resources

1. [GNU Privacy Guard]
2. [GitHub Generating a new GPG key]
3. [OpenPGP standard RFC4880]
4. [Backup]

## General Commands

* `gpg --list-keys --keyid-format=long` - List public keys.
* `gpg --list-secret-keys --keyid-format=long` - List private keys.

## Backup

You will want to make a directory such as `gpg-backup` somewhere on your
machine.

When you have completed the steps that you want; then you'll also want to copy
the backup files to a USB drive and store it somewhere safe. Then delete the
backup files from your computer.

Try to perform this backup process everytime you make changes to your keys or
trust database.

Make sure what ever medium you store the backup on is of good quality, also two
backups is better than one. Though you don't want more than that so you don't
get confused of risk losing them into the wrong hands.

### Step 1: Backup the TrustDB

Backup the trust database:
`gpg --export-ownertrust > gpg-ownertrust-db-2025-05-16.txt`

WARNING: This does not back up keys.

### Step 2: Backup Keys

1. Make a directory inside `gpg-backup`. Name it something to relate to the UID
   you are backing up:
   `mkdir -p ./gpg-backup/crowbarjones && cd ./gpg-backup/crowbarjones`
2. Get the KEY ID with `gpg --list-secret-keys --keyid-format=long`
3. Backup your key:
   ```shell
   $Env:GPG_UID="Crowbar Jones (Bear of Action) <crowbarjones@example.com>"
   # or
   $Env:GPG_UID="0000000000000000"
   $Env:GPG_FILE_PREFIX="crowbarjones"
   gpg --export --armor "${Env:GPG_UID}" > "${Env:GPG_FILE_PREFIX}.public.asc"
   gpg --export-secret-keys --armor "${Env:GPG_UID}" > "${Env:GPG_FILE_PREFIX}.private.asc"
   gpg --export-secret-subkeys --armor "${Env:GPG_UID}" > "${Env:GPG_FILE_PREFIX}.sub_private.asc"
   ```

There is a Powershell function [backup_gpg_key] I made that you can use to
backup GPG keys on Windows. It requires a tool such as [GPG4Win].

## Restore

Load your backup (via USB or other media) to the machine you want to restore
them on. Then open a terminal to that directory. This also assumes you have
gpg installed.

### Step 1: Restore the TrustDB

Restore the trust database:
`gpg --import-ownertrust > gpg-ownertrust-db-2025-05-16.txt`

WARNING: This does not restore the keys themselves.

### Step 2: Restore Keys

1. cd to the backup files directory.
2. Restore your gpg key:
   ```shell
   GPG_FILE_PREFIX="crowbarjones"
   gpg --import "${GPG_FILE_PREFIX}.public.asc"
   gpg --import "${GPG_FILE_PREFIX}.private.asc"
   gpg --import "${GPG_FILE_PREFIX}.sub_private.asc"
   gpg --import-ownertrust ownertrust.txt
   ```
3. Optionally, set the ultimate trust level of your key:
   1. Run: `gpg --edit-key "0000000000000000"`
   2. Select trust
   3. select 5.
      NOTE: This should be set from the import.

## Add to Git CLI

1. Run `gpg --list-secret-keys --keyid-format=long` to make sure it is available.
    ```shell
    # output from Powershell
    [keyboxd]
    ---------
    sec   ed25519/0000000000000001 2025-03-19 [SC]
        0000000000000000000000000000000000000001
    uid                 [ultimate] Crowbar Jones (Bear of Action) <crowbarjones@example.com>
    ssb   cv25519/000000000000000A 2025-03-19 [E]
    ```
2. Add to Git so that it uses your key by default to sign tags and commits:
   ```shell
   git config --global user.signingkey 0000000000000001!
   ```
   NOTE: If you use multiple keys and subkeys, then you should append an
   exclamation mark ! to the key to tell git that this is your preferred key.
3. Optional, set Git to use the email and name:
   ```shell
   git config --global user.email "crowbarjones@example.com"
   git config --global user.name "Crowbar Jones"
   ```
4. Optionally, to configure Git to sign all commits and tags by default, enter
   the following commands:
   ```shell
   git config --global commit.gpgsign true
   git config --global tag.gpgSign true
   ```

## Add to GitHub

1. Run `gpg --list-secret-keys --keyid-format=long` to make sure it is available.
    ```shell
    # output from Powershell
    [keyboxd]
    ---------
    sec   ed25519/0000000000000000 2025-03-19 [SC]
        0000000000000000000000000000000000000000
    uid                 [ultimate] Crowbar Jones (Bear of Action) <crowbarjones@example.com>
    ssb   cv25519/000000000000000A 2025-03-19 [E]
    ```
2. Display the public key.
   ```shell
   gpg --armor --export 3AA5C34371567BD2
   ```
3. Copy the output and [add your GPG key to your GitHub account].

## Add Additional UIDs

You can tie multiple UIDs to a single key, for example, add your work email
address to your key existing key that you have published; then also add a
Subkey to use for work.

This allows you to tie multiple accounts back to your keys. For example, you
can make a key for your LinkedIn, GitHub, and Twitter accounts, or your
streamer accounts like YouTube and Twitch, and so on.

Its really up to you, and what helps makes securing things without adding too
much difficulty.

Here's how to add a UID to an existing key:

1. Run `gpg --list-secret-keys --keyid-format=long` to list the existing secret
   keys you have available.
2. Run to edit the key `gpg --edit-key 0000000000000000`
3. Enter `adduid` and follow the prompts.
4. To confirm your selections enter `O` for Okay.
5. Enter your key's passphrase.
6. Last, enter `save`, this will save and quit.

One drawback to UIDs is that you cannot attach them to subkeys. They are tied to
the Master key only.

## Add a SubKey

GnuPG actually uses a signing-only key as the primary key, and creates an
encryption subkey automatically. Without a subkey for encryption, you can't
encrypt, say emails.

But you can take advantage of this. You can add multiple sub keys for different
purposes. For example, you can add one for GitHub to sign build artifacts, and
another for BitBucket, or etc. The beauty of this feature is it is possible to
revoke a GPG sub key independently of the primary key.

Here's how to add a sub key:

1. Run `gpg --list-secret-keys --keyid-format=long` to make sure it's available.
2. Run to edit the key `gpg --edit-key 0000000000000000`
3. Enter `addkey` and follow the prompts, but be sure to enter an email that is
   O.K. to expose publicly, like a no-reply address.
4. To confirm your selections enter `O` for Okay.
5. Enter your key's passphrase.
6. Enter `save`, this will save and quit.

## Revoke a Key

Rather than remove a key, you will want to just revoke it. Especially if you've
published it to a key sever or shared it with someone.

1. Show the key ID `gpg --list-secret-keys --keyid-format=long`
2. Start the edit with `gpg --edit-key <ID>`
3. Select the UID to remove with `uid <#>`
4. Enter `revkey`
5. Enter `save`, you'll be asked for your passphrase.
or

```shell
gpg --list-secret-keys --keyid-format=long
$Env:GPG_UID="0000000000000000"
$Env:GPG_FILE_PREFIX="crowbarjones"
gpg --output "${Env:GPG_FILE_PREFIX}-revoke.asc" --gen-revoke "${Env:GPG_UID}"`
```
## Remove UID

WARNING: THIS IS ONLY FOR UIDs YOU HAVE NOT SHARED WITH ANYONE OR PUBLISHED TO
A KEY SERVER.

I messed up the first time I added a UID. I needed to remove it. Since I had not
pushed it anywhere I can delete it so that there is no trace of it.

1. Show the key ID `gpg --list-secret-keys --keyid-format=long`
2. Start the edit with `gpg --edit-key <ID>`
3. Select the UID to remove with `uid <#>`
4. Enter `deluid`
5. Enter `save`, you'll be asked for your passphrase.

## Encrypt & Decrypt

1. Load any public keys of users you want to send anything encrypted.
2. List they keys `gpg --list-keys`.
   ```shell
   pub   ed25519 2025-03-19 [SC]
         0000000000000000000000000000000000000000
   uid           [ultimate] Crowbar Jones (Bear of Action) <crowbarjones@example.com>
   sub   cv25519 2025-03-19 [E]

   pub   ed25519 2025-03-19 [SC]
         0000000000000000000000000000000000000001
   uid           [ultimate] Panda (Pan Pan) <panda2048@example.com>
   sub   cv25519 2025-03-19 [E]

   pub   ed25519 2025-05-06 [SC]
         0000000000000000000000000000000000000002
   uid           [ultimate] Ice Bear (Will Protect U) <icebear2000@example.com>
   sub   cv25519 2025-05-06 [E]
   ```
3. Find a file, for testing lets make up one:
   ```shell
   echo "Let go to the ballpark if we can't find our bro." > 2-bear-tuesdays.txt
   ```
4. Now let's encrypt it: `gpg -e -r Panda 2-bear-tuesdays.txt`.
5. You should get a file with ".gpg" appended to it for example
   `2-bear-tuesdays.txt.gpg`, which you now send the file to the person you
   encrypted it for.
6. If someone sent you a file you Decrypt it like so: `gpg -d <filename>`.
   For example, we decrypt the test file with `gpg -d 2-bear-tuesdays.txt.gpg`.

## List of Key Servers

List PGP Key servers. You should check them before using them.

* pgp.mit.edu
* keys.openpgp.org

## Publish To A Key Server

You do this when you want to share an Identity with users of the key server.

**WIP**

## Hide Your Private Email Address

OH NO! I didn't know what I was doing the first time a made my GPG key and
I used my private email address for the Master key.

In this situation, as longs as you have not published the key to a server, you
can edit your key to keep your private email hidden off public servers.

First lets understanding the GPG Key Structure little better:
* **Master Key**: Primarily used for certifying subkeys (i.e., signing them),
  not daily encryption/signing.
* **Subkeys**: Handle encryption, signing, and authentication in practice.
* The email address is tied to the UID (User ID) on the key. You can have
  multiple UIDs with different email addresses, and **_you can choose which to
  publish_**.

### Publishing Subkeys Without Revealing the Master UID Email
   Your best bet is to start over and make 2 separate GPG keys. 1 for your
   private personal use and another for public use. Keys are cheap.

### Commands

On Windows in Powershell, you can check that the agent is running with
`gpg-connect-agent reloadagent /bye`.

---

[GNU Privacy Guard]: https://www.gnupg.org/
[OpenPGP standard RFC4880]: https://www.ietf.org/rfc/rfc4880.txt
[GitHub Generating a new GPG key]: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
[Backup]: https://serverfault.com/questions/86048/how-to-backup-gpg
[RFC4880]: https://www.ietf.org/rfc/rfc4880.txt
[add your GPG key to your GitHub account]: https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
[GPG4Win]: https://gpg4win.org/download.html
[backup_gpg_key]: https://github.com/b01/script-lib/blob/0.1.0/gpg-key-backup-function.ps1
