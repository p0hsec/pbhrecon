#!/bin/bash
# author: github.com/p0hsec
# date  : 2021-09-23

# update dan upgrade
echo -e "\033[94mUpdate semua Packages...\e[0m";
sudo apt update -y && sudo apt full-upgrade -y
echo -e "\033[94mDone!";
sleep 1.5

# install go
if [[ -z "$GOPATH" ]]
        then
                echo -e "\033[94mInstalling go...\e[0m"
                wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
                sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
                mkdir ~/go
                export GOROOT=/usr/local/go
		export GOPATH=$HOME/go
		export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
		echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
		echo 'export GOPATH=$HOME/go' >> ~/.bash_profile
		echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile
		source ~/.bash_profile
                echo -e "\033[94mDone!"
		sleep 1.5
		break
        else
                echo -e "\033[94mGo\e[0m sudah terinstall"
fi

# install subfinder
if [ ! -f $HOME/go/bin/subfinder ]
        then
                echo -e "\033[94mInstalling subfinder...\e[0m"
                GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
                echo -e "\033[94mDone!"
        else
                echo -e "\033[94mSubfinder\e[0m sudah terinstall"
fi

# install httpx
if [ ! -f $HOME/go/bin/httpx ]
        then
                echo -e "\033[94mInstalling httpx...\e[0m"
                GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx
                echo -e "\033[94mDone!"
        else
                echo -e "\033[94mHttpx\e[0m sudah terinstall"
fi

# install nuclei
if [ ! -f $HOME/go/bin/nuclei ]
        then
                echo -e "\033[94mInstalling nuclei...\e[0m"
                GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
                echo -e "\033[94mDone!"
        else
                echo -e "\033[94mNuclei\e[0m sudah terinstall"
fi

# install gau
if [ ! -f $HOME/go/bin/gau ]
        then
                echo -e "\033[94mInstalling gau...\e[0m"
                GO111MODULE=on go get -u -v github.com/lc/gau
                echo -e "\033[94mDone!"
        else
                echo -e "\033[94mGau\e[0m sudah terinstall"
fi

# install anew
if [ ! -f $HOME/go/bin/anew ]
        then
                echo -e "\033[94mInstalling anew...\e[0m"
                go get -u github.com/tomnomnom/anew
                echo -e "\033[94mDone!"
        else
                echo -e "\033[94mAnew\e[0m sudah terinstall"
fi

# pindah ke bin
if [ ! -f /usr/local/bin/pbhrecon ]
        then
                echo -e "\033[94mInstalling pbhrecon...\e[0m"
                sudo chmod 755 pbhrecon.sh && sudo cp pbhrecon.sh /usr/local/bin/pbhrecon
        else
                echo -e "\033[94mPbhrecon\e[0m sudah terinstall"
fi

echo -e "\033[94mDone!"
