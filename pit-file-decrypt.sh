set -o errexit

TEMP_DIR="$(mktemp -d /tmp/${0##*/}.XXXXXXXXXXX)"
trap  "find $TEMP_DIR -type f -exec shred {} +  &&  rm -rf $TEMP_DIR"  EXIT

MESSAGE=$1
PRIVATEKEY_SSH=$2
MESSAGE_ENCODED=$3
PASS_ENCODED=$4
MESSAGE_DECODED=$5

PASS=$TEMP_DIR/pass

openssl rsautl -decrypt -oaep -inkey $PRIVATEKEY_SSH -in $PASS_ENCODED -out $PASS
openssl aes-256-cbc -d -in $MESSAGE_ENCODED -out $MESSAGE_DECODED -pass file:$PASS
