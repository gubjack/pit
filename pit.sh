set -o errexit

M=message.txt
I=$HOME/.ssh/id_test

P=pass

./pit-file-encrypt.sh  $M  $I.pub  $M.enc  $P.enc
./pit-file-decrypt.sh  $M  $I      $M.enc  $P.enc  $M.dec

diff $M $M.dec
if [ $? -eq 0 ]; then
	echo FINE
else
	echo FAIL
fi
rm $M.enc $M.dec $P.enc
