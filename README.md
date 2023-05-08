# Command and Script Runner, a DevContainer feature that allows you to run any bash scripts without pain:

## `apt`
Install packages easily.


```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/wxw-matt/devcontainer-features/apt:latest": {
			"packages": "vim telnet curl"
        }
    }
}
```

## `command runner`
It is quite handy to have your packages installed without using other features.

You can have up to 10 commands.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/wxw-matt/devcontainer-features/command_runner:latest": {
			"command1": "curl -L 'https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose",
			"command2": "chmod +x /usr/local/bin/docker-compose"
        }
    }
}
```

## `script runner`

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

### Explanation
The format of value for `script{1-10}` is `filename#url`. For example, if a gist is used, the value should look like:
```
install_vim_plugins#https://gist.githubusercontent.com/wxw-matt/ff35edb5e60c2a404b18724bf63be964/raw
```
The `install_vim_plugins` is the filename in the image/container, and it will be stored in directory `/usr/local/scripts_runner/scripts`.

The `https://gist.githubusercontent.com/wxw-matt/ff35edb5e60c2a404b18724bf63be964/raw` is where the file is downloaded from.


The `/raw` in the url will make GitHub return the content of the `gist`.

Note:
> You can have up to `10` scripts from `script1` to `script10`. The `script runner` will run each of them in order.
