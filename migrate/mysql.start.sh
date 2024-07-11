docker run -d \
	-p 3306:3306 \
	--name local-db-mysql \
	-v /home/dxch/data/mysql/configd:/etc/mysql/conf.d    \
	-v /home/dxch/data/mysql/data:/var/lib/mysql  \
	-e MYSQL_ROOT_PASSWORD=root1234 \
	-e TZ=Asia/Shanghai \
	mysql:5.7
