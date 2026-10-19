#!/bin/bash
# Let fcitx5 finish (overrides Plasma's kxkbrc config = keyboard layouts)
# to apply my own settings back
SHOULD_SLEEP=true

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-sleep)
            SHOULD_SLEEP=false
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if [ "$SHOULD_SLEEP" = true ]; then
    echo "The --no-sleep flag was missing. Sleeping for 5 seconds..."
    sleep 5
else
    echo "The --no-sleep flag was detected. Skipping sleep!"
fi

chezmoi apply --force ~/.config/kxkbrc

gdbus emit --session --object-path /kxkbrc \
  --signal org.kde.kconfig.notify.ConfigChanged \
  "{'Layout': @aay [b'LayoutList', b'VariantList', b'Use']}"

