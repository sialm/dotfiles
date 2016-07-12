if test ! $(nvm --version)
then
    echo "Installing nvm"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
fi

