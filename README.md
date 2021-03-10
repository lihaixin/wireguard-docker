# 利用wireguard打造加速游戏路由器

## 一、为什么要用游戏加速路由器

外面很多针对于国内游戏玩家，海外游戏玩家等游戏加速产品，都是在客户端配置，也就是在我们PC端安装一个程序，对于个人玩家基本满足，因为个人玩家对网络要求不高，而对于游戏专业玩家、游戏工作室来讲，可能效率就低了，也不稳定，下面这个项目是已经被多家游戏工作室验证，效果非常不错，价值$5000元，现在分享出来

环境假设：

- 本地用户网段：192.168.2.0/24
- openwrt加速路由器IP：192.168.2.201
- 海外服务器IP：112.112.112.112

分三部分内容：

1. 服务器端配置
2. openwrt加速路由器配置
3. 线路调优
4. PC端配置

**最终的效果：低延迟、0丢包率**

下面是详细配置：

## 二、服务器端配置

使用docker部署，方便又利于管理，需要使用`net=host` 网络才能更好

```bash
docker pull lihaixin/wireguard:stretch
docker stop wg0 && docker rm wg0
docker run -d \
   --name wg2 \
   -e SERVER_PORT=80 -e LANRANGE=192.168.2.0/24 \
   -e FEC_OPTIONS="2:2" \
   -e TIMEOUT=1 \
   -e WGNAME=wg2 \
   -e UDPMTU=1360 \
   -e mtu=1300 \
   -e WANNAME=ens5  \
   -e WGCLIENTIP=10.1.2.2/32 -e WGSERVERIP=10.1.2.1/32 -e WGRANGE=10.1.2.0/24 \
   --cap-add net_admin --cap-add sys_module \
   --restart=always  --net=host --privileged  \
   lihaixin/wireguard:stretch
```

## 三、openwrt端

第一步：添加服务器ip到静态路由

```bash
sleep 15
wgserverip=112.112.112.112
GATEWAY=`uci get network.lan.gateway`
ip route add $wgserverip via $GATEWAY dev br-lan proto static
```

第二步：添加udptools,配置开机启动

```bash

wgserverip=112.112.112.112
wgserverport=80
uci set udptools.@udpconfig[0].server=$wgserverip
uci set udptools.@udpconfig[0].serverport=$wgserverport
uci set udptools.@udpconfig[0].clientport=$wgserverport
uci set udptools.@udpconfig[0].enable='1'
uci commit
/etc/init.d/udptools start
/etc/init.d/udptools enable
```

第三步：删除防火墙

```bash
uci delete firewall.@zone[1]
uci delete firewall.@zone[0]
uci set firewall.@defaults[0].forward='ACCEPT'
uci commit
/etc/init.d/firewall restart
```

第四步：添加wg接口

图形操作，请查阅视频演示

第五步：添加sqm

```bash
uci set sqm.eth1.interface='wg2'
uci set sqm.eth1.download='5000'
uci set sqm.eth1.upload='5000'
uci set sqm.eth1.enabled='1'
uci commit
/etc/init.d/sqm restart
```

## 三、调试

每个人的网络环境不一样，链接到海外服务器延迟和丢包不同，所以需要在本地openwrt调试，选择最优方案：

```bash

echo mode 1 > /tmp/fifo.file
echo fec 2:2 > /tmp/fifo.file
echo timeout 1 > /tmp/fifo.file
echo mtu 1360 > /tmp/fifo.file
ifconfig wg2 mtu 1300

echo mode 1 > /tmp/fifo.file
echo fec 4:1 > /tmp/fifo.file
echo timeout 1 > /tmp/fifo.file
echo mtu 1360 > /tmp/fifo.file
ifconfig wg2 mtu 1300
```

## 四、定制联系：

微信：muzi400
