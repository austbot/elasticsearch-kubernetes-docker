#!/bin/bash

# Generate self-signed certificates based on ENVIRONMENT VARS

if [ -n "${CREATECERTS_SELF_SIGNED_CAKEY_FILE}" -a -n "${CREATECERTS_SELF_SIGNED_CACERT_FILE}" ]
then
  ES_HOME="$1"
  [ -z "$ES_HOME" ] && ( echo "ERROR. Empty path passed as ES home directory" )
  [ -d "$ES_HOME" ] || ( echo "ERROR. $ES_HOME is not a directory"; exit 0 )

  # Create temp path
  TMPDIR=$(mktemp -d)

  # Resolve what is my ip
  MYIP=$(ip addr show eth0 | fgrep inet | egrep -oe '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

  # Create yaml
  cat > $TMPDIR/instances.yml << EOF
  instances:
    - name: "$HOSTNAME"
      ip:
      - ${MYIP}
      dns:
      - ${HOSTNAME}
EOF

  # Add other dns
  if [ -n "${CREATECERTS_SELF_SIGNED_DNS_CSV}" ]
  then
    IFSOLD="$IFS"
    IFS=","
    for dns in ${CREATECERTS_SELF_SIGNED_DNS_CSV}
    do
      echo "      - $dns" >> /$TMPDIR/instances.yml
    done
    IFS="$IFSOLD"
  fi

  echo ">>> Creating certificates with configuration <<<"
  cat "$TMPDIR/instances.yml"

  NODE_NAME="${NODE_NAME:-$(uuidgen)}"
  export NODE_NAME

  # Generating certs
  ${ES_HOME}/bin/x-pack/certgen \
    -s \
    --key "${CREATECERTS_SELF_SIGNED_CAKEY_FILE}" \
    --cert "${CREATECERTS_SELF_SIGNED_CACERT_FILE}" \
    --in "$TMPDIR/instances.yml" \
    --out "$TMPDIR/certs.zip"

  # Extracting certs
  mkdir -p "${ES_HOME}/config/certificates-created"
  unzip -q "$TMPDIR/certs.zip" -d "$TMPDIR" && rm -f $TMPDIR/certs.zip
  find "$TMPDIR" -type f -exec cp -f {} "${ES_HOME}/config/certificates-created" \;

  echo ">>> Certificates created <<<"
  find ${ES_HOME}/config/certificates-created -type f 

  # Deleting temp
  rm -fr "$TMPDIR"
fi
