#!/bin/bash
#==============================================================================#
#=====(___________________ domPursuer.sh 'virsion 2.0' __________________)=====#
#===                          Created by : 0x908127                         ===#
#=     Github : https://github.com/Abdelrahman-Security159/DomainCollector    =#
#==============================================================================#

done_domains=( "" )
get_all_domains()
{								#10
# First, get the top domain as a $1 parameter  			-> K <-
# wget the domain, filter it and stor in list			-> K <-
# check if list is embty or not					-> K <-
# if not, iterate to catch every domain as a single recursion	-> K <-
# return at the end the data in full list * list="$list $?" *	-> K <-

	# Filtring the top domain 'Start'

	if [ -f index.html ]
	then
		rm index.html
	elif [ -f wget-log ]
	then
		rm wget-log
	fi

	flag="N"						#20
	for value in "${done_domains[@]}"
	do
		if [ "$value" = $1 ]
		then
			flag="T"
			break					#30
		fi
	done

	if [ $flag = "N" ]
	then
		timeout -k 5s 3s wget $1 2> /dev/null
		local head=$2
		done_domains+=( "$1" )
		if [ -f index.html ]
		then
			list=$(cat index.html | grep href= | cut -d '"' -f 2 | cut -d '/' -f 3 | uniq | grep $head | cut -d "'" -f 1)
		else
			list=""
		fi
		
		if [ "$list" != "" ]				#40
		then
			for link in $list
			do
				ret_value=`get_all_domains $link $head`
				list="$list $ret_value"
			done
		fi
	else							#50
		flag="N"
	fi
}

# Filtring the top domain 'Start'
echo -e "[\e[33m!\e[39m] \e[96mGet data...\e[39m"

if [ -f index.html ]
then
	rm index.html
fi

site=$1

if [ `echo $1 | cut -d '.' -f 1` != "www" ]
then
	echo -e "[\e[31m-\e[39m] \e[91mError with input, trying to avoid it...\e[39m"
	site="www.$1"
fi
head=$(echo $1 | cut -d '.' -f 2)

wget $1 2> /dev/null
done_domains+=( "$site" )

if [ -f index.html ]
then
	echo -e "[\e[92m+\e[39m] \e[92mValide Site.\e[39m"
	echo -e "[\e[33m!\e[39m] \e[96mThe site is : \e[35m$site\e[39m"
	echo -e "[\e[33m!\e[39m] \e[96mExtracting domains...\e[39m\n"

	# Here ...

	full_list=""
	list=$(cat index.html | grep href= | cut -d '"' -f 2 | cut -d '/' -f 3 | uniq | grep $head | cut -d "'" -f 1)
	for link in $list
	do
		get_all_domains $link $head
		full_list="$full_list $list"
	done

	echo "${done_domains[@]}" > domains.txt
	for dom in `cat domains.txt`
	do
		echo -e "[\e[32m*\e[39m] \e[93m$dom\e[39m"
	done

	echo -e "\n[\e[92m+\e[39m] \e[92mExtracted domains.\e[39m"
	echo -e "[\e[33m!\e[39m] \e[96mPreparing the IPs...\e[39m\n"
	IPs=''
	if [ -f IP.txt ]
	then
		rm IP.txt
	else
		touch IP.txt
	fi

	for domain in `cat domains.txt`
	do
        	IPs=$(host $domain | head -n2 | tail -n1 | cut -d ' ' -f 4 )
		echo $IPs >> IP.txt
	done
	IPs=$(cat IP.txt | sort | uniq | cut -d ' ' -f 1)
	for ip in $IPs
	do
		echo -e "[\e[32m*\e[39m] \e[93m$ip\e[39m "
	done
	echo -e "\n[\e[92m+\e[39m] \e[92m Done!"
else
	echo -e "[\e[31m-\e[39m] \e[91mError with input.\e[39m"
	echo -e "try like this example : bash domTomp.sh example.com\n"
fi
