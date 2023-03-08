# shell script

echo "Start setup nginx-split-rtmp-to-ivs-and-flv"
# install
yum install -y git
yum  groupinstall -y "Development Tools" 
yum install -y pcre-devel openssl openssl-devel
yum install -y ca-certificates openssl openssl-devel stunnel gettext  

# Nginx
echo "setting up Nginx..."
## configure nginx with http-flv-module
curl http://nginx.org/download/nginx-1.22.1.tar.gz --output nginx-1.22.1.tar.gz
git clone https://github.com/winshining/nginx-http-flv-module.git
tar -zxvf nginx-1.22.1.tar.gz 

cd nginx-1.22.1/
./configure --add-module=../nginx-http-flv-module --with-http_ssl_module
make
make install
ls /usr/local/nginx/sbin/nginx
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
ln -s /usr/local/nginx/sbin/ffmpeg /usr/local/sbin/ffmpeg
cd ..

## enable nginx service
echo "setting up Nginx service..."
cp -f nginx/nginx.service /lib/systemd/system/nginx.service 
cp -f nginx/nginx.conf /usr/local/nginx/conf/
cp -rf nginx/www/ /usr/local/nginx/

systemctl start nginx.service
systemctl -l enable nginx
service nginx status

# sTunnel
echo "setting up sTunnel ..."
mkdir -p /var/log/stunnel
cp -f stunnel/stunnel.conf /etc/stunnel/stunnel.conf
mkdir -p /etc/stunnel/conf.d/
cp -f stunnel/ivs.conf /etc/stunnel/conf.d/ivs.conf

# stunnel /etc/stunnel/stunnel.conf

echo "setting up sTunnel service..."
cp -f stunnel/stunnel.service /lib/systemd/system/stunnel.service
systemctl daemon-reload
systemctl start stunnel.service
systemctl -l enable stunnel
service stunnel status

echo "Restarting services"
service stunnel restart
service nginx restart


echo "end"
exit 0 