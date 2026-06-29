#!/bin/bash

TARGET_WS="special:hidden"
TMP_FILE="/tmp/hidden_workspace.txt"

if [ -f "$TMP_FILE" ]; then
    # Режим восстановления: возвращаем окна обратно
    ORIGINAL_WS=$(cat "$TMP_FILE")
    rm -f "$TMP_FILE"
    
    hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:hidden") | .address' | while read -r addr; do
        if [ "$addr" != "null" ] && [ -n "$addr" ]; then
            hyprctl dispatch movetoworkspace "$ORIGINAL_WS,address:$addr"
        fi
    done
else
    # Режим скрытия: сохраняем текущий воркспейс и переносим окна
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name')
    echo "$CURRENT_WS" > "$TMP_FILE"
    
    hyprctl clients -j | jq -r --arg ws "$CURRENT_WS" '.[] | select(.workspace.name == $ws) | .address' | while read -r addr; do
        if [ "$addr" != "null" ] && [ -n "$addr" ]; then
            hyprctl dispatch movetoworkspace "special:hidden,address:$addr"
        fi
    done
fi
