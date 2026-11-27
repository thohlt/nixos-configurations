# Installing a host

Follows the [NixOS manual](https://nixos.org/manual/nixos/unstable/#sec-installation-manual):
UEFI, GPT, ext4 inside LUKS, systemd-boot. Replace `<host>` with `laptop` or `pc`
and `/dev/nvme0n1` with your disk (check with `lsblk`).

> Partitioning wipes the whole disk. Back up first.

## 1. Boot the installer

Download a NixOS ISO (unstable or the current release, both work) from
<https://nixos.org/download/>, write it to a USB stick, and boot it in UEFI mode.
Get online (`nmtui` for Wi-Fi), then become root: `sudo -i`.

## 2. Partition, encrypt, format

```sh
DISK=/dev/nvme0n1

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB 1GB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart root 1GB 100%

cryptsetup luksFormat "${DISK}p2"
cryptsetup open "${DISK}p2" cryptroot

mkfs.fat -F 32 -n boot "${DISK}p1"
mkfs.ext4 -L nixos /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mount --mkdir -o umask=077 "${DISK}p1" /mnt/boot
```

No swap partition: the config uses zram (`zramSwap.enable`).

## 3. Get the flake and the hardware config

```sh
alias nix='nix --extra-experimental-features "nix-command flakes"'
nix shell nixpkgs#git

git clone https://github.com/thohlt/nixos-configurations /mnt/etc/nixos-configurations
cd /mnt/etc/nixos-configurations

nixos-generate-config --root /mnt --show-hardware-config > hosts/<host>/hardware-configuration.nix
git add hosts/<host>/hardware-configuration.nix
```

If the repo is private, `git clone` asks for credentials: use your GitHub
username and a [personal access token](https://github.com/settings/tokens) as
password, or copy the repo over on a USB stick.

Check the generated file: it must contain `boot.initrd.luks.devices."cryptroot"`,
`fileSystems."/"` and `fileSystems."/boot"`.

## 4. Install

```sh
nixos-install --flake .#<host> --option experimental-features "nix-command flakes"
```

It asks for a root password at the end. Then set your user's password:

```sh
nixos-enter --root /mnt -c 'passwd thohlt'
reboot
```

## 5. After the first boot

Move the checkout to your home, commit the hardware config, and push:

```sh
sudo mv /etc/nixos-configurations ~/nixos-configurations
sudo chown -R "$USER": ~/nixos-configurations
cd ~/nixos-configurations
git commit -m "<host>: add hardware-configuration.nix"
git push
```

## Day to day

Rebuilding, updating and rolling back are described in the
[README](README.md#daily-use).
