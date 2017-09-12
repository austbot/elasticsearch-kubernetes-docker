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
  if [[ $name == ES_ELASTIC_CONFIG* ]]
  then
    # Adding this content to configuration.
    echo "Adding configuration: \"$value\" to \"$ES_CONFIG_FILE\" from \"$env_var\""
    echo "$value" >> "$ES_CONFIG_FILE"
  fi
done

echo ">>> NEW CONFIG <<<"
cat "$ES_CONFIG_FILE"
