#!/bin/bash

export DISPLAY=:0.0 
/usr/bin/supervisord -c /etc/supervisord.conf
