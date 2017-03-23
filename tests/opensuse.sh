#!/bin/sh

set -e -x

# Ensure docks are being excluded, otherwise image size is much larger

grep -q 'rpm.install.excludedocs = yes' /etc/zypp/zypp.conf
