#!/bin/bash

cd /root/.ssh
chmod go-rxw *

/etc/init.d/ssh start
sleep infinity
exit 0

