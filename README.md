# delete-old-idea-data

This shell script allows you to easily delete the folders left by previous versions of JetBranins IDEs after upgrading them.

Supported OS:
* Linux, macOS, etc (any *nix with a Bash shell)
* Windows - via Git Bash/Cygwin/MinGW/WSL

Usage:

```
./delete-old-idea-data.sh [--keep-versions=N] [--cache-only] [--dry-run] IntelliJIdea IdeaCI GoLand WebStorm
```