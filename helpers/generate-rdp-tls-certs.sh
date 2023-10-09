#! /bin/sh
set -e

# Make the keys dir
KEYS_DIR=~/.config/gnome-remote-desktop/keys
mkdir -p $KEYS_DIR

# Generate keys
openssl genrsa -out $KEYS_DIR/tls.key 4096
openssl req -new -key $KEYS_DIR/tls.key -out $KEYS_DIR/tls.csr
openssl x509 -req -days 36500 -signkey $KEYS_DIR/tls.key -in $KEYS_DIR/tls.csr -out $KEYS_DIR/tls.crt
