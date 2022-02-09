set -o errexit

TEMP_DIR="$(mktemp -d /tmp/${0##*/}.XXXXXXXXXXX)"
trap  "find $TEMP_DIR -type f -exec shred {} +  &&  rm -rf $TEMP_DIR"  EXIT

MESSAGE=$1
PUBKEY_SSH=$2
MESSAGE_ENCODED=$3
PASS_ENCODED=$4

PASS=$TEMP_DIR/pass
PUBKEY_PKCS8=$TEMP_DIR/key

openssl rand -out $PASS 32
openssl enc -aes-256-cbc -in $MESSAGE -out $MESSAGE_ENCODED -pass file:$PASS
ssh-keygen -e -f $PUBKEY_SSH -m PKCS8 > $PUBKEY_PKCS8
openssl rsautl -encrypt -oaep -pubin -inkey $PUBKEY_PKCS8 -in $PASS -out $PASS_ENCODED
