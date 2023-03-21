#!/usr/bin/env bash

DELIMITER="|"

# Assign "eww" to "EWW_CMD" when it is not set
: "${EWW_CMD:=eww}"

declare -A HYDRA_MAIN
HYDRA_MAIN["q"]="${EWW_CMD} close-all${DELIMITER}quit"
HYDRA_MAIN["r"]="rofi -show run${DELIMITER}Run a program in Rofi"
HYDRA_MAIN["w"]="rofi -show run${DELIMITER}Switch to a window"
HYDRA_MAIN["f"]="rofi -show firefox${DELIMITER}Switch to a Firefox window using Rofi"
HYDRA_MAIN["p"]="pavucontrol${DELIMITER}Open volume mixer"
HYDRA_MAIN["s"]="flameshot gui${DELIMITER}Take a screenshot"
HYDRA_MAIN["e"]="rofi -show emoji${DELIMITER}Open emoji picker"

exec_hydra_command() {
    hydra_name=$1
    key=$2

    declare -n hydra=$hydra_name

    entry=$(hydra_entry_to_json "$key" "${hydra[$command]}")
    command=$(jq -r '.command' <<<"$entry")
    eval "$command"
}

hydra_entry_to_json() {
    key=$1
    hydra_entry=$2

    command=$(cut -f1 -d$DELIMITER <<<"$hydra_entry")
    description=$(cut -f2 -d$DELIMITER <<<"$hydra_entry")

    jq \
        -n \
        --arg key "$key" \
        --arg command "$command" \
        --arg description "$description" \
        '{ "key": $key, "command": $command, "description": $description }'
}

kill_hydra() {
    $EWW_CMD close hydra
}

case "$1" in
    "exec")
        hydra_name="$2"
        command="$3"

        declare -n hydra=$hydra_name

        exec_hydra_command "$hydra_name" "$command" &
        kill_hydra
        ;;

    "list")
        hydra_name="$2"
        declare -n hydra=$hydra_name

        json_output="[]"

        for key in "${!hydra[@]}"; do
            value="${hydra[$key]}"
            command=$(cut -f1 -d$DELIMITER <<<"$value")
            description=$(cut -f2 -d$DELIMITER <<<"$value")

            entry_json=$(hydra_entry_to_json "$key" "$value")

            json_output=$(
                jq \
                    --argjson entry "$entry_json" \
                    '. += [$entry]' <<<"$json_output"
            )
        done

        echo "$json_output"
        $EWW_CMD update hydra-options="$json_output"
        ;;
esac
