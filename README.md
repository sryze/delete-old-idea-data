# delete-old-idea-data

This shell script allows you to easily delete the folders left by previous versions of IntelliJ IDEA and other JetBranins IDEs after upgrading them.

Supported OS:
* Linux, macOS, etc (any *nix with a Bash shell)
* Windows - via Git Bash/Cygwin/MinGW

Usage:

```
Usage: ./delete-old-idea-data.sh [--keep-versions N] [--cache-only] [--dry-run] ide_name1 ... ide_nameN

--keep-versions N               Number of previous versions to keep (default is 1)
--cache-only                    Delete only the caches
--dry-run                       Don't actually delete anything
ide_name1 ... ide_nameN         IDE names can be one of: IntelliJIdea, IdeaIC, CLion, GoLand, WebStorm, PhpStorm, AppCode
```
