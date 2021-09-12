#!/usr/bin/env bash

# from https://github.com/panubo/docker-sshd

set -e

# use mkpasswd to encrypt password
# echo 'user1:$6$IOXlXvNdE5cOFQKo$BQ7X/TxQEHqyYenGV5iyLyOYqJmcZNxrvAYNkaMTLNKw/JjtGeqVXyZ0TTyez5KmH9T0Y3n3UY3qVb5RYUJDE0' | chpasswd --encrypted
echo "user1:password" | chpasswd
