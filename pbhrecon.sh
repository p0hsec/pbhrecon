#!/bin/bash
# author: github.com/p0hsec
# date  : 2021-09-22

banner(){
echo -e "\033[94m"
echo -e "           __    __                              "
echo -e "    ____  / /_  / /_  ________  _________  ____  "
echo -e "   / __ \/ __ \/ __ \/ ___/ _ \/ ___/ __ \/ __ \ "
echo -e "  / /_/ / /_/ / / / / /  /  __/ /__/ /_/ / / / / "
echo -e " / .___/_.___/_/ /_/_/   \___/\___/\____/_/ /_/  "
echo -e "/_/     simple automated recon - v0.1			  "
echo -e "\e[0m\n"
}

# cek folder ada atau tidak
pbhdir(){
	todate=$(date '+%Y-%m-%d %H:%M:%S')
	if [ -d "pbhrecon" ]
		then
			echo -e "[$todate] folder pbhrecon sudah ada" >> pbhrecon/.pbhrecon.log
		else
			mkdir pbhrecon
			echo -e "[$todate] folder pbhrecon berhasil dibuat" >> pbhrecon/.pbhrecon.log
	fi
}

# scan subdomain single dan multi
scansubdo(){
	if [ -f "$OPTARG" ]
		then
			echo -e "\033[94m[+]SCANNING SUBDOMAIN...\e[0m"
			subfinder -all -dL $OPTARG -silent -o subdo | httpx -silent -o subdo-live
			cat subdo | sort -u > pbhrecon/subdomain.txt
			cat subdo-live | sort -u > pbhrecon/live-subdomain.txt
			rm -rf subdo*
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Subdomain ditemukan:\e[0m $(cat pbhrecon/subdomain.txt | wc -l)"
			echo -e "\033[94m[-]Subdomain aktif:\e[0m $(cat pbhrecon/live-subdomain.txt | wc -l)"
			echo -e "\033[94m[-]Hasil scanning subdomain tersimpan di:\e[0m pbhrecon/subdomain.txt"
			echo -e "\033[94m[-]Hasil scanning subdomain yang aktif tersimpan di:\e[0m pbhrecon/live-subdomain.txt"
			echo -e "[$todate] TARGET: $OPTARG" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] subdomain ditemukan: $(cat pbhrecon/subdomain.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] subdomain aktif: $(cat pbhrecon/live-subdomain.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning subdomain tersimpan di pbhrecon/subdomain.txt" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning subdomain yang aktif tersimpan di pbhrecon/live-subdomain.txt" >> pbhrecon/.pbhrecon.log
		else
			echo -e "\033[94m[+]TARGET:\e[0m $OPTARG"
			echo -e "\033[94m[+]SCANNING SUBDOMAIN...\e[0m"
			subfinder -all -d $OPTARG -silent -o subdo | httpx -silent -o subdo-live
			cat subdo | sort -u > pbhrecon/$OPTARG.txt
			cat subdo-live | sort -u > pbhrecon/live-$OPTARG.txt
			rm -rf subdo*
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Subdomain ditemukan:\e[0m $(cat pbhrecon/$OPTARG.txt | wc -l)"
			echo -e "\033[94m[-]Subdomain aktif:\e[0m $(cat pbhrecon/live-$OPTARG.txt | wc -l)"
			echo -e "\033[94m[-]Hasil scanning subdomain tersimpan di:\e[0m pbhrecon/$OPTARG.txt"
			echo -e "\033[94m[-]Hasil scanning subdomain yang aktif tersimpan di:\e[0m pbhrecon/live-$OPTARG.txt"
			echo -e "[$todate] TARGET: $OPTARG" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] subdomain ditemukan: $(cat pbhrecon/$OPTARG.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] subdomain aktif: $(cat pbhrecon/live-$OPTARG.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning subdomain tersimpan di pbhrecon/$OPTARG.txt" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning subdomain yang aktif tersimpan di pbhrecon/live-$OPTARG.txt" >> pbhrecon/.pbhrecon.log
	fi
}

# menambahkan subdomain jika ada yang baru
renew(){
	echo -e "\033[94m[+]TARGET:\e[0m $OPTARG"
	echo -e "\033[94m[+]SCANNING SUBDOMAIN...\e[0m"
	subfinder -all -d $OPTARG -silent | anew pbhrecon/$OPTARG.txt > new
	echo -e "\033[94m[+]REPORT:\e[0m"
	echo -e "\033[94m[-]Subdomain baru ditambahkan:\e[0m $(cat new | wc -l)"
	echo -e "[$todate] TARGET: $OPTARG" >> pbhrecon/.pbhrecon.log
	echo -e "[$todate] Subdomain baru ditambahkan: $(cat new | wc -l)" >> pbhrecon/.pbhrecon.log
	rm -rf new
}

# scan vuln single dan multi
scanvuln(){
	if [ -f "$OPTARG" ]
		then
			echo -e "\033[94m[+]SCANNING VULNERABILITIES...\e[0m"
			nuclei -l $OPTARG -silent -o vuln
			cat vuln | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sort -u > pbhrecon/vuln-info.txt
			rm -rf vuln
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Hasil scanning tersimpan di:\e[0m pbhrecon/vuln-info.txt"
			echo -e "[$todate] hasil scanning tersimpan di pbhrecon/vuln-info.txt" >> pbhrecon/.pbhrecon.log
		else
			echo -e "\033[94m[+]TARGET:\e[0m $OPTARG"
			echo -e "\033[94m[+]SCANNING VULNERABILITIES...\e[0m"
			nuclei -u $OPTARG -silent -o vuln
			cat vuln | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sort -u > pbhrecon/vuln-$OPTARG.txt
			rm -rf vuln
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Hasil scanning tersimpan di:\e[0m pbhrecon/vuln-$OPTARG.txt"
			echo -e "[$todate] TARGET: $OPTARG" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning tersimpan di pbhrecon/vuln-$OPTARG.txt" >> pbhrecon/.pbhrecon.log
	fi
}

# mencari url dan param single atau multi
furl(){
	if [ -f "$OPTARG" ]
		then
			echo -e "\033[94m[+]SCANNING URLS DAN PARAMATER...\e[0m"
			cat $OPTARG | gau -t 10 -o urls
			cat urls | sort -u > pbhrecon/urls-info.txt
			cat urls | grep = | sort -u > pbhrecon/param-info.txt
			rm -rf urls
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Urls ditemukan:\e[0m $(cat pbhrecon/urls-info.txt | wc -l)"
			echo -e "\033[94m[-]Parameter ditemukan:\e[0m $(cat pbhrecon/param-info.txt | wc -l)"
			echo -e "\033[94m[-]Hasil scanning url tersimpan di:\e[0m pbhrecon/urls-info.txt"
			echo -e "\033[94m[-]Hasil scanning parameter tersimpan di:\e[0m pbhrecon/param-info.txt"
			echo -e "[$todate] urls ditemukan: $(cat pbhrecon/urls-info.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] parameter ditemukan: $(cat pbhrecon/param-info.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning url tersimpan di pbhrecon/urls-info.txt" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning parameter tersimpan di pbhrecon/param-info.txt" >> pbhrecon/.pbhrecon.log
		else
			echo -e "\033[94m[+]TARGET:\e[0m $OPTARG"
			echo -e "\033[94m[+]SCANNING URLS DAN PARAMATER...\e[0m"
			gau $OPTARG -t 10 -o urls
			cat urls | sort -u > pbhrecon/urls-$OPTARG.txt
			cat urls | grep = | sort -u > pbhrecon/param-$OPTARG.txt
			rm -rf urls
			echo -e "\033[94m[+]REPORT:\e[0m"
			echo -e "\033[94m[-]Urls ditemukan:\e[0m $(cat pbhrecon/urls-$OPTARG.txt | wc -l)"
			echo -e "\033[94m[-]Parameter ditemukan:\e[0m $(cat pbhrecon/param-$OPTARG.txt | wc -l)"
			echo -e "\033[94m[-]Hasil scanning url tersimpan di:\e[0m pbhrecon/urls-$OPTARG.txt"
			echo -e "\033[94m[-]Hasil scanning parameter tersimpan di:\e[0m pbhrecon/param-$OPTARG.txt"
			echo -e "[$todate] TARGET: $OPTARG" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] urls ditemukan: $(cat pbhrecon/urls-$OPTARG.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] parameter ditemukan: $(cat pbhrecon/param-$OPTARG.txt | wc -l)" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning url tersimpan di pbhrecon/urls-$OPTARG.txt" >> pbhrecon/.pbhrecon.log
			echo -e "[$todate] hasil scanning parameter tersimpan di pbhrecon/param-$OPTARG.txt" >> pbhrecon/.pbhrecon.log
	fi
}

# scan mode auto
if [[ $1 == "-auto" && -n "$2" ]]
	then
		pbhdir
		banner
		echo -e "\e[31m[!]AUTO MODE ON!\e[0m"
		echo -e "\e[31m[!]PROSES AKAN MEMAKAN WAKTU LAMA!\e[0m"
		echo -e "\033[94m[+]TARGET:\e[0m $2"
		#scansubdo
		echo -e "\033[94m[+]SCANNING SUBDOMAIN...\e[0m"
		subfinder -all -d $2 -silent -o subdo | httpx -silent -o subdo-live
		cat subdo | sort -u > pbhrecon/$2.txt
		cat subdo-live | sort -u > pbhrecon/live-$2.txt
		rm -rf subdo*
		#scanvuln
		echo -e "\033[94m[+]SCANNING VULNERABILITIES...\e[0m"
		nuclei -l pbhrecon/live-$2.txt -silent -o vuln
		cat vuln | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sed 's/^[^[:space:]]*[[:space:]]\{1,\}//' | sort -u > pbhrecon/vuln-info.txt
		rm -rf vuln
		#furl
		echo -e "\033[94m[+]SCANNING URLS DAN PARAMATER...\e[0m"
		cat pbhrecon/live-$2.txt | gau -t 5 -o urls
		cat urls | sort -u > pbhrecon/urls-info.txt
		cat urls | grep = | sort -u > pbhrecon/param-info.txt
		rm -rf urls
		#output
		echo -e "\033[94m[+]REPORT:\e[0m"
		echo -e "\033[94m[-]Subdomain ditemukan:\e[0m $(cat pbhrecon/$2.txt | wc -l)"
		echo -e "\033[94m[-]Subdomain aktif:\e[0m $(cat pbhrecon/live-$2.txt | wc -l)"
		echo -e "\033[94m[-]Urls ditemukan:\e[0m $(cat pbhrecon/urls-info.txt | wc -l)"
		echo -e "\033[94m[-]Parameter ditemukan:\e[0m $(cat pbhrecon/param-info.txt | wc -l)"
		echo -e "\033[94m[-]Hasil scanning subdomain tersimpan di:\e[0m pbhrecon/$2.txt"
		echo -e "\033[94m[-]Hasil scanning subdomain yang aktif tersimpan di:\e[0m pbhrecon/live-$2.txt"
		echo -e "\033[94m[-]Hasil scanning vulnerabilities tersimpan di:\e[0m pbhrecon/vuln-info.txt"
		echo -e "\033[94m[-]Hasil scanning url tersimpan di:\e[0m pbhrecon/urls-info.txt"
		echo -e "\033[94m[-]Hasil scanning parameter tersimpan di:\e[0m pbhrecon/param-info.txt"
		#logger
		echo -e "[$todate] TARGET: $2" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] subdomain ditemukan: $(cat pbhrecon/$2.txt | wc -l)" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] subdomain aktif: $(cat pbhrecon/live-$2.txt | wc -l)" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] urls ditemukan: $(cat pbhrecon/urls-info.txt | wc -l)" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] parameter ditemukan: $(cat pbhrecon/param-info.txt | wc -l)" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] hasil scanning subdomain tersimpan di pbhrecon/$2.txt" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] hasil scanning subdomain yang aktif tersimpan di pbhrecon/live-$2.txt" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] hasil scanning tersimpan di pbhrecon/vuln-info.txt" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] hasil scanning url tersimpan di pbhrecon/urls-info.txt" >> pbhrecon/.pbhrecon.log
		echo -e "[$todate] hasil scanning parameter tersimpan di pbhrecon/param-info.txt" >> pbhrecon/.pbhrecon.log
		echo -e "\033[94m[+]SCANNING SELESAI!\e[0m"
		exit 0
fi

usage(){
cat << EOF
Usage of pbhrecon:
	-d string, file
		melakukan scan subdomain dan live host pada target
	-n string, file
		menambahkan subdomain jika ada yang baru
	-a string, file
		melakukan scan vulnerabilities pada target
	-l file
		melakukan scan url dan parameter pada target
	-auto string
		melakukan semua scan secara otomatis
EOF
}

while getopts “:hd:n:a:l:” OPTION
do
	case $OPTION in
		h)
			usage
			exit 0
			;;
		d)
			pbhdir
			banner
			domain=$OPTARG
			scansubdo
			;;
		n)
			banner
			domain=$OPTARG
			renew
			;;
		a)
			pbhdir
			banner
			domain=$OPTARG
			scanvuln
			;;
		l)
			pbhdir
			banner
			domain=$OPTARG
			furl
			;;
		?)
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND -1))