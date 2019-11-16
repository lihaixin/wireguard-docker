## 如果主机系统上尚未安装wireguard内核模块，请使用以下第一个运行命令进行安装：

# wireguard-docker
Wireguard setup in Docker on Debian  kernel meant for a simple personal VPN.
There are currently 2 branches, __stretch__ and __buster__. Use the branch that corresponds to your host machine if the kernel module install feature is going to be used.


## Overview
This docker image and configuration is my simple version of a wireguard personal VPN, used for the goal of security over insecure (public) networks, not necessarily for Internet anonymity. The docker images uses debian stable, and the host OS must also use the debian stable kernel, since the image will build the wireguard kernel modules on first run. As such, the hosts /lib/modules directory also needs to be mounted to the container on the first run to install the module (see the Running section below). Thanks to [activeeos/wireguard-docker](https://github.com/activeeos/wireguard-docker) for the general structure of the docker image. It is the same concept just built on Ubuntu 16.04.

In my use case, I'm running the wireguard docker image on a free-tier Google Cloud Platform debian virtual machine and connect to it with Android, Linux, and a GL-Inet router as clients.

## 运行
### 第一次运行

如果主机没有安装wireguard模块，通过下面语句安装
```
docker run -it --rm --cap-add sys_module -v /lib/modules:/lib/modules lihaixin/wireguard-docker:stretch install-module
```

### 正常运行
```
docker run --cap-add net_admin --cap-add sys_module -v <config volume or host dir>:/etc/wireguard -p <externalport>:<dockerport>/udp lihaixin/wireguard-docker:stretch
```
举例:
```
docker run --cap-add net_admin --cap-add sys_module -v wireguard_conf:/etc/wireguard -p 15903:15903/udp -p 15903:15903/tcp lihaixin/wireguard-docker:stretch
```

或者：
```
docker run --cap-add net_admin --cap-add sys_module  -p 15903:15903/udp -p 15903:15903/tcp lihaixin/wireguard-docker:stretch
```
### 生成KEY
This shortcut can be used to generate and display public/private key pairs to use for the server or clients
```
docker run -it --rm lihaixin/wireguard-docker:stretch genkeys
```

