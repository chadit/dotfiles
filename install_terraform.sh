cd /home/chadit/Downloads


TERRAVER=0.7.6

#https://releases.hashicorp.com/terraform/0.7.5/terraform_0.7.5_linux_amd64.zip
sudo wget https://releases.hashicorp.com/terraform/${TERRAVER}/terraform_${TERRAVER}_linux_amd64.zip


sudo unzip -d /usr/local/bin/ "terraform_${TERRAVER}_linux_amd64.zip"


# remove tar.gz
sudo rm -rf terraform*

