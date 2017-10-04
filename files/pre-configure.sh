#!/bin/bash
#set -xv

ES_HOME="$1"
[ -z "$ES_HOME" ] && ( echo "ERROR. Empty path passed as ES home directory" )
[ -d "$ES_HOME" ] || ( echo "ERROR. $ES_HOME is not a directory"; exit 0 )

ES_CONFIG_FILE="$ES_HOME/config/elasticsearch.yml"
[ -f "$ES_CONFIG_FILE" ] || echo "WARNING. $ES_CONFIG_FILE not found. Create new one"

# Ensure there is empty line at end of config file
env | while read env_var
do
  name=${env_var%%=*}
  value=${env_var##*=}
  if [[ $name == ES_ELASTIC_DELETE_CONFIG* ]]
  then
    # Deleting configuration based on regexp (wit sed)
    echo "Deleting configuration, lines with: \"$value\" removed from \"$ES_CONFIG_FILE\" and loaded from \"$env_var\""
    sed -ir "/${value}/d" "$ES_CONFIG_FILE"
  fi
  if [[ $name == ES_ELASTIC_CONFIG* ]]
  then
    # Adding this content to configuration.
    echo "Adding configuration: \"$value\" to \"$ES_CONFIG_FILE\" from \"$env_var\""
    # Check if we need resolve configuration with bash
    if echo "$value" | fgrep -- '$(' > /dev/null
    then
      value="$(bash -c "echo $value")"
      echo "'\$(' found on current configuration resolved to $value"
    fi
    echo "$value" >> "$ES_CONFIG_FILE"
  fi
done

echo ">>> NEW CONFIG <<<"
cat "$ES_CONFIG_FILE"
