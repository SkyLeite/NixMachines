#!/usr/bin/env bash

if [ -z "$1" ]; then
    # Initial invocation. Display options
    current_tabs_json=$(dbus-send --session --print-reply=literal --dest="org.cubimon.BrowserTabs" /org/cubimon/BrowserTabs org.cubimon.BrowserTabs.tabs)
    current_tabs=$(jq -r 'to_entries[] | .value + "\\0info\\x1f" + .key' <<<"$current_tabs_json")
    echo -en "$current_tabs"
else
    # User selected something!
    dbus-send --session --print-reply=literal --dest="org.cubimon.BrowserTabs" /org/cubimon/BrowserTabs org.cubimon.BrowserTabs.activate "uint64:$ROFI_INFO"
    exit 1
fi
