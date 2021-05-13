#!/bin/bash
NAME=companion
SERVICE_PATH=/etc/systemd/system/${NAME}.service

USAGE="sudo ./install-service.sh"

read -r -d '' UNIT_FILE << EOF
[Unit]
Description=Bitfocus Companion Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=$(pwd)
Environment="COMPANION_CONFIG_BASEDIR=/home/pi"
ExecStart=node headless_ip.js 0.0.0.0 8000
KillSignal=SIGINT
TimeoutStopSec=60
Restart=on-failure
User=pi

[Install]
WantedBy=multi-user.target
EOF

printf "\nInstalling service to: $SERVICE_PATH\n"
echo "$UNIT_FILE" > $SERVICE_PATH
systemctl daemon-reload
systemctl enable --no-pager ${NAME}.service
systemctl restart --no-pager ${NAME}.service
systemctl status --no-pager ${NAME}.service