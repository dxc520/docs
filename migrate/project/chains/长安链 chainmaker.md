# 长安链 chainmaker

### 仓库 repo

- 链 chainmaker-go :  https://git.chainmaker.org.cn/chainmaker/chainmaker-go
- 链管理平台后端： https://git.chainmaker.org.cn/chainmaker/management-backend
-  链管理平台 UI ： https://git.chainmaker.org.cn/chainmaker/management-web
- 长安链相关文档： https://git.chainmaker.org.cn/chainmaker/chainmaker-docs
- 监控
  - protheus :   http://10.63.14.212:9090/targets
  -  grafana:   http://10.63.14.212:3333/d/CkwuqfoGk/chainmaker?orgId=1&refresh=5s




## 部署安装

 ### 通过管理台体验长安链：        [https://docs.chainmaker.org.cn/v3.0.0/html/quickstart/%E9%80%9A%E8%BF%87%E7%AE%A1%E7%90%86%E5%8F%B0%E4%BD%93%E9%AA%8C%E9%93%BE.html](https://docs.chainmaker.org.cn/v3.0.0/html/quickstart/通过管理台体验链.html)

 

使用容器一键部署： ( 下载速度慢，可 FQ )

1. 配置用户证书，配置好后，可以通过证书账户查看
2. 进入  区块链管理，配置链信息，并进行下一步 导出配置信息。
3. 根据导出的配置信息，使用脚本，启动链
4. 检查链是否启动成功： 

```

$ #查看节点进程是否存在

$ ps -ef|grep chainmaker | grep -v grep

$ #查看节点日志是否存在

$ cat ../release/*/log/system.log |grep "ERROR\|put block\|all necessary"

$ #若看到all necessary peers connected则表示节点已经准备就绪


```



5. 返回 管理台，点击下一步，订阅链 （）
   - 管理台将通过此处配置的链节点信息，同步长安链上的信息，和往链上发送交易
   - 此处配置的用户信息，将用于对所发送的交易进行交易签名

6. 部署合约: (例子没有跑通，部署失败，具体原因还未找到)
7. 合约调用(上链)
8. 交易查询





## MySql

````

                "MYSQL_ROOT_PASSWORD=Baec&chainmaker",
                "MYSQL_USER=chainmaker",
                "MYSQL_PASSWORD=Baec&chainmaker",
                "MYSQL_DATABASE=chainmaker_dev",
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "GOSU_VERSION=1.16",
                "MYSQL_MAJOR=5.7",
                "MYSQL_VERSION=5.7.44-1.el7",
                "MYSQL_SHELL_VERSION=8.0.35-1.el7"



````



##  tables

````

mysql> show tables;
+--------------------------+
| Tables_in_chainmaker_dev |
+--------------------------+
| cmb_block                |
| cmb_cert                 |
| cmb_chain                |
| cmb_chain_config         |
| cmb_chain_error_log      |
| cmb_chain_org            |
| cmb_chain_org_node       |
| cmb_chain_policy         |
| cmb_chain_policy_org     |
| cmb_chain_subscribe      |
| cmb_chain_user           |
| cmb_contract             |
| cmb_invoke_records       |
| cmb_node                 |
| cmb_org                  |
| cmb_org_node             |
| cmb_transaction          |
| cmb_upload_content       |
| cmb_user                 |
| cmb_vote_management      |
+--------------------------+

````





----

# 3、使用 CA 证书部署 Chainmaker

- 部署文档 ： https://docs.chainmaker.org.cn/v3.0.0/html/instructions/%E5%9F%BA%E4%BA%8ECA%E6%9C%8D%E5%8A%A1%E6%90%AD%E5%BB%BA%E9%95%BF%E5%AE%89%E9%93%BE.html
- 

## 3.1 环境准备

-  go
- gcc 
- git
- 7z
- docker
- mysql
- make



##  3.2 搭建 CA 服务器



````

CREATE DATABASE IF NOT EXISTS webasenodemanager DEFAULT CHARSET utf8 COLLATE utf8_general_ci;


````



- 配置 config.yml 文件，直接  run  deployed.sh 起服务
- 验证服务可用

```
curl --location --request GET 'http://10.63.14.213:8096/test'
```



## 3.3 生成各组织证书

- org1

``` 

curl --location --request POST 'http://localhost:8096/api/ca/querycerts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org1.chainmaker.org",
    "userType": "ca",
    "certUsage": "sign"
}' | jq

# 将返回的certContent保存为ca.key文件
echo -e "-----BEGIN CERTIFICATE-----\nMIICaDCCAg6gAwIBAgIIF4x2edRiVb8wCgYIKoZIzj0EAwIwYjELMAkGA1UEBhMC\nQ04xEDAOBgNVBAgTB0JlaWppbmcxEDAOBgNVBAcTB0JlaWppbmcxETAPBgNVBAoT\nCG9yZy1yb290MQ0wCwYDVQQLEwRyb290MQ0wCwYDVQQDEwRyb290MB4XDTIyMDgy\nNDAyNTAyMVoXDTIzMDIyMDAyNTAyMVowgYMxCzAJBgNVBAYTAkNOMRAwDgYDVQQI\nEwdCZWlqaW5nMRAwDgYDVQQHEwdCZWlqaW5nMR8wHQYDVQQKExZ3eC1vcmcxLmNo\nYWlubWFrZXIub3JnMQswCQYDVQQLEwJjYTEiMCAGA1UEAxMZY2Etd3gtb3JnMS5j\naGFpbm1ha2VyLm9yZzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABJm8UUrxkzvL\nzB6u++UjdTvFhy9Fay1h+X7xVijPp8LeyAX70P5O4VGvik7j/yCHoJ0GE89pxH4B\nUIq6WnVTtDWjgYswgYgwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w\nKQYDVR0OBCIEIFQUtaMGHEYWLDGcfWBR0SQZjuWdI31bW7tCAyrplWpuMCsGA1Ud\nIwQkMCKAID2QQznj2uOhDBY0zQDZs0PsixvqNqTx5WLTT7JErCJMMA0GA1UdEQQG\nMASCAIIAMAoGCCqGSM49BAMCA0gAMEUCIFHIdvzax2/g183R6RU1S0jqRZNiKvrL\nLPzccecq0N/1AiEApW3sgl93X7iKYQmThST97ha9W06au4wCh74CNRzCVKc=\n-----END CERTIFICATE-----\n" > ca.crt


# 查看组织 org1 的 CA 证书

openssl x509 -in ca.crt -noout -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1696861425238169023 (0x178c7679d46255bf)
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: C = CN, ST = Beijing, L = Beijing, O = org-root, OU = root, CN = root
        Validity
            Not Before: Aug 24 02:50:21 2022 GMT
            Not After : Feb 20 02:50:21 2023 GMT
        Subject: C = CN, ST = Beijing, L = Beijing, O = wx-org1.chainmaker.org, OU = ca, CN = ca-wx-org1.chainmaker.org
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:99:bc:51:4a:f1:93:3b:cb:cc:1e:ae:fb:e5:23:
                    75:3b:c5:87:2f:45:6b:2d:61:f9:7e:f1:56:28:cf:
                    a7:c2:de:c8:05:fb:d0:fe:4e:e1:51:af:8a:4e:e3:
                    ff:20:87:a0:9d:06:13:cf:69:c4:7e:01:50:8a:ba:
                    5a:75:53:b4:35
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                54:14:B5:A3:06:1C:46:16:2C:31:9C:7D:60:51:D1:24:19:8E:E5:9D:23:7D:5B:5B:BB:42:03:2A:E9:95:6A:6E
            X509v3 Authority Key Identifier:
                keyid:3D:90:43:39:E3:DA:E3:A1:0C:16:34:CD:00:D9:B3:43:EC:8B:1B:EA:36:A4:F1:E5:62:D3:4F:B2:44:AC:22:4C

            X509v3 Subject Alternative Name:
                DNS:, DNS:
    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:20:51:c8:76:fc:da:c7:6f:e0:d7:cd:d1:e9:15:35:
         4b:48:ea:45:93:62:2a:fa:cb:2c:fc:dc:71:e7:2a:d0:df:f5:
         02:21:00:a5:6d:ec:82:5f:77:5f:b8:8a:61:09:93:85:24:fd:
         ee:16:bd:5b:4e:9a:bb:8c:02:87:be:02:35:1c:c2:54:a7

```

​	

分别指定不同的`orgId`获取`wx-org2.chainmaker.org`，`wx-org3.chainmaker.org`和`wx-org4.chainmaker.org`的根证书。

```

# wx-org2.chainmaker.org
curl --location --request POST 'http://localhost:8096/api/ca/querycerts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org2.chainmaker.org",
    "userType": "ca",
    "certUsage": "sign"
}' | jq




# wx-org3.chainmaker.org
curl --location --request POST 'http://localhost:8096/api/ca/querycerts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org3.chainmaker.org",
    "userType": "ca",
    "certUsage": "sign"
}' | jq


# wx-org4.chainmaker.org
curl --location --request POST 'http://localhost:8096/api/ca/querycerts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org4.chainmaker.org",
    "userType": "ca",
    "certUsage": "sign"
}' | jq


```





## 3.4 生成节点证书

通过组织根CA签发共识节点证书，以org1为例：

- 共识节点（consensus node）Sign证书

*注：生成共识节点证书时，userId需要保证链上唯一；同一节点的Sign和Tls证书，userId需要保持一致。*

```

curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org1.chainmaker.org",
    "userId": "org1.consensus1.com",
    "userType": "consensus",
    "certUsage": "sign",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq



# 保存节点sign证书和sign私钥到文件中
$ echo -e "-----BEGIN CERTIFICATE-----\nMIICjTCCAjOgAwIBAgIIJWRNuoz/xNYwCgYIKoZIzj0EAwIwgYMxCzAJBgNVBAYT\nAkNOMRAwDgYDVQQIEwdCZWlqaW5nMRAwDgYDVQQHEwdCZWlqaW5nMR8wHQYDVQQK\nExZ3eC1vcmcxLmNoYWlubWFrZXIub3JnMQswCQYDVQQLEwJjYTEiMCAGA1UEAxMZ\nY2Etd3gtb3JnMS5jaGFpbm1ha2VyLm9yZzAeFw0yMjA4MjQwNDAzNTZaFw0yMzAy\nMjAwNDAzNTZaMIGEMQswCQYDVQQGEwJDTjEQMA4GA1UECBMHQmVpSmluZzEQMA4G\nA1UEBxMHQmVpSmluZzEfMB0GA1UEChMWd3gtb3JnMS5jaGFpbm1ha2VyLm9yZzES\nMBAGA1UECxMJY29uc2Vuc3VzMRwwGgYDVQQDExNvcmcxLmNvbnNlbnN1czEuY29t\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE63g+GfDmTKtuKn/Kv+0Z/gdwo7PB\nVioKfe3Om9NuQPklmn5fQju8KHBdEbCxvlsSsw1HjfLEuPyCUfsdCEVnuaOBjTCB\nijAOBgNVHQ8BAf8EBAMCBsAwKQYDVR0OBCIEICijhLeuc7ogfjdCOsVtypWmwWIn\n4pCUfuWuhIjFk3jAMCsGA1UdIwQkMCKAIFQUtaMGHEYWLDGcfWBR0SQZjuWdI31b\nW7tCAyrplWpuMCAGA1UdEQQZMBeCE29yZzEuY29uc2Vuc3VzMS5jb22CADAKBggq\nhkjOPQQDAgNIADBFAiEAwvcrJHmxaU27wolEIMsYpYJVbbbDepRWN3OVWuWLg4MC\nIDTIoD0gMTJekIkNJbGSdXspotWHAQp6BA0jV277LvkU\n-----END CERTIFICATE-----\n" > consensus1.sign.crt
$ echo -e "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIG7UtWyFE55mrAn9yUAx5EtrMD5eqAb619NZBjT7y/iVoAoGCCqGSM49\nAwEHoUQDQgAE63g+GfDmTKtuKn/Kv+0Z/gdwo7PBVioKfe3Om9NuQPklmn5fQju8\nKHBdEbCxvlsSsw1HjfLEuPyCUfsdCEVnuQ==\n-----END EC PRIVATE KEY-----\n" > consensus1.sign.key


# 查看节点sign证书
 openssl x509 -in consensus1.sign.crt -noout -text
 
 # 从证书Subject字段内容上我们可以看到，该证书账户属于wx-org1.chainmaker.org组织，角色为consensus
 
 
 

```



- 共识节点（consensus node）Tls证书

> *注：生成共识节点证书时，userId需要保证链上唯一；同一节点的Sign和Tls证书，userId需要保持一致。*

```
 curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org1.chainmaker.org",
    "userId": "org1.consensus1.com",
    "userType": "consensus",
    "certUsage": "tls",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq

# 将返回的节点tls私钥和节点tls证书保存到文件中：
$ echo -e "-----BEGIN CERTIFICATE-----\nMIICqzCCAlKgAwIBAgIIEqietqEmB/IwCgYIKoZIzj0EAwIwgYMxCzAJBgNVBAYT\nAkNOMRAwDgYDVQQIEwdCZWlqaW5nMRAwDgYDVQQHEwdCZWlqaW5nMR8wHQYDVQQK\nExZ3eC1vcmcxLmNoYWlubWFrZXIub3JnMQswCQYDVQQLEwJjYTEiMCAGA1UEAxMZ\nY2Etd3gtb3JnMS5jaGFpbm1ha2VyLm9yZzAeFw0yMjA4MjQwNDEyNTVaFw0yMzAy\nMjAwNDEyNTVaMIGEMQswCQYDVQQGEwJDTjEQMA4GA1UECBMHQmVpSmluZzEQMA4G\nA1UEBxMHQmVpSmluZzEfMB0GA1UEChMWd3gtb3JnMS5jaGFpbm1ha2VyLm9yZzES\nMBAGA1UECxMJY29uc2Vuc3VzMRwwGgYDVQQDExNvcmcxLmNvbnNlbnN1czEuY29t\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEwcTZ0srq9NqDaXKbgyBA5YlSrqZQ\nTOchtoMQLOxpjfsCNLanNGpqFDgg2Aa8rEv77/GW8NAl2RQEuRQES//YwaOBrDCB\nqTAOBgNVHQ8BAf8EBAMCA/gwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMB\nMCkGA1UdDgQiBCCVdXEP1II8b1lCnDbVT6nokYwOShyxV4NbP42nayY1xDArBgNV\nHSMEJDAigCBUFLWjBhxGFiwxnH1gUdEkGY7lnSN9W1u7QgMq6ZVqbjAgBgNVHREE\nGTAXghNvcmcxLmNvbnNlbnN1czEuY29tggAwCgYIKoZIzj0EAwIDRwAwRAIgeGaY\nTebfVu8sCrwZZrJDg0D4n2qTQoZcBy6LWOCSjRACIC5X+H+1NeMW3gPQ6fSSwd/x\n5YDXog2pUocoUuUhiphJ\n-----END CERTIFICATE-----\n" > consensus1.tls.crt
$ echo -e "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEICXRU0a1Jnz9VReDVLA7W5AQUUg6f/22uFuaJgg7aZQtoAoGCCqGSM49\nAwEHoUQDQgAEwcTZ0srq9NqDaXKbgyBA5YlSrqZQTOchtoMQLOxpjfsCNLanNGpq\nFDgg2Aa8rEv77/GW8NAl2RQEuRQES//YwQ==\n-----END EC PRIVATE KEY-----\n" > consensus1.tls.key



# 查看节点tls证书
$ openssl x509 -in consensus1.tls.crt -noout -text

从证书Subject字段内容上我们可以看到，该证书账户属于wx-org1.chainmaker.org组织，角色为consensus



```



- 获取共识节点的NodeId

```
 curl --location --request POST 'http://localhost:8096/api/ca/getnodeid' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org1.chainmaker.org",
    "userId": "org1.consensus1.com",
    "userType": "consensus",
    "certUsage": "tls"
}' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   249  100   118  100   131   6555   7277 --:--:-- --:--:-- --:--:-- 13833
{
  "code": 200,
  "msg": "The request service returned successfully",
  "data": "QmNgWQTRn8ijLThpu7sknFqEmGo2jELT32Wuwt3ZsnqKAP" #节点nodeId
}

```



###  注：重复以上步骤，依次生成组织org2，org3，org4下共识节点sign私钥/证书、tls私钥/证书以及节点的NodeId



-  org2

```

# sign 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org2.chainmaker.org",
    "userId": "org2.consensus2.com",
    "userType": "consensus",
    "certUsage": "sign",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq


# tls 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org2.chainmaker.org",
    "userId": "org2.consensus2.com",
    "userType": "consensus",
    "certUsage": "tls",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq




# nodeId
curl --location --request POST 'http://localhost:8096/api/ca/getnodeid' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org2.chainmaker.org",
    "userId": "org2.consensus2.com",
    "userType": "consensus",
    "certUsage": "tls"
}' | jq


```



- org3

```

# sign 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org3.chainmaker.org",
    "userId": "org3.consensus3.com",
    "userType": "consensus",
    "certUsage": "sign",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq


# tls 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org3.chainmaker.org",
    "userId": "org3.consensus3.com",
    "userType": "consensus",
    "certUsage": "tls",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq



# nodeId
curl --location --request POST 'http://localhost:8096/api/ca/getnodeid' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org3.chainmaker.org",
    "userId": "org3.consensus3.com",
    "userType": "consensus",
    "certUsage": "tls"
}' | jq



```



- org4

````

# sign 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org4.chainmaker.org",
    "userId": "org4.consensus4.com",
    "userType": "consensus",
    "certUsage": "sign",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq


# tls 
curl --location --request POST 'http://localhost:8096/api/ca/gencert' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org4.chainmaker.org",
    "userId": "org4.consensus4.com",
    "userType": "consensus",
    "certUsage": "tls",
    "country": "CN",
    "locality": "BeiJing",
    "province": "BeiJing"
}'  | jq



# nodeId
curl --location --request POST 'http://localhost:8096/api/ca/getnodeid' \
--header 'Content-Type: application/json' \
--data-raw '{
    "orgId": "wx-org4.chainmaker.org",
    "userId": "org4.consensus4.com",
    "userType": "consensus",
    "certUsage": "tls"
}' | jq




````





## 4、运维监控

- docs ： https://docs.chainmaker.org.cn/v3.0.0/html/dev/%E7%9B%91%E6%8E%A7%E8%BF%90%E7%BB%B4.html











## 5、添加组织与节点  （链上扩容  L1 ： 动态添加组织与节点 ）

> 参考文档：
>
> Chainmaker：  https://docs.chainmaker.org.cn/v2.3.0/html/recovery/%E9%95%BF%E5%AE%89%E9%93%BE%E8%8A%82%E7%82%B9%E7%AE%A1%E7%90%86.html
>
> Webase： https://fisco-bcos-documentation.readthedocs.io/zh-cn/latest/docs/tutorial/add_new_node.html
>
> 
>
> 注意： Chainmaker 与 webase 的 添加节点不一样：
>
> 1、 webase 添加节点： webase 是在节点之上 建立 逻辑 group。
>
> 1.1  生成证书，
>
> 1.2 拷贝部署包，修改相关配置。（证书配置、端口配置） + 创世区块配置 + group 配置
>
> 1.3 启动节点，即可加入网络。此时节点处于游离状态。
>
> 1.4 加入群组（共识节点：addSealer。观察节点：addObserver ）

> 2、Chainmaker 的流程不同。Chainmaker链是先有 组织，再有节点
>
> 2.1  使用 ca 服务 或者 cmc 。创建组织根证书，根据组织再创建 节点证书  和 用户证书
>
> 2.2 使用cmc 工具添加组织根证书
>
> 2.3 准备部署物料包，替换证书 和修改配置，启动节点同步至最新高度区块
>
> ```
> # 详见后面说明
> ```
>
> 
>
> 2.4 使用 cmc 添加节点为共识节点。
>
> ```
> ```
>
> 

## 2.3 Chainmaker 添加节点，物料包准备

```

1. 复制部署包
$ cd build/release
$ cp -rf chainmaker-v2.0.0-wx-org1.chainmaker.org chainmaker-v2.0.0-wx-org5.chainmaker.org
2. 把chainmaker-v2.0.0-wx-org5.chainmaker.org/bin下所有的.sh脚本中所有wx-org1.chainmaker.org替换为wx-org5.chainmaker.org
3. 重命名
$ cd build/release/chainmaker-v2.0.0-wx-org5.chainmaker.org/config
$ mv wx-org1.chainmaker.org wx-org5.chainmaker.org
4. 使用chainmaker-cryptogen生成的wx-org5.chainmaker.org下的node和user分别覆盖掉chainmaker-v2.0.0-wx-org5.chainmaker.org/config/wx-org5.chainmaker.org/certs下的node和user
5. 修改chainmaker.yml
   把chainmaker-v2.0.0-wx-org5.chainmaker.org/config/wx-org5.chainmaker.org/chainmaker.yml中所有wx-org1.chainmaker.org替换为wx-org5.chainmaker.org
   修改net模块，把 listen_addr: /ip4/0.0.0.0/tcp/11301 修改为 listen_addr: /ip4/0.0.0.0/tcp/11305
   修改rpc模块，把 port: 12301 修改为 port: 12305
   修改monitor模块，把 port: 14321 修改为 port: 14325
   修改pprof模块，把 port: 24321 修改为 port: 24325
6. 修改chainmaker-v2.0.0-wx-org5.chainmaker.org/config/wx-org5.chainmaker.org/chainconfig/bc1.yml中的trust_roots模块。
   把所有 ../config/wx-org1.chainmaker.org 修改为 ../config/wx-org5.chainmaker.org
7. 启动节点
$ cd build/release/chainmaker-v2.0.0-wx-org5.chainmaker.org/bin
$ ./start.sh
8. 通过日志观察节点同步的区块高度
$ cd build/release/chainmaker-v2.0.0-wx-org5.chainmaker.org/log
$ tail -f system.log | grep "commit block \["



```





## 6、链下扩容技术方案 : 常说的 L2 扩容方案。主要是为了提高  性能。比如  吞吐   性能。 

- docs : https://docs.chainmaker.org.cn/v3.0.0/html/tech/%E9%93%BE%E4%B8%8B%E6%89%A9%E5%AE%B9%E9%A1%B9%E7%9B%AE%E6%8A%80%E6%9C%AF%E6%96%87%E6%A1%A3.html#





## 9、其他异常处理

- apt update 异常。存在某个仓库更新不了

```
如果报仓库"http://ppa.launchpad.net/chris-lea/node.js/ubuntu focal Release"没有Release文件

解决办法，删除chris-lea/node.js 这个ppa文件，

   删除命令：

   sudo add-apt-repository --remove ppa:/chris-lea/node.js
```



## 9.1 容器批量删除

```\

docker rm `docker ps -a | awk 'NR>1 {print $1}'`

```















## 技术架构















## 其他

## 超级账本

- https://hyperledger-fabric.readthedocs.io/zh-cn/latest/ledger/ledger.html















































