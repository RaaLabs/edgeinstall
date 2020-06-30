# wireguardinitconf

Flags

```bash
  -configDir string
        the location where the config will be written to, and you probably want to set this to '/etc/wireguard/' (default "./wireguard/")
  -endPointAndPort string
        the endpoint and port to connect to, e.g. onewire.somesite.com:5560
  -localAddress string
        the local ip of the wireguard client, e.g. 10.10.10.10/32
```

The program will get all it's options from the `wireguard-wg0.conf.json` file, except for the local address.

Private and public keys will be generated, and the files will be put into where the `-configDir` flag is set to. Normally this should be `/etc/wireguard/`.
The value of the public key will be printed to the console when finnished.

All default settings can/should be set in the yaml file, unless the flags are used. Flags will also take precedence over the value set in the yaml file.