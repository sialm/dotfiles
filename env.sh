# set AWS env vars
# export AWS_ACCESS_KEY_ID=`aws configure get DeveloperAccess.aws_access_key_id`
# export AWS_SECRET_ACCESS_KEY=`aws configure get DeveloperAccess.aws_secret_access_key`
# export aws="{'accessKeyId': '$AWS_ACCESS_KEY_ID', 'secretAccessKey': '$AWS_SECRET_ACCESS_KEY', 'region':'us-west-2'}"

# set java to java 8 
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# zsh prompt stuff
# shamelessly stolen from https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
# git on the right
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git