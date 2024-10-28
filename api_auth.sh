base_url=<https://test.deribit.com>
timestamp=$( date +%s000 )
nonce=$( cat /dev/urandom | tr -dc 'a-z0-9' | head -c8 )
verb=GET
uri='/api/v2/private/get_current_deposit_address?currency=eth'
datatosign=$(mktemp)
echo -ne "${timestamp}\n${nonce}\n${verb}\n${uri}\n\n" > ${datatosign}
# client_id received when creating the API key
client_id="8oulf2Ck"
signature=$(openssl pkeyutl -sign -inkey private.pem -rawin -in ${datatosign} | base64 -w 100 | sed 's#+#-#g;s#/#_#g;s#=##g')
rm ${datatosign}

curl -s -X ${verb} -H "Authorization: DERI-HMAC-SHA256 id=${client_id},ts=${timestamp},nonce=${nonce},sig=${signature}" "${base_url}${uri}" | jq