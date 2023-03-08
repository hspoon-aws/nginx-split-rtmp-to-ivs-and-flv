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
    