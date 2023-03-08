# shell script

# install
yum install -y git
yum  groupinstall -y "Development Tools" 
yum install -y pcre-devel openssl openssl-devel
yum install -y ca-certificates openssl openssl-devel stunnel gettext  

# Nginx

## configure nginx with http-flv-module
curl http://nginx.org/download/nginx-1.22.1.tar.gz --output nginx-1.22.1.tar.gz
git clone https://github.com/winshining/nginx-http-flv-module.git
tar -zxvf nginx-1.22.1.tar.gz 

cd nginx-1.22.1/
./configure --add-module=/home/ec2-user/nginx-http-flv-module --with-http_ssl_module
make
make install
ls /usr/local/nginx/sbin/nginx
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
ln -s /usr/local/nginx/sbin/ffmpeg /usr/local/sbin/ffmpeg

## enable nginx service
cp nginx/nginx.service /lib/systemd/system/nginx.service 
systemctl start nginx.service
systemctl -l enable nginx
service nginx status

cp nginx/nginx.conf /usr/local/nginx/conf/
cp -r nginx/www/ /usr/local/nginx/

# sTunnel
yum install -y ca-certificates openssl libssl-dev stunnel4 gettext
cp stunnel/stunnel.conf /etc/stunnel/stunnel.conf
cp stunnel/ivs.conf /etc/stunnel/conf.d/ivs.conf

stunnel /etc/stunnel/stunnel.conf

cp stunnel/stunnel.service /lib/systemd/system/stunnel.service
systemctl -l enable stunnel
service stunnel status


exec ffmpeg -i rtmp://localhost/ivs/$name
								-vcodec libx264 -vprofile baseline -g 10 -s 1440x810 -b:v 1000K -acodec aac -ar 44100 -b:a 128k -f flv rtmp://localhost/ivs/$name_810p
	              -vcodec libx264 -vprofile baseline -g 10 -s 960x540 -b:v 500K -acodec aac -ar 44100 -b:a 128k -f flv rtmp://localhost/ivs/$name_5400p


singapore EC2 server via AGA:
ingest url = rtmp://15.197.177.111/ivs/
stream_key = 123456

IVS playback: https://9e2d2f15771f.ap-northeast-1.playback.live-video.net/api/video/v1/ap-northeast-1.421079580180.channel.vb7QcZgHDQLc.m3u8
FLV demo: https://d2emzfpm9nwgzs.cloudfront.net/www/
FLV 540p: https://d2emzfpm9nwgzs.cloudfront.net/live?port=1935&app=transcode&stream=123456_540p
FLV 810p: https://d2emzfpm9nwgzs.cloudfront.net/live?port=1935&app=transcode&stream=123456_810p