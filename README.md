# nginx-split-rtmp-to-ivs-and-flv
A demo showing how to use nginx + nginx-http-flv-module + stunnel to split a RTMP stream into Amazon IVS and FLV output using EC2


## Get started

1. SSH into EC2 (amazon-linux-2) and run as root 

    `sudo su - `

2. Clone Repo

    `git clone https://github.com/hspoon-aws/nginx-split-rtmp-to-ivs-and-flv.git`

3. setup your own environment param

    - set your \<IVS ingest url\> in `stunnel/ivs.conf` and `stunnel/stunnel.conf`
    - set your \<IVS stream key\>in `nginx\nginx.conf`


4. run setup.sh (pls aware if there is any error in between)


## Testing environment
- EC2 Amazon Linux 2, c5.4xlarge, 40GB EBS
- FLV.js demo webpage: `/www/`
- FLV stream url:
    - `/live?port=1935&app=transcode&stream=123456_540p`
    - `/live?port=1935&app=transcode&stream=123456_810p`

## Start/Stop Stream
The command to stop the stream is:
curl http://<IP>/control/drop/publisher?app=appname&name=streamname;
or run curl locally at the same EC2:  curl http://localhost/control/drop/publisher?app=ivs&name=123456
 
This command will stop publishing the stream. However, if you keep rtmp ingesting, Nginx will reconnect the ingest and publish again after several seconds. So we need loop stopping the publishing with the continuous ingest by running the following bash:
 
while True; do
curl http://localhost/control/drop/publisher?app=appname&name=streamname;
sleep 3; need short enough to avoid reconnecting
done
 
The output can be resumed (start stream again) by exiting the loop above.
    

## Dependency:
- https://github.com/winshining/nginx-http-flv-module.git
- http://nginx.org/download/nginx-1.22.1.tar.gz
- https://runmedia.s3.ap-southeast-1.amazonaws.com/temp/ffmpeg
- stunnel