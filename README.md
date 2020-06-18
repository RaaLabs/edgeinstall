# edgepostinstall

Scripts, config and helper programs to do the post install needed on the edge boxes

## Steps

1. clr-installer stuff
    - [ ] Use the previously started config and post script in:\
    <https://github.com/RaaLabs/clearlinux/tree/master/examples/mix%20-%20release%20with%20post%20install%20example>
        - [ ] Create an installer clr-installer.yaml that will hold:
            - [x] Disk partitioning
            - [ ] Users
            - [ ] Bundles to include by default
            - [ ] Post install scripts to run
                - [ ] What can be run directly via the installer
                - [ ] What should be run as a one time boot script controlled via systemd
        - [ ] Create a wrapper script scripts to call the other tasks
            - [ ] In `scripts/post-install-on-edge.sh` clone the repository `git@github.com:RaaLabs/edgepostinstall.git`

2. Swupd config (can be done with systemd script)
    - [ ] Use scripts from ansible automation:\
    <https://github.com/RaaLabs/clearlinux/tree/master/automation-scripts>
        - [ ] Install sftp service, and enable to autostart with correct settings
        - [ ] Set correct swupd config
        - [ ] set swupd mirror to local sftp service

3. Set ip adresses on interfaces (can be done with systemd script)
    - [ ] TODO
        - [ ] Should it be done automatically, or with a onetime script to run at startup ?
        - [ ] Make sure gatway are only added to the ones who are supposed to route externally

4. Generate passwords, and eventual users (can be done with systemd script)
    - [ ] TODO
        - [ ] Users and password should be printed to console so they can be registered in 1Password

5. Configure wireguard (can be done with systemd script)
    - [ ] Partially done in the `wireguardinitconf`program, and the rest is done in <https://github.com/RaaLabs/clearlinux/tree/master/automation-scripts>
        - [x] Install wireguard
        Already done since the bundle `network-basics` are in the mix
        - [x] Create systemd config for wireguard start with timer
        Done with `wireguard-systemctl-auto-restart-timer`
        - [x] Create private and public keys
        Done with `wireguardinitconf`
        - [x] Create wg0.conf with unique and routable local ip
        Done with `wireguardinitconf`

6. IOTedge (can be done with systemd script)
    - [ ] TODO
        - [ ] Check what is needed here since it is all running in docker now

7. 4G/LTE (can be done with systemd script)
    - [ ] TODO, procedure described in the `doc-clear-linux` doc
        - [ ] Install modemmanager
        - [ ] configure modem and interface
        - [ ] Enable modemmanager in systemd

8. Get serial number
    - [x] Script done in ./getsysteminformation/getsysteminformation

- [x] one
- [ ] two
