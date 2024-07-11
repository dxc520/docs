

WeBase 一键部署安装


https://webasedoc.readthedocs.io/zh-cn/dev/docs/WeBASE-Install/docker_install.html#id13


# 拉取时，可输入拉取超时时间，默认为60s
$ python3 deploy.py pullDockerAll

# 部署并启动所有服务（重新安装时需要先停止服务再重新安装，避免端口占用）
$ python3 deploy.py installDockerAll


 部署完成后可以看到deploy has completed的日志
...
============================================================
              _    _     ______  ___  _____ _____ 
             | |  | |    | ___ \/ _ \/  ___|  ___|
             | |  | | ___| |_/ / /_\ \ `--.| |__  
             | |/\| |/ _ | ___ |  _  |`--. |  __| 
             \  /\  |  __| |_/ | | | /\__/ | |___ 
              \/  \/ \___\____/\_| |_\____/\____/  
...
...
============================================================
==============      deploy  has completed     ==============
============================================================
==============    webase-web version  v1.5.3        ========
==============    webase-node-mgr version  v1.5.3   ========
==============    webase-sign version  v1.5.3       ========
==============    webase-front version  v1.5.3      ========
============================================================


# 检查 端口
netstat -anlp | grep "5004\|5000\|5001\|5002\|20200"


# 检查日志：

$ cd webase-front
$ grep -B 3 "main run success" log/WeBASE-Front.log

或者

docker-compose -f docker/docker-compose.yaml logs -f



# 访问：
管理平台：http://localhost:5000
登录： admin/Abcd1234

前置节点：http://localhost:5002/WeBASE-Front


操作：
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






----

[
  "0x6db7ec0f083abe16f3fa87a596b05cf0a249f9ed"
]







export JAVA_HOME=/usr/lib/jvm/jdk-11-oracle-x64
export PATH=$JAVA_HOME/bin:$PATH











