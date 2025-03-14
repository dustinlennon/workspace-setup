workplace-setup
====

I use this script to manage my projects.  In particular, I maintain a `$HOME/Workspace` directory that contains three subdirectories.  `./Sandbox` contains project folders, whereas `./Active` and `./Journal` contain symbolic links to the respective project folders.  This allows me to easily maintain both a shortlist of ongoing projects as well as a historical record.  

For example, `./create event-notify` produces the following:

+ `$HOME/Workspace/Sandbox/event-notify` (directory)
+ `$HOME/Workspace/Active/event-notify` (link)
+ `$HOME/Workspace/Journal/2025-03.event-notify` (link)

Furthermore, it creates a corresponding repo on my personal github account and pushes an initial, default commit on the `main` branch.



Dependencies
----

### Install github "gh"

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
```

### bash-function-library

