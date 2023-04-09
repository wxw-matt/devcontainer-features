# Script Runner, a DevContainer feature that allow you to run any bash scripts without pain:

## How to use it

### `script runner`

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/wxw-matt/devcontainer-features/script_runner:0": {
            "script1": "show_custom_ubuntu_welcome_info#https://gist.githubusercontent.com/wxw-matt/b1ebbb71d26f4da08389ce5d54baf0c0/raw",
            "script2": "avoid_password_service_ssh_start#https://gist.github.com/wxw-matt/186afd98891bd2c26adfb5b3045d236c/raw"
        }
    }
}
```

You can have up to 10 scripts from `script1` to `script10`. The `script runner` will run each of them in order.
