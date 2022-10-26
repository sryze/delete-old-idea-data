#!/bin/bash

IDE_LIST="IntelliJIdea IdeaIC"
KEEP_VERSIONS=1
CACHE_ONLY=0
DRY_RUN=0

while [ ! -z "$1" ]
do
    case "$1" in
        -h|--help)
            echo "Usage: $0 [--keep-versions N] [--cache-only] [--dry-run] ide_name1 ... ide_nameN"
            echo ""
            echo -e "--keep-versions=N\t\tNumber of previous versions to keep (default is 1)"
            echo -e "--cache-only\t\t\tDelete only the caches"
            echo -e "--dry-run\t\t\tDon't actually delete anything"
            echo -e "ide_name1 ... ide_nameN\t\tIDE names can be one of: IntelliJIdea, IdeaIC, CLion, GoLand, WebStorm, PhpStorm, AppCode"
            exit
            shift
            ;;
        --keep-versions)
            shift
            KEEP_VERSIONS=$1
            shift
            ;;
        --cache-only)
            CACHE_ONLY=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        IntelliJIdea|IdeaIC|CLion|GoLand|WebStorm|PhpStorm|AppCode|AndroidStudio)
            IDE_LIST="$IDE_LIST $1"
            shift
            ;;
        *)
            echo "Error: Unrecognized argument: $1" && exit 1
            shift
            ;;
    esac
done

CONFIG_PREFIX=
CACHE_PREFIX=
case "$(uname -s)" in
    CYGWIN*|MSYS*|MINGW*)
        CONFIG_PREFIX="$APPDATA/JetBrains"
        CACHE_PREFIX="$LOCALAPPDATA/JetBrains"
        ;;
    Darwin*)
        CONFIG_PREFIX="$HOME/Library/Application Support/JetBrains"
        CACHE_PREFIX="$HOME/Library/Caches/JetBrains"
        ;;
    *)
        CONFIG_PREFIX="$HOME/.config/JetBrains"
        CACHE_PREFIX="$HOME/.cache/JetBrains"
        ;;
esac

deleted_count=0

for ide in $IDE_LIST; do
    start=$(expr $KEEP_VERSIONS + 1)
    if [ "$CACHE_ONLY" -eq 0 ]; then
        config_dirs=$(find "${CONFIG_PREFIX}" -type d -name "$ide*" | sort -ur | tail +2 | tail +$start)
    fi
    cache_dirs=$(find "${CACHE_PREFIX}" -type d -name "$ide*" | sort -ur | tail +2 | tail +$start)
    IFS=$'\n'
    for dir in $(echo "$config_dirs") $(echo "$cache_dirs"); do
        if [ "$DRY_RUN" -ne 0 ]; then
            echo "[dry-run] Deleting $dir ..."
        else
            echo "Deleting $dir ..."
            rm -rf "$dir"
        fi
        deleted_count=$(expr $deleted_count + 1)
    done
done

if [ $deleted_count -eq 0 ]; then
    echo "Nothing to delete"
fi
