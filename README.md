## 如果主机系统上尚未安装wireguard内核模块，请使用以下第一个运行命令进行安装：

# wireguard-docker
Docker在Debian内核上的Wireguard设置意味着一个简单的个人VPN。当前有2个分支，stretch和buster。如果要使用内核模块安装功能，请使用与您的主机对应的分支。
Wireguard setup in Docker on Debian  kernel meant for a simple personal VPN.
There are currently 2 branches, __stretch__ and __buster__. Use the branch that corresponds to your host machine if the kernel module install feature is going to be used.


Wireguard-泊坞窗





## 总览

该docker映像和配置是我的Wireguard Personal VPN的简单版本，用于实现不安全（公共）网络上的安全性目标，而不必用于Internet匿名性。容器映像使用debian稳定版，并且主机操作系统也必须使用debian稳定版内核，因为映像将在首次运行时构建wireguard内核模块。因此，在第一次运行时，还需要将主机/lib/modules目录挂载到容器上以安装模块（请参见下面的“运行”部分）。感谢[activeeos/wireguard-docker](https://github.com/activeeos/wireguard-docker)提供了Docker映像的常规结构。这与在Ubuntu 16.04上构建的概念相同。

在我的用例中，我正在免费的vultr虚拟机上运行wireguard docker映像，并以Android，Linux和openwrt路由器作为客户端连接到它。


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

