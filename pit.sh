set -o errexit

M=message.txt
I=$HOME/.ssh/id_test

P=pass
openssl rand -out $P 32
openssl aes-256-cbc -in $M -out $M.enc -pass file:$P
openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f $I.pub -m PKCS8) -in $P -out $P.enc
shred -u $P
openssl rsautl -decrypt -oaep -inkey $I -in $P.enc -out $P
openssl aes-256-cbc -d -in $M.enc -out $M.dec -pass file:$P
shred -u $P
diff $M $M.dec
if [ $? -eq 0 ]; then
	echo FINE
else
	echo FAIL
fi
rm $M.enc $M.dec $P.enc
