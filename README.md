# Homelab
scripts and config for my homelab setup

## Ansible

### Basic ansible installation and dependency 

``` bash
python3 -m pip install --user ansible
```
See also [Getting Started (latest)](https://docs.ansible.com/ansible/latest/getting_started/index.html)

Install all the dependencies:
``` bash
ansible-galaxy install -r requirements.yml
```

### Check connectivity

``` bash
 ansible all --list-hosts -i inventory
 ansible -m ping -i inventory --ask-vault-pass
```
**Note:** `--ask-vault-pass` will prompt for the secret stored in bitwarden to unlock the private key in the inventory file.

### Secret and security management

Bitwarden is used to manage all secrets, and occassionally ansible vault.

StrictHostChecking=no option is used in the inventory file. While this should not be used for _production_ environments, it is considered adequate for a development environment such as a homelab.

#### Using Ansible vault

``` bash
ansible-vault encrypt_string <secret>
```

#### Using Bitwarden

Bitwarden can be used to store the vault password. First install the bitwarden CLI via npm:

``` bash
sudo apt install npm jq
sudo npm install -g @bitwarden/cli
```

after that use 

``` bash
source unlock_bw.sh
```

to unlock the bitwarden vault and export a SESSION key. This will enable password-less use of the ansible playbooks.

[Source](https://theorangeone.net/posts/ansible-vault-bitwarden/)

#### SSH Key

The management ssh-key is generated using Ed25519

``` bash
ssh-keygen -t ed25519
```

The public key is stored in the `ssh/` folder. The private key is encrypted using ansible vault. The public can be copied to the management host using `ssh-copy-id`.

``` bash
ssh-copy-id -i pub_key username@server_ip
```

### Troubleshooting
* **If you get the warning, that .local/bin is not part of the PATH variable:**
  ``` bash
  WARNING: The script ansible-community is installed in '/home/sseifried/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
  ```

  just re-source bash:
  ``` bash
  source ~/.profile
  ```

  The necessary configuration should be part of your .profile

  ``` bash
  # set PATH so it includes user's private ~/.local/bin if it exists
  if [ -d "$HOME/.local/bin" ] ; then
      PATH="$HOME/.local/bin:$PATH"
  fi
  ```
