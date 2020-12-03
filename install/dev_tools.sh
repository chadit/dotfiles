# this eventually will be used to install/update all development tools used

# Shougo/deoplete.nvim requirement
pip3 install --user pynvim
# or
pip3 install --user --upgrade pynvim

# Ansible 
pip install git+https://github.com/ansible/ansible.git@devel --upgrade
#or 
sudo -H pip install git+https://github.com/ansible/ansible.git@devel --upgrade

# Ansible python libraries used for connecting to AWS
pip install boto boto3
# AWS CLI
pip install awscli --upgrade
# Rust
rustup toolchain add nightly
cargo +nightly install racer

