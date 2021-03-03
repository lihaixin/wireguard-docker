# 利用wireguard打造加速游戏路由器

## 一、服务器端

使用docker部署，方便又利于管理

```bash
docker pull lihaixin/wireguard:stretch
docker stop wg0 && docker rm wg0
docker run -d \
   --name wg0 \
   -e SERVER_PORT=80 -e LANRANGE=192.168.0.0/24 \
   -e FEC_OPTIONS="2:2" \
   -e TIMEOUT=1 \
   -e WGNAME=wg0 \
   -e mtu=1300 \
   -e WANNAME=eth0  \
   -e WGCLIENTIP=10.1.0.2/32 -e WGSERVERIP=10.1.0.1/32 -e WGRANGE=10.1.0.0/24 \
   --cap-add net_admin --cap-add sys_module \
   --restart=always  --net=host --privileged  \
   lihaixin/wireguard:stretch

```

## 二、openwrt端

第一步：添加服务器ip到静态路由

第二步：删除防火墙

第三步：添加udptools

第四步：添加wg接口

## 三、调试

```bash
海外服务器和本地openwrt调试：
echo mode 1 > /tmp/fifo.file
echo fec 2:4 > /tmp/fifo.file
echo timeout 1 > /tmp/fifo.file
echo queue-len 2 > /tmp/fifo.file
echo mtu 1360 > /tmp/fifo.file
ifconfig wg0 mtu 1300
```

## 四、定制联系：

[https://github.com/lihaixin/dockerfile/blob/master/README.md](https://github.com/lihaixin/dockerfile/blob/master/README.md)
