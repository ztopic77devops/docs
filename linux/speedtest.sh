#!/bin/bash
export PATH=/usr/bin:/bin:/usr/local/bin
export HOME=/home/user
echo "Starting speedtest at $(date)" > /tmp/speedtest.log
JSON=$(/usr/bin/speedtest -f json-pretty --accept-license --accept-gdpr 2>>/tmp/speedtest.log)
SPEEDTEST_EXIT=$?
echo "Speedtest exit code: $SPEEDTEST_EXIT" >> /tmp/speedtest.log
echo "JSON Output: $JSON" >> /tmp/speedtest.log
if [ $SPEEDTEST_EXIT -ne 0 ]; then
    echo "speedtest command failed" >> /tmp/speedtest.log
    exit 1
fi
DOWNLOAD=$(echo "$JSON" | grep bandwidth | head -1 | sed 's/,$//' | cut -c 22-)
UPLOAD=$(echo "$JSON" | grep bandwidth | tail -1 | sed 's/,$//' | cut -c 22-)
echo "Download: $DOWNLOAD" >> /tmp/speedtest.log
echo "Upload: $UPLOAD" >> /tmp/speedtest.log
if [ -z "$DOWNLOAD" ] || [ -z "$UPLOAD" ]; then
    echo "Failed to parse bandwidth" >> /tmp/speedtest.log
    exit 1
fi
DOWNLOAD_MBPS=$(echo "scale=2; $DOWNLOAD/1000000*8" | bc 2>>/tmp/speedtest.log)
UPLOAD_MBPS=$(echo "scale=2; $UPLOAD/1000000*8" | bc 2>>/tmp/speedtest.log)
echo "Download Mbps: $DOWNLOAD_MBPS, Upload Mbps: $UPLOAD_MBPS" >> /tmp/speedtest.log
/usr/bin/echo speedtest{date=\"$(date +%F)\",speed=\"$DOWNLOAD_MBPS / $UPLOAD_MBPS\"} 1 > /opt/node_exporter/speedtest.prom 2>>/tmp/speedtest.log