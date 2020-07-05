# スマートカードサ－バー

スマートカードにアクセスする pcscd をDocker化したものです。
PC環境を汚さずMirakurunやMirakcでpcscdを利用する為に作成。
コンテナを起動するとスマートカードサ－バーとして起動します。

起動するとUNIXソケットファイル [ /var/run/pcscd/pcscd.comm ] が生成されるので、これを介してアクセスします。

&nbsp;

## DockerImageから起動する方法

```shell
docker run -it \
   -p 40774:40774 \
   --device=/dev/bus/usb/ \
   -v /var/run:/var/run \
   kurukurumaware/b-cas-server
```

### オプションについて

-p 40774:40774  
クライアントから本サーバーに接続する為のport  

--device=/dev/bus/usb/  
スマートカードのデバイスファイルが'/dev/bus/usb/001/002'等となっており、/dev/bus/usb/以下のデバイスにアクセスする。  

-v /var/run:/var/run  
UNIXソケットファイル [ /var/run/pcscd/pcscd.comm ]を作成する為に必要。  

## Debugモードで起動する

--debug  
kurukurumaware/b-cas-serverに続けてオプションを付けて起動すると画面にログが表示されます。  

```shell
docker run -it \
   -p 40774:40774 \
   --device=/dev/bus/usb/ \
   -v /var/run:/var/run \
   kurukurumaware/b-cas-server --debug
```

## docker-composeで起動する

### 起動

docker-compose up  

backgroundで起動する場合  
docker-compose up -d  

### 停止

Ctr + C  

backgroundで停止する場合  
docker-compose stop  

### docker-compose.yml

```none
version: '3.7'
services:
  bcas:
    image: kurukurumaware/b-cas-server
    container_name: smartcard
    devices:
      - /dev/bus/usb/
    ports:
      - 40774:40774
    volumes:
      - /var/run:/var/run
```

## 動作確認環境

Intel Pentium J3710  
Debian GNU/Linux 10 Linux 4.19.0-9-amd64  
