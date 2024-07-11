# 虚拟机部署：



## 参考文档：

-  webase ： https://webasedoc.readthedocs.io/zh-cn/latest/docs/WeBASE/install.html
- fisco-bcos: ： https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/browser/browser.html#id1

# 10.63.14.212 实施一键化部署，部署webase 与 长安链



## Webase 部署

OS：ubuntu 20.04



### 环境要求

环境 	版本
Java 	Oracle JDK 8 至 14
MySQL 	MySQL-5.6及以上
Python 	Python3.6及以上
PyMySQL 	



一键部署脚本将自动安装openssl, curl, wget, git, nginx, dos2unix相关依赖项

oralce-jdk： https://download.oracle.com/otn/java/jdk/11.0.22%2B9/8662aac2120442c2a89b1ee9c67d7069/jdk-11.0.22_linux-x64_bin.deb



## WeBase 一键 docker 部署

- docker 容器一键部署： https://webasedoc.readthedocs.io/zh-cn/latest/docs/WeBASE-Install/docker_install.html

```
# 部署并启动所有服务（重新安装时需要先停止服务再重新安装，避免端口占用）
$ python3 deploy.py installDockerAll

# 服务部署后，需要对各个服务进行启动停止操作，使用如下命令：
# 一键部署
部署并启动所有服务        python3 deploy.py installDockerAll
停止一键部署的所有服务    python3 deploy.py stopDockerAll
启动一键部署的所有服务    python3 deploy.py startDockerAll
# 节点的启停
启动所有FISCO-BCOS节点:      python3 deploy.py startNode
停止所有FISCO-BCOS节点:      python3 deploy.py stopNode
# WeBASE服务的启停
启动所有WeBASE服务:      python3 deploy.py dockerStart
停止所有WeBASE服务:      python3 deploy.py dockerStop


# 检查节点   
$ docker ps | grep fiscobcos


# 检查节点前置 webase-front 容器：
$ docker ps | grep webase-front 

# 检查节点管理服务 webase-node-manage容器
$  docker ps | grep webase-node.mgr

# 检查签名服务webase-sign容器
$ docker ps  | grep webase-sign 

## 端口检查
### 节点的 channel 端口
$ netstat -lnap | grep 20200

### webase-front 
$ netstat -lnap | grep 5002

### webase-node-mgr
$ netstat -lnap | grep 5001

### webase-web
$ netstat -lnap | grep 5000

### webase-sign
$ netstat -lnap | grep 5004

## 日志存放点
|-- webase-deploy # 一键部署目录
|--|-- log # 部署日志目录
|--|-- webase-web # 管理平台目录
|--|--|-- log # 管理平台日志目录
|--|-- webase-node-mgr # 节点管理服务目录
|--|--|-- log # 节点管理服务日志目录
|--|-- webase-sign # 签名服务目录
|--|--|-- log # 签名服务日志目录
|--|-- webase-front # 节点前置服务目录
|--|--|-- log # 节点前置服务日志目录
|--|-- nodes # 一件部署搭链节点目录
|--|--|-- 127.0.0.1
|--|--|--|-- node0 # 具体节点目录
|--|--|--|--|-- log # 节点日志目录

## 日志查看
### webase-front
$ cd webase-front
$ grep -B 3 "main run success" log/WeBASE-Front.log


## 访问
http://{deployIP}:{webPort}
- 示例：http://localhost:5000
- admin/Abcd1234

### webase-front
- http://{frontIp}:{frontPort}/WeBASE-Front









```





## 安装 docker

https://cloud.tencent.com/developer/article/2322853?areaId=106005



重启

```
sudo shutdown -r now
sudo reboot
```



## 安装 docker-compose

```

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

```



## 配置镜像源



```
# 若目录不存在
mkdir -p /etc/docker
# 创建/修改daemon.json配置文件
sudo vim /etc/docker/daemon.json

# 配置内容如下：
{
"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}


## 重启
systemctl daemon-reload
systemctl restart docker.service

```



## PyMySQL部署（Python3.6+）



```
sudo apt-get install -y python3-pip
sudo pip3 install PyMySQL

```



## Pull Images ：  后续可考虑，镜像导出导入，节省时间

建议主动拉 ，

```

docker pull fiscoorg/fiscobcos:v2.9.1 
docker pull  mysql:5.6
docker pull webasepro/webase-front:v1.5.5
docker pull webasepro/webase-node-mgr:v1.5.5
docker pull webasepro/webase-sign:v1.5.5
docker pull webasepro/webase-web:v1.5.5


```





## 端口号说明

p2p_port： 30300~30303

channel_port：20200~20203

jsonrpc_port：8545~8548



## Webase-Sign 

```console

docker run -d --name mysql  -p 23306:3306 -v /home/user/data/mysql/data:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root1234 -d mysql:5.7

mysql -u root -p123456 

CREATE DATABASE IF NOT EXISTS webasesign DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


CREATE DATABASE IF NOT EXISTS webasenodemanager DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


CREATE DATABASE IF NOT EXISTS webasechainmanager DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


```



# keyServer

```

aesKey: EfdsW23D23d3df43

```











WeBase-Front  -------依赖------->WeBase-Sign  ： 因为调用合约部署、交易处理 时 需要签名。







##  访问

WeBase-Sign : http://10.63.14.213:5004/WeBASE-Sign/v2/api-docs

Node-Manager:    http://10.63.14.212:5001/WeBASE-Node-Manager/login

​	- http://10.63.14.213:5001/WeBASE-Node-Manager/swagger-ui/index.html

Webase-Front： http://10.63.14.212:5002/WeBASE-Front/#/onlineTools

Webase-Web ： http://10.63.14.212:5000/#/home

​	

WeBase-Chain-manager:  链管理器 ( 动态添加删除节点 )

-  http://10.63.14.213:5005/WeBASE-Chain-Manager

-  http://10.63.14.213:5005/WeBASE-Chain-Manager/swagger-ui.html

-  



## 仓库  repo

WeBASE-Front ： https://github.com/WeBankBlockchain/WeBASE-Front             

	- 后端： java
	- UI ： VUE

WeBASE-Node-Manager：  https://github.com/WeBankBlockchain/WeBASE-Node-Manager

 -  后端服务：提供操作的 api 

WeBase-Chain-Manager:    https://github.com/WeBankBlockchain/WeBASE-Chain-Manager

-  链管理器



## fisco-bcos  : https://github.com/FISCO-BCOS/FISCO-BCOS

- 语言：C++

### Fabric :   https://github.com/hyperledger/fabric

- 语言： golang















## JDK 8 解压安装

```

sudo mkdir /usr/lib/jvm
sudo tar -zxvf jdk-8u181-linux-x64.tar.gz -C /usr/lib/jvm


sudo vim ~/.bashrc


#set oracle jdk environment
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_181  ## 这里要注意目录要换成自己解压的jdk 目录
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH  


 source ~/.bashrc
 
 
 # default jdk
 
 sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_411/bin/java 300  
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_411/bin/javac 300  
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.8.0_411/bin/jar 300   
sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk1.8.0_411/bin/javah 300   
sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk1.8.0_411/bin/javap 300 






```





## 数据结构

```

+-------------------------------+
| Tables_in_webasenodemanager   |
+-------------------------------+
| tb_abi                        |
| tb_account_info               |
| tb_agency                     |
| tb_alert_log                  |
| tb_alert_rule                 |
| tb_app_info                   |
| tb_block_1                    |
| tb_cert                       |
| tb_chain                      |
| tb_cns                        |
| tb_config                     |
| tb_contract                   |
| tb_contract_folder            |
| tb_contract_item              |
| tb_contract_path              |
| tb_contract_store             |
| tb_external_account           |
| tb_external_contract          |
| tb_front                      |
| tb_front_group_map            |
| tb_govern_vote                |
| tb_group                      |
| tb_host                       |
| tb_mail_server_config         |
| tb_method                     |
| tb_node                       |
| tb_role                       |
| tb_stat                       |
| tb_token                      |
| tb_trans_daily                |
| tb_trans_hash_1               |
| tb_user                       |
| tb_user_transaction_monitor_1 |
| tb_warehouse                  |
+-------------------------------+


```





----

# Fisco Bcos  安装 与 扩容

命令行部署：https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/installation.html

```
# 快速搭建单链 单群组
bash build_chain.sh -l 127.0.0.1:4 -p 30300,20200,8545

# 如果是 搭建多群组的话，则选择配置文件 

```



build_chain 建链的时候，可以修改共识算法：

```
# build_chain.sh
consensus_type="pbft"
supported_consensus=(pbft raft rpbft)

```



命令行： https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/console/console_of_java_sdk.html#getsealerlist

## 扩容：

- https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/tutorial/add_new_node.html
- 

Browser:  https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/browser/browser.html#id1



## Nginx 

```

sudo systemctl status nginx.service

sudo systemctl reload nginx


```



# 数据签名

交易上链数据签名支持以下三种模式：

- 本地配置私钥签名
- 本地随机私钥签名
- 调用[WeBASE-Sign](https://github.com/WeBankBlockchain/WeBASE-Sign)进行签名



## 什么是 group 

https://fisco-bcos-documentation.readthedocs.io/zh-cn/stable/docs/articles/3_features/30_architecture/group_architecture_design.html

回想一下群聊场景：群聊用户都在你的通信录中，都是经过验证才添加的，且不在群里的用户看不到群聊信息。这与联盟链准入机制不谋而合，所有参与者的机构身份可知。

另一方面，群组架构中各群组独立执行共识流程，各组独立维护自己的交易事务和数据，不受其他群组影响。这样的好处是，可以使得各群组之间解除耦合独立运作，从而达成更好的隐私隔离。在跨群组之间的消息互通，则会带上验证信息，是可信和可追溯的。

群组架构自底向下主要划分为网络层、群组层，网络层主要负责区块链节点间通信，群组层主要负责处理群组内交易，每个群组均运行着一个独立的账本



##  FISCO BCOS中群组和机构的区别是什么？

Fisco Bcos 中的群组指的是由若干个节点参与共识构建的一个独立账本，一条链上有多个节点，任意部分节点可以构建一个或者多个群组。打个比方，Fisco Bcos 中的群组就如同微信中的聊天群，节点可以随意族群，群与群的消息相互隔离。

Fisco Bcos 中的机构的概念主要还是一个管理上的概念，体现在证书系统中，默认证书体系由三层组成，分别是链证书、机构证书、节点证书。链给结构签发证书，机构给节点签发证书。但是物理实体上，区块链系统仍然由节点互联组成，没有机构这个物理实体存在，这是 Fisco Bcos 2.x 的设计。

Fisco Bcos 3.0 将对网络架构进行升级，机构会作为一个重要的实体，成为网络架构的重要组成部分，联盟链的管理将以结构作为主体进行。







- group 如果动态 维护( CRUD )
- group 中如何动态添加 节点？
- group 如果更改共识算法
- group 



------



## 长安链：

### 1.2.1. 角色类型[](https://docs.chainmaker.org.cn/v3.0.0/html/instructions/PK模式长安链介绍.html#id3)



长安链中，定义了以下几种角色类型：

- 共识节点 `consensus`：有权参与区块共识流程的链上节点；
- 同步节点`common`：无权参与区块共识流程，但可在链上同步数据的节点；
- 管理员 `admin`：可代表组织进行链上治理的用户；
- 普通用户 `client`：无权进行链上治理，但可发送和查询交易的用户；
- 轻节点用户`light`：无权进行链上治理，无权发送交易，只可查询、订阅自己组织的区块、交易数据，属于SPV轻节点用户（详情见[轻节点](https://docs.chainmaker.org.cn/v3.0.0/html/tech/SPV轻节点.html)）



# 整体说明

https://docs.chainmaker.org.cn/v3.0.0/html/tech/%E6%95%B4%E4%BD%93%E8%AF%B4%E6%98%8E.html



## 身份权限管理

https://docs.chainmaker.org.cn/v3.0.0/html/tech/%E8%BA%AB%E4%BB%BD%E6%9D%83%E9%99%90%E7%AE%A1%E7%90%86.html



-------

#  讨论 待验证的



节点： 里面的 区块信息，从那个地方 打包 过来的，或者是 同步过来的。 ---> block 区块本身是没有记录从谁同步过来的，应该只有记录矿工 minner信息。 区块同步是比较区块高度，在交易广播阶段 ，就能比较区块高度，若是低区块，就先完成节点区块同步，同步完成后，再 执行交易验签。 

 webase 与chainmaker 都支持 国密： 建链的时候，操作。

事件订阅 ---> 数据上链后 怎么同步到业务系统 ？

链委员会的权限 用途： ？？？===> 系统权限







## 其他

## 超级账本

- https://hyperledger-fabric.readthedocs.io/zh-cn/latest/ledger/ledger.html
- https://yeasy.gitbook.io/blockchain_guide/02_overview/definition

























