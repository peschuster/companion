#!/bin/bash
SERVICE_PATH=/etc/systemd/system/companion.service

USAGE="sudo ./install-service.sh"

read -r -d '' UNIT_FILE << EOF
[Unit]
Description=Bitfocus Companion Service
After=multi-user.target

[Service]
Type=simple
WorkingDirectory=$(pwd)
Environment="COMPANION_CONFIG_BASEDIR=/home/pi"
ExecStart=node headless.js eth0
Restart=on-failure
User=pi

[Install]
WantedBy=multi-user.target
EOF

printf "\nInstalling service to: $SERVICE_PATH\n"
echo "$UNIT_FILE" > $SERVICE_PATH
systemctl daemon-reload
systemctl enable --no-pager companion.service
systemctl restart --no-pager companion.service
systemctl status --no-pager companion.service