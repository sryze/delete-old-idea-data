#!/bin/bash

IDE_LIST=""
KEEP_VERSIONS=1
CACHE_ONLY=0
DRY_RUN=0

while [ -n "$1" ]
do
    case "$1" in
        -h|--help)
            echo "Usage: $0 [--keep-versions N] [--cache-only] [--dry-run] ide_name1 ... ide_nameN"
            echo ""
            echo -e "--keep-versions N\t\tNumber of previous versions to keep (default is 1)"
            echo -e "--cache-only\t\t\tDelete only the caches"
            echo -e "--dry-run\t\t\tDon't actually delete anything"
            echo -e "ide_name1 ... ide_nameN\t\tIDE names can be one of: IntelliJIdea, IdeaIC, CLion, GoLand, WebStorm, PhpStorm, AppCode, AndroidStudio"
            exit
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

if [ "$IDE_LIST" = "" ]; then
    IDE_LIST="IntelliJIdea IdeaIC"
fi

CONFIG_PREFIX=
CACHE_PREFIX=
case "$(uname -s)" in
    CYGWIN*|MSYS*|MINGW*)
        CONFIG_PREFIX="$APPDATA/Google:$APPDATA/JetBrains"
        CACHE_PREFIX="$LOCALAPPDATA/Google:$LOCALAPPDATA/JetBrains"
        ;;
    Darwin*)
        CONFIG_PREFIX="$HOME/Library/Application Support/Google:$HOME/Library/Application Support/JetBrains"
        CACHE_PREFIX="$HOME/Library/Caches/Google:$HOME/Library/Caches/JetBrains"
        ;;
    *)
        CONFIG_PREFIX="$HOME/.config/Google:$HOME/.config/JetBrains"
        CACHE_PREFIX="$HOME/.cache/Google:$HOME/.cache/JetBrains"
        ;;
esac

function find_subdirs() {
    local dir=$1
    local ide=$2
    local start
    start=$((KEEP_VERSIONS + 1))
    find "$dir" -type d -name "$ide*" | sort -urV | tail +2 | tail +$start
}

function delete_dir() {
    dir=$1
    if [ "$DRY_RUN" -ne 0 ]; then
            echo "[dry-run] Deleting $dir ..."
    else
        echo "Deleting $dir ..."
        rm -rf "$dir"
    fi
}

deleted_count=0

for ide in $IDE_LIST; do
    if [ "$CACHE_ONLY" -eq 0 ]; then
        for dir in ${CONFIG_PREFIX//:/ }; do
            for config_dir in $(find_subdirs "$dir" "$ide"); do
                delete_dir "$config_dir"
                deleted_count=$((deleted_count + 1))
            done
        done
    fi
    for dir in ${CACHE_PREFIX//:/ }; do
        for cache_dir in $(find_subdirs "$dir" "$ide"); do
            delete_dir "$cache_dir"
                deleted_count=$((deleted_count + 1))
        done
    done
done

if [ $deleted_count -eq 0 ]; then
    echo "Nothing to delete"
fi
