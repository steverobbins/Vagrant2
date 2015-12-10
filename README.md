Vagrant Box 2
===

* IP Address: 192.168.50.102
* Hostname:   192.168.50.102.xip.io

This box uses rewrites to dynamically serve the document root.  I.e:

* foo.192.168.50.102.xip.io -> /var/www/html/foo
* bar.192.168.50.102.xip.io -> /var/www/html/bar

etc.  No additional configurations or service restarts needed.

# What you get

* Ubuntu 14.04.2
* Nginx 1.4.6
* MySQL 5.6.19
* PHP 7.0.0
* Redis 2.4.10

# Installation

```
mkdir ~/Project
git clone https://github.com/steverobbins/Vagrant2.git ~/Project/Vagrant2
cd ~/Project/Vagrant2
vagrant up
```