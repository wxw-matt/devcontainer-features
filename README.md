# Script Runner, a DevContainer feature that allows you to run any bash scripts without pain:

## How to use it

### `script runner`

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/wxw-matt/devcontainer-features/script_runner:latest": {
            "script1": "install_vim_plugins#https://gist.githubusercontent.com/wxw-matt/ff35edb5e60c2a404b18724bf63be964/raw",
            "script2": "avoid_password_service_ssh_start#https://gist.github.com/wxw-matt/186afd98891bd2c26adfb5b3045d236c/raw"
        }
    }
}
```

## Explanation
The format of value for `script#` is `filename:url`. For example, if a gist is used, the value should look like:
```
install_vim_plugins#https://gist.githubusercontent.com/wxw-matt/ff35edb5e60c2a404b18724bf63be964/raw
```
`/raw` will make GitHub return the content of the `gist`.

Note:
> You can have up to `10` scripts from `script1` to `script10`. The `script runner` will run each of them in order.
