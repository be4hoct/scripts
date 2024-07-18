#!/bin/bash
## This script checks the NS, A, PTR, MX, SPF, DMARC and DKIM records of a domain.
## Written by Todor Pehlivanov, 2016

## Let's add some pretty colors
lgreen='\033[1;32m'
red='\033[0;31m'
nc='\033[0m' # <-- No color
## End of pretty colors declarations

## Let's show basic usage info
if [ -z "$1" ]; then
  echo -e "\nUsage: dns_chk.sh $lgreen domain.com $nc\n"
  exit 1
fi
## End of basic usage info

## Let's declare the variables:

expiration=$(whois $1 | grep 'Registry Expiry Date' | awk '{print $4}'| awk -FT '{print $1}')
ip=$(dig A $1 +short)
ptr=$(dig -x $ip +short)
ns=$(dig NS $1 +short)
mx2=$(dig MX $1 +short)
spf=$(dig TXT $1 +short)
mx=$(dig MX $1 +short)
dmarc=$(dig TXT _dmarc.$1 +short)
arr=( $mx )
# End of variables declarations

# The MX checking function:
mx_check () {
	for ((i=1; i<${#arr[@]}; i+=2));
	 do 
	  echo -e $lgreen ${arr[i]} $nc;
	done
}
## End of the MX checking function

## This is where the script starts:
echo 
echo -e 'Domain:' $lgreen $1 $nc
echo -e 'Expires:' $lgreen $expiration $nc
echo -e 'IP:' $lgreen $ip $nc
echo -e 'PTR:' $lgreen $ptr $nc
echo -e 'NS:' $lgreen ${ns[0]}
echo -e '    ' ${ns[1]} $nc 
echo 'MX:'
mx_check
echo -e 'SPF:' $lgreen $spf $nc
echo -e 'DMARC:' $lgreen $dmarc $nc
echo 'DKIM:'
dkim1=$( dig +trace +short dkim._domainkey.$1 TXT | grep 'v=DKIM1' )
dkim2=$( dig +short default._domainkey.$1 TXT | grep 'v=DKIM1' )
dkim3=$( dig +trace +short default._domainkey.pas.$1 TXT | grep 'v=DKIM1' )
dkim4=$( dig +trace +short default._domainkey.smtp.$1 TXT | grep 'v=DKIM1' )

	if [[ -z $dkim1 ]] && [[ -z $dkim2 ]] && [[ -z $dkim3 ]] && [[ -z $dkim4 ]]; then 
	echo -e "$red !!!No DKIMs!!! $nc found for $1"

	else
	 echo -e - dkim._domainkey: $lgreen ${dkim1[@]} $nc
	 echo -e - default._domainkey: $lgreen ${dkim2[@]} $nc
	 echo -e - default._domainkey.pas: $lgreen ${dkim3[@]} $nc
	 echo -e - default._domainkey.smtp: $lgreen ${dkim4[@]} $nc
	fi
## This is where the script ends.
