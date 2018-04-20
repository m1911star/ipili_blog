#!/bin/sh
rsync -rvz -e 'ssh -p 29765' --progress -a ./public root@65.49.199.220:/var/www/blog/html
