brew update 
brew upgrade



exit 

# php 7.2
# brew unlink php71
brew install php72

# java 8
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
brew cask install adoptopenjdk/openjdk/adoptopenjdk8-jre

# gradle 
brew install gradle

# maven 
brew install maven 

#python 
brew install pip2
brew install pip3
pip3 install jupyter

# git 
brew install git 

# go 
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
brew install go
go get golang.org/x/tools/cmd/godoc

# nvm 

# ruby 
brew update
brew install rbenv ruby-build
eval "$(rbenv init -)"

#forge 
#install deps 
gem install librarian-puppet
gem install puppet
# docker 
brew install docker 
brew install docker-compose 
brew install docker-machine 
brew install xhyve
brew install docker-machine-driver-xhyve
# optctl https://opctl.io/docs/setup.html
curl -L https://github.com/opctl/opctl/releases/download/0.1.25/opctl0.1.25.darwin.tgz | tar -xzv -C /usr/local/bin
# get forge cli https://github.com/Remitly/forge/blob/master/doc/cli.md

# vagrant 
brew cask install virtualbox
brew cask install vagrant
brew cask install vagrant-manager

# CLI tools
brew install jq
# bash stuff [find, locate]
brew install findutils 


