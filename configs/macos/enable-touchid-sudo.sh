#! /bin/bash
# Run this script to enable sudo with Touch ID

sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
