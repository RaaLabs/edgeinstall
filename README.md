# edgepostinstall

Scripts, config and helper programs to do the post install needed on the edge boxes

## Ideas

- [x] Look into making a wrapper that will call all the tasks, one by one in the `post-install-tasks` folder
  - [x] Run numbering scheme
  0 -> 100, where 0 is highest priority, equal number got equal

## Steps

1. clr-installer stuff
    - [x] Use the previously started config and post script in:\
    <https://github.com/RaaLabs/clearlinux/tree/master/examples/mix%20-%20release%20with%20post%20install%20example>
        - [ ] Create an installer clr-installer.yaml that will hold:
            - [x] Disk partitioning
            - [x] Users
                Set a default password for the installation, will be changed later in the post-install-tasks
            - [x] Bundles to include by default
                Check what should be added or removed here.
            - [x] Post install scripts to run
                - What can be run directly via the installer
                - What should be run as a one time boot script controlled via systemd
        - [x] Create a wrapper script scripts to call the other tasks
            - [x] In `scripts/post-install-on-edge.sh` clone the repository `git@github.com:RaaLabs/edgepostinstall.git` to a work directory on the installed machine

2. Swupd config (done at first bootup)
    - [x] Use scripts from ansible automation:\
    <https://github.com/RaaLabs/clearlinux/tree/master/automation-scripts>
        - [x] Install sftp service
        - [x] Enable sftp in systemd autostart with correct settings
        - [x] Set correct swupd config
        - [x] set swupd mirror to local sftp service

3. Set ip adresses on interfaces (done at first bootup)
    The interfaces to configure are:

    ```text
    Interface `enp4s0` named `Local`
    Address: `10.144.1.1/24`
    Gateway: `10.144.1.2`
    ```

    ```text
    Get available IP from ip-plan for ship\
    Interface `enp0s31f6` named `WAN`\
    Address: entered by user\
    Gateway: entered by user\
    DNS: One should be entered by user, and the other set to `8.8.8.8`
    ```

    Bring both interfaces up

    - [ ] TODO
        - [ ] Make sure gateway are only added to the ones who are supposed to route externally
        - [ ] TODO: Check that names of interface config files gets renamed:

        ```text
            % If NetworkManager/system-connections ikke er navngitt som Local og WAN:
            cd /etc/NetworkManager/system-connections/
            sudo cat Wired\ connection\ 1.nmconnection
            Se om det er ID er local eller Wan:
            sudo mv 'Wired connection 1.nmconnection' Local.nmconnection
            sudo mv 'Wired connection 2.nmconnection' WAN.nmconnection
            sudo systemctl restart NetworkManager.service
        ```

4. Generate passwords, and eventual users (done at first bootup)
    - [x]
        - [x] Users and password should be printed to console so they can be registered in 1Password.
        This one might be better done after the installation is done and you can log in via ssh and set new passwords to avoid typing long passwords in the console
        - [x] prepare keys and sudo file for ansible user
        Put into post-install part of the install image.

5. Configure wireguard (done at first bootup)
    - [x] Partially done in the `wireguardinitconf`program, and the rest is done in <https://github.com/RaaLabs/clearlinux/tree/master/automation-scripts>
        - [x] Install wireguard
        Already done since the bundle `network-basics` are in the mix
        - [x] Create systemd config for wireguard start with timer
        Done with `wireguard-systemctl-auto-restart-timer`
        - [x] Create private and public keys
        Done with `wireguardinitconf`
        - [x] Create wg0.conf with unique and routable local ip
        Done with `wireguardinitconf`
        - [x] Print vpn server command to screen
        Done with `wireguardinitconf`

6. IOTedge (done at first bootup)
    - [x] TODO: Check what is needed here since it is all running in docker now
        - [x] `mkdir -p /etc/iotedge/storage`
        - [x] create `/etc/iotedge/config.yaml`
        Check how the content is distributed to the config file, Janitor/Ansible ?

7. 4G/LTE (done at first bootup)
    - [x] TODO, procedure described in the `doc-clear-linux` doc, keeping this as a manual routine for now.
        - [x] Install modemmanager
        - [x] configure modem and interface
        - [x] Enable modemmanager in systemd

8. Get serial number (done at first bootup)
    - [x] Script done in ./get-systeminformation/getsysteminformation

9. Set FQDN for hostname (done at first bootup)
    - [x] Set a hostname for the OS
    Done in set-hostname

10. Key handling for users
    - [x] copy key pairs needed for users

11. Create directories/folders
    TODO: Check out permissions sets on these directories
    - [x] Create directories for /etc/iotedge
    - [x] Create directories for /etc/dolittle.timeseries
    Should probably be owned by the dolittle user so 777 pemissions could be set correctly.

12. Clone the post scripts to the local installations root directory
    - [ ]
