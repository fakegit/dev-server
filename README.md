# server-init

A simple script to get my dev server up and running, cfengine, puppet and chef
are all too complex for my needs and require me to install packages that I won't
later use. This is as minimal as it gets.


## What I need this script to do...

A list of the steps I need my script to walk through for a working server, this
is more for my guidance than yours I suspect.

### Step 1: Install applications

Actual installed apps:

 * fail2ban
 * vim
 * tmux
 * nginx
 * lftp
 * git
 * virtualenv

Build deps for virtualenv apps:

 * python-imaging

### Step 2: Setup a user

 * Home dir
 * Dot files
 * Public key
 * Sudo access

Note: Dot files requires I git pull my files and then run bootstrap.sh, I want
the dot files to be pulled into ~/code/isaac/dot-files

### Step 3: Disable root

 * Delete root password

### Step 4: Lock down SSH

 * No root login
 * Require public key authentication

### Step 5: Enable firewall

 * Port 80
 * Port 22

### Step 6: Setup nginx for dev

 * Basic conf to point all traffic to 8000

### Step 7: Enable auto-updating of everything
