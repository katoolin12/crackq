# Installation script to get Docker setup. Provide single
# argument: driver type and os (Ubuntu or Centos supported)
# in the following format docker/nvidia/ubuntu
if [ $# -lt 1 ]
	then
		echo "Argument required: docker/driver/os"
		exit
fi
OS=$(echo $1 | cut -d '/' -f 3)
DRIVER=$(echo $1 | cut -d '/' -f 2)

if [ ! -d ./build ]
	then
		mkdir ./build
    fi
if [ ! -d /var/crackq/files/masks ]
	then
                mkdir /var/crackq/
                mkdir /var/crackq/files/
                mkdir /var/crackq/logs/
                mkdir /var/crackq/logs/reports/
                mkdir /var/crackq/files/masks/
                mkdir /var/crackq/files/nginx/
                mkdir /var/crackq/files/nginx/conf.d/
                mkdir /var/crackq/files/saml/
                mkdir /var/crackq/files/rules/
                mkdir /var/crackq/files/masks/
    fi
touch /var/crackq/logs/crackq.log
cp ./cfg/nginx.conf /var/crackq/files/nginx/
cp ./cfg/crackq_nginx.conf /var/crackq/files/nginx/conf.d/
cp ./cfg/crackq.hcstat /var/crackq/files/crackq.hcstat
cp ./masks/* /var/crackq/files/masks/
cp -r ./rules/ /var/crackq/files/
# check os is alpine for running CI tests
source /etc/os-release
ls -althR /var/
if [ $ID = 'alpine' ]
	then
		addgroup --gid 1111 -S crackq && adduser --uid 1111 -S -G crackq crackq
		cp -r ./crackq/ ./build/
		cp -r ./utils/ ./build/
		cp ./cfg/sys_benchmark.txt /var/crackq/files/
		rm /var/crackq/files/crackq.conf
		cp crackq.conf /var/crackq/files/
	else
		groupadd -g 1111 -r crackq && useradd -u 1111 -r -g crackq crackq
fi
chown -R 1111:1111 /var/crackq/
ls -althR /var/
cp $1/* ./build
cp docker/common/* ./build
cp setup.py ./build/
cp ./crackq/log_config.ini ./build
#cp -r ./crackq/ ./build
cd ./build/
#docker build -t "$DRIVER-$OS" . --no-cache
docker build -t "$DRIVER-$OS" . 
#echo 'To run the application now use:\n\
#docker network create crackq_net\n\
#docker run --network crackq_net -d --name redis redis\n\
#docker run --runtime=nvidia --name crackq -p8080:8080 -v /var/crackq/:/var/crackq --network crackq_net -it "$DRIVER-$OS"'
