load_aws_tools_linux(){
    local CURRENTDIR=$(pwd)
    cd /tmp/

  # /usr/local/bin/aws
  if test -f "/usr/local/bin/aws"; then
    echo "aws already installed, updating"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && rm -Rf ./aws && rm /tmp/awscliv2.zip

  else
    echo "installing aws"
    
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install && rm -Rf ./aws && rm /tmp/awscliv2.zip
  fi

  if which node > /dev/null
    then
        echo "node is installed"
        echo "installing aws-cdk"
        npm install -g aws-cdk
    fi

  cd $CURRENTDIR
}