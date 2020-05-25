#!/bin/sh
set -eu

# This script is meant for quick & easy install via:
#   $ sh -c "$(curl -sSL https://get.contyn.sh/)"
#
# If Ansible step fails with ascii decore error, ensure you have a locale properly set on
# your system e.g apt-get install -y locales locales-all
export LANG="en_US.UTF-8"
ansible_version="${ANSIBLE_VERSION-2.8.2}"
installer_path="/contyn-dev"
ansible_bin_path="$HOME/.local/bin"



get_ansible_installer() {
    apt install -yqq git
    git clone $installer_git_url $installer_path
}

install_ansible() {
    echo "Installing ansible dependencies..."
    apt install -yqq curl git python3-pip python3-apt sudo locales locales-all

    echo "Installing Ansible..."
    pip3 install --user ansible=="$ansible_version"

    echo 'export PATH=$PATH:'$ansible_bin_path >> $HOME/.bashrc
    source $HOME/.bashrc
}

run_playbook() {
    
    playbook_command="$ansible_bin_path/ansible-playbook  -i $ansible_conf_path/inventory.ini $ansible_conf_path/$1"
    if [ "$is_dry_run" = "true" ]; then
        playbook_command="$playbook_command --check"
        echo "Dry running playbook (no changes applied) because DRY_RUN=true"
        return 0
    fi

    echo "Applying playbook with:"
    echo "  $playbook_command"
    $playbook_command
}

do_install() {
    install_ansible
}

# wrapped up in a function so that we have some protection against only getting
# half the file during "curl | sh"
do_install
