#!/bin/bash

# def values
DEFAULT_GAPS_IN=6
DEFAULT_GAPS_OUT=4
DEFAULT_ROUNDING=4
DEFAULT_BORDER_SIZE=3

# Вытаскиваем именно числовое значение int
CURRENT_GAPS=$(hyprctl getoption general:gaps_in | grep "int:" | awk '{print $2}')

if [ -z "$CURRENT_GAPS" ]; then
    CURRENT_GAPS=0
fi

if [ "$CURRENT_GAPS" -gt 0 ]; then
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword decoration:rounding 0
    hyprctl keyword general:border_size 0
else
    hyprctl keyword general:gaps_in $DEFAULT_GAPS_IN
    hyprctl keyword general:gaps_out $DEFAULT_GAPS_OUT
    hyprctl keyword decoration:rounding $DEFAULT_ROUNDING
    hyprctl keyword general:border_size $DEFAULT_BORDER_SIZE
fi

# Форсируем перерисовку окон на текущем воркспейсе
hyprctl dispatch resizewindowpixel exact 100% 100%,activewindow > /dev/null 2>&1
# Или более простой триггер для обновления layout:
hyprctl dispatch splitratio 0
