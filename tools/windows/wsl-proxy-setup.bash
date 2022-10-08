#!/bin/bash

WINIP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
sed -i '/\[ProxyList\]/,$d' ~/.config/proxychains.conf
echo -e "[ProxyList]\nsocks5 $WINIP 10810" >> ~/.config/proxychains.conf
