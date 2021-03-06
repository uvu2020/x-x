#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write mess configuration
cat << EOF > ${DIR_TMP}/heroku.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vmess",
        "settings": {
            "clients": [
          {
              "id": "425aac73-b6c8-4620-938c-4acdc57914bd",
              "alterId": 0,
              "security": "auto"
          }
      ]
    },
    "streamSettings": {
        "network": "tcp",
        "tcpSettings": {
            "header":{
                "type": "http",
                "response": {
                   "version": "1.1",
                   "status": "200",
                   "reason": "OK",
                   "headers": {
                       "Host": [
                           "sc.189.cn",
                           "wapsc.189.cn",
                           "wap.sc.189.cn",
                           "a.189.cn",
                           "amdc.alipay.com"
                       ],
                       "Content-Type": [ "application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash" ],
                       "Transfer-Encoding": ["chunked"],
                       "Connection": [ "keep-alive" ],
                       "Pragma": "no-cache"
                   }
                }
            }
        }
    }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get mess executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
busybox unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
${DIR_TMP}/v2ctl config ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.pb

# Install mess
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run mess
${DIR_RUNTIME}/v2ray -config=${DIR_CONFIG}/config.pb
