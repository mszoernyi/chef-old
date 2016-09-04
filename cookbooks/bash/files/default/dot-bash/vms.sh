if [[ -r "${HOME}/.rvm/scripts/rvm" ]]; then
	__print_status "setup ruby version manager"
	export rvm_silence_path_mismatch_check_flag=1
	source "${HOME}/.rvm/scripts/rvm"
fi

# also load virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

if [[ -r /usr/bin/virtualenvwrapper.sh ]]; then
	__print_status "setup python virtualenv"
	source /usr/bin/virtualenvwrapper.sh
elif [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
	__print_status "setup python virtualenv"
	export PYTHONPATH=/usr/local/lib/python2.7/site-packages
	source /usr/local/bin/virtualenvwrapper.sh
fi

# and NVM
export NVM_DIR="${HOME}/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
	__print_status "setup node version manager"
	source "$NVM_DIR/nvm.sh"
fi

# set proper Go path
export GOPATH="${HOME}/.go"
export PATH="${HOME}/.go/bin:${PATH}"
