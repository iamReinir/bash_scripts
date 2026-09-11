#!/bin/bash

NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
sudo ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off

KONG=100.105.95.7
SERVER1=100.87.230.49
SERVER2=100.127.67.28
THIS=172.26.10.168
TTS_ADMIN=202.143.111.173

# iptables -t nat -A  PREROUTING -d 172.31.8.251 -j DNAT --to-destination 100.87.230.49
# iptables -t nat -A PREROUTING -d 172.31.8.251 -p tcp -m multiport ! --dport 25565,8000 -j DNAT --to-destination 100.87.230.49
# iptables -t nat -A POSTROUTING -d 100.87.230.49 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 100.87.230.49 -j SNAT --to-source 172.31.8.251

# Rules for routing to Kong's machine

# New rule for port 25565 traffic
# iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 25565 -j DNAT --to-destination $KONG
# iptables -t nat -A POSTROUTING -d $KONG -p tcp --dport 25565 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s $KONG -p tcp --sport 25565 -j SNAT --to-source $THIS

# New rule for port 8000 traffic
# iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 8000 -j DNAT --to-destination $KONG
# iptables -t nat -A POSTROUTING -d $KONG -p tcp --dport 8000 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s $KONG -p tcp --sport 8000 -j SNAT --to-source $THIS

# Rules for server1 routing

# ssh
echo "ssh"
iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 22 -j DNAT --to-destination $SERVER1
iptables -t nat -A POSTROUTING -d $SERVER1 -p tcp --dport 22 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $SERVER1 -p tcp --sport 22 -j SNAT --to-source $THIS

# https
echo "443"
iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 443 -j DNAT --to-destination $SERVER1:22
# iptables -t nat -A POSTROUTING -d $SERVER1 -p tcp --dport 443 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s $SERVER1 -p tcp --sport 443 -j SNAT --to-source $THIS

# http
echo "80"
iptables -t nat -A PREROUTING -d $THIS -p tcp -dport 80 -j DNAT --to-destination $SERVER1
iptables -t nat -A POSTROUTING -d $SERVER1 -p tcp --dport 80 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $SERVER1 -p tcp --sport 80 -j SNAT --to-source $THIS

# postgresql
# iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 5432 -j DNAT --to-destination $TTS_ADMIN
# iptables -t nat -A POSTROUTING -d $TTS_ADMIN -p tcp --dport 5432 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s $TTS_ADMIN -p tcp --sport 5432 -j SNAT --to-source $THIS

# rabbitmq
# iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 5672 -j DNAT --to-destination $SERVER1
# iptables -t nat -A POSTROUTING -d $SERVER1 -p tcp --dport 5672 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s $SERVER1 -p tcp --sport 5672 -j SNAT --to-source $THIS

# resvered
echo "MC"
iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 25565 -j DNAT --to-destination $SERVER2
iptables -t nat -A POSTROUTING -d $SERVER2 -p tcp --dport 25565 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $SERVER2 -p tcp --sport 25565 -j SNAT --to-source $THIS
 
# resvere
echo "8000"
iptables -t nat -A PREROUTING -d $THIS -p tcp --dport 8000 -j DNAT --to-destination $SERVER1
iptables -t nat -A POSTROUTING -d $SERVER1 -p tcp --dport 8000 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $SERVER1 -p tcp --sport 8000 -j SNAT --to-source $THIS

# hytale
echo "5520"
iptables -t nat -A PREROUTING -d $THIS -p udp --dport 5520 -j DNAT --to-destination $SERVER1
iptables -t nat -A POSTROUTING -d $SERVER1 -p udp --dport 5520 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $SERVER1 -p udp --sport 5520 -j SNAT --to-source $THIS
