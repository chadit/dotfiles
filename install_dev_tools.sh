# this evenually will be used to install/update all development tools used

#sudo apt install -y npm

#sudo chmod 777 /usr/local/lib
#npm install -g grunt-cli



#Ansible 
pip install git+https://github.com/ansible/ansible.git@devel --upgrade
#or 
sudo -H pip install git+https://github.com/ansible/ansible.git@devel --upgrade

#Ansible python libraries 
#used for connecting to AWS
pip install boto boto3
#AWS cli
pip install awscli --upgrade