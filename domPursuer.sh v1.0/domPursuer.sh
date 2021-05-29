#!/bin/bash
#==============================================================================#
#=====(___________________ domPursuer.sh 'virsion 1.0' __________________)=====#
#===                          Created by : Abdelrahman-Security159          ===#
#=     Github : https://github.com/Abdelrahman-Security159/DomainCollector    =#
#==============================================================================#

echo "[!] Get data..."
wget $1 2> /dev/null
head=$(echo $1 | cut -d '.' -f 1)
if [ $head == "www" ]
then
	echo "[-] Error with input, trying to avoid it..."
	head=$(echo $1 | cut -d '.' -f 2)
fi

if [ -f index.html ]
then
	echo "[+] Valide Site."
	echo "[!] The site is : $head"
	echo -e "[!] Extracting domains...\n"

	rm IP.txt
	touch IP.txt
	list=$(cat index.html | grep href= | cut -d '"' -f 2 | cut -d '/' -f 3 | uniq | grep $head)
	for link in $list
	do
		echo "$link"
	done
	echo -e "[+] Extracted domains.\n"
	echo -e "[!] Preparing the IPs...\n"
	IPs=''
	for domain in $list 
	do
        	IPs=$(host $domain | cut -d ' ' -f 4)
		echo $IPs >> IP.txt
	done
	IPs=$(cat IP.txt | sort | uniq)
	for ip in $IPs
	do
		echo "[+] $ip "
	done
	echo -e "\n[+] Done!"
else
	echo -e "[-] Error with input.\n"
	echo -e "try like this example : bash domTomp.sh example.com\n"
fi 
