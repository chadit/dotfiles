# timers.sh : commands to help with timers.
# implentation of timers that use systemd timers instead of cron.

function timer_git_update() {
    local SERVICE_NAME="git-update-pull"
    local SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
    local TIMER_PATH="/etc/systemd/system/${SERVICE_NAME}.timer"

# Function to create the service file
create_service_file() {
    sudo bash -c "cat <<EOF > '$SERVICE_PATH'
[Unit]
Description=Git Pull Service

[Service]
Type=oneshot
EnvironmentFile=/etc/environment
User=chadit
Group=chadit
ExecStart=/bin/zsh $HELPER_DOTFILES_HOME/helpers/timers/git-timer.sh
EOF"
}

# Function to create the timer file
create_timer_file() {
   sudo bash -c "cat <<EOF > '$TIMER_PATH'
[Unit]
Description=Runs git pull every Saturday

[Timer]
OnCalendar=Sat *-*-* 00:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF"
}

# Check if the timer exists
if [ ! -f "$TIMER_PATH" ]; then
    echo "Creating $SERVICE_NAME systemd service and timer..."

    # Create service and timer files
    create_service_file
    create_timer_file

    # Reload systemd to recognize new service and timer
    sudo systemctl daemon-reload

    # Enable and start the timer
    sudo systemctl enable "${SERVICE_NAME}.timer"
    sudo systemctl start "${SERVICE_NAME}.timer"

    echo "$SERVICE_NAME timer created and started."
else
    echo "$SERVICE_NAME timer already exists."
fi
}

function timer_system_cleanup() {
    local SERVICE_NAME="system-cleanup"
    local SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
    local TIMER_PATH="/etc/systemd/system/${SERVICE_NAME}.timer"

# Function to create the service file
create_service_file() {
    sudo bash -c "cat <<EOF > '$SERVICE_PATH'
[Unit]
Description=system cleanup

[Service]
Type=oneshot
EnvironmentFile=/etc/environment
User=chadit
Group=chadit
ExecStart=/bin/zsh $HELPER_DOTFILES_HOME/helpers/timers/system-timer.sh
EOF"
}

# Function to create the timer file
create_timer_file() {
   sudo bash -c "cat <<EOF > '$TIMER_PATH'
[Unit]
Description=Runs git pull every Sunday

[Timer]
OnCalendar=Sun *-*-* 00:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF"
}

# Check if the timer exists
if [ ! -f "$TIMER_PATH" ]; then
    echo "Creating $SERVICE_NAME systemd service and timer..."

    # Create service and timer files
    create_service_file
    create_timer_file

    # Reload systemd to recognize new service and timer
    sudo systemctl daemon-reload

    # Enable and start the timer
    sudo systemctl enable "${SERVICE_NAME}.timer"
    sudo systemctl start "${SERVICE_NAME}.timer"

    echo "$SERVICE_NAME timer created and started."
else
    echo "$SERVICE_NAME timer already exists."
fi
}