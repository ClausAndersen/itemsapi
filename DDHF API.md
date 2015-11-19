Overview
========
1) Setup VM environment or host (ie. VMware Player)
2) Install OS - we use FreeBSD
3) Install PostgreSQL
4) Install OpenResty
5) Setup API
6) Relax, have coffee...

VM Environment
==============
You can either use a physical host or any virtualization technology you choose.
This guide was written using VMware Workstaion on Windows. A free version can be downloaded here:
https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/12_0

When you have VMware running you very simply set up a guest using these steps:

- Click "Create a New Virtual Machine"
- Select "Installer disc image file (.iso):"
- Locate your ISO file
- Name your virtual machine (ie. "DDHF API Test (Grommit)")
- Accept default disk settings
- Accept default hardware settings and click "Finish"

IMPORTANT NOTE: You release the mouse from the VM by clicking "CTRL+ALT"

Install OS
==========
My preferred operating system for server use is FreeBSD. This is the OS we are using for production. If you prefer you can use any other Unix-like OS as PostgreSQL and OpenResty runs well on these. So if you already have a Linux host running you can use this freely for development.

ftp://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/10.2/FreeBSD-10.2-RELEASE-amd64-disc1.iso

We assume that you have downloaded this file and have just finished creating a virtual machine. We will now process by setting up FreeBSD.

- Let the autoboot sequence lead you into the installer
- Select "InstalL"
- Select your preferred keymap "Danish ISO-8859-1 (accent keys)"
- Enter a hostname (ie. "grommit")
- Accept default selection in "Distribution Select"
- Choose "Auto (UFS) in "Partitioning"
- Choose "Entire Disk" in next step of "Partitioning"
- Choose "GPT" (default) in "Partition Scheme"
- Click "Finish" in the "Partition Editor"
- Then click "Commit" for the "Confirmation"
- Follow the wizard and accept the default or customize as needed
- When asked if you want to add users - then choose "yes"
- In this example we create the unpriviledged user "wallace"
- "Invite" this user to the group "wheel" - the rest is default
- Select "Exit" in "Final Configuration". You have completed the setup.
- Reboot into the newly setup system

## Basic configuration
We will now get some basic stuff up and running on FreeBSD. Remember to never ever log in as "root". Always log in as a regular user and the "su" - or even better "sudo" when you need executive priviledge.
Use the "ifconfig" command to find your IP address. You can use this address to log in using SSH (using ie. Putty on Windows). This is much easier than using the console but outside the scope of this guide.

Login as "wallace"

    $ su -
    # pkg install -y sudo
    # sed -I .bak 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /usr/local/etc/sudoers
    # exit

FreeBSD Hints
=============
You can install additional pacakages using "pkg install". For a beginner it might be easier to lookup the package names on http://www.freshports.org/

The system ships with the (for the uninitiated quite scary) vi editor. If you want the improved vi then install the package "vim".
The system also ships with a beginner friendly editor named "ee"


Install PostgreSQL
==================
Login as "wallace"

    $ su -
    # pkg install -y postgresql94-server postgresql94-client postgresql94-contrib postgresql94-docs
    # sysrc postgresql_enable=YES
    # /usr/local/etc/rc.d/postgresql initdb
    # service postgresql start

For production only "postgresql94-server" is needed. The additional pacakges are however nice during development.

Data for the database will be placed in `/usr/local/pgsql/data`

Interesting config files are `/usr/local/pgsql/postgresql.conf` and `/usr/local/pgsql/pg_hba.conf`

### Working with PostgreSQL

The database is running as a unpriviledged user named "pgsql". When we want to work with the database from the commandline we switch to that user context.

First we verify the database is running. You should still be at the root prompt:
    # su pgsql
    $ psql -l

This should connect to the database and list the current avaiable databases. Whenever we interact with the database from the commandline remember to do this from the context of the "pgsql" user. You jump to that user via the root user.

HINT: If using sudo you can connect using sudo:

    $ sudo -u pgsql psql template1

Quit using `\q` - help using `\?`

Install Openresty
=================
OpenResty is the webserver "nginx" bundled with some rather nice components - see http://openresty.org/

Login as "wallace"

	$ sudo pkg install -y gmake openssl pcre perl5
    $ cd ~
    $ fetch --no-verify-peer https://openresty.org/download/ngx_openresty-1.7.10.2.tar.gz
    $ tar xzvf ngx_openresty-1.7.10.2.tar.gz
    $ cd ngx_openresty-1.7.10.2
    $ ./configure --with-pcre-jit --with-http_postgres_module --with-ipv6
	$ gmake
    $ sudo gmake install

Setup API
=========

If this fails for you - then verify your installation by doing the "Hello World" example on the OpenResty website.


### Create database

First we create a new database user and database using the supplied `itemdb.sql` script.

Transfer the file using SFTP or simply edit the file using `ee`. 

Execute the script using the command:

    sudo psql -U pgsql template1 -f itemdb.sql


### Setup webserver

Login as "wallace"

    $ mkdir ~/ddhfapi
    $ cd ~/ddhfapi
    $ mkdir logs/ conf/
    $ ee conf/nginx.conf
    (paste content into file - or transfer it via SFTP)
    $ /usr/local/openresty/nginx/sbin/nginx -p ~/ddhfapi/ -c conf/nginx.conf

You should now have a running webserver on port 8080. Try to access it from your client machine

Testing from the commandline is also available:

    $ fetch -o - http://localhost:8080/

You can stop the web server using:

    $ /usr/local/openresty/nginx/sbin/nginx -p ~/ddhfapi/ -c conf/nginx.conf -s stop

TODO
====
- rc.conf modifications to start nginx as a service
- Install httpie and add examples for testing
- Add postnummer table and FK
- Add image uploading (table and FK)
- Add audio uploading (table and FK)