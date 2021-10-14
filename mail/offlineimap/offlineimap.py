#! /usr/bin/env python2

from subprocess import check_output

def get_passgpg(account):
    return check_output("gpg -dq ~/.local/mailKeys/" + account + ".gpg", shell=True).strip("\n")

