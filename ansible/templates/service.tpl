[Unit]
Description=ToDoApp
Requires=network-online.target
After=network-online.target

[Service]
Environment=SERVER=mongodb://{{ db_url }}:27017/
Environment=SESSION_SECRET=secret
Environment=PORT=80
WorkingDirectory={{ app_path }}
Type=simple
ExecStart=/usr/bin/node {{ app_path }}app.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
