set -o errexit

D=${0%/*}
pushd $D >> /dev/null
trap  "popd >> /dev/null"  EXIT

M=message.txt
I=id_test

P=pass

../pit-file-encrypt.sh  $M  $I.pub  $M.enc  $P.enc
echo Use \'testit\' for the pass phrase
../pit-file-decrypt.sh  $M  $I      $M.enc  $P.enc  $M.dec

diff $M $M.dec
if [ $? -eq 0 ]; then
	echo FINE
else
	echo FAIL
fi
rm $M.enc $M.dec $P.enc
