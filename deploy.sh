#!/bin/sh
#
# deploy.sh: Idempotent script deployment of 'monitor-system' on Vagrant
#

set -e


install_packages () {
    while [ $# -ne 0 ] ; do
        if [ -e /usr/share/doc/"$1" ]; then
            printf 'Package already installed: "%s"\n' "$1" >&2
            shift
        else
            apt-get -y install "$@"
            break
        fi
    done
}


install_config () {
    CONFIG=/usr/local/etc/"$1"
    printf 'Installing configuration: "%s"\n' "$CONFIG" >&2
    if [ -L "$CONFIG" ]; then
        printf 'Configuration already installed: "%s"\n' "$1" >&2
    else
        ln -sf /vagrant/etc/"$1" "$CONFIG"
    fi
}


install_script () {
    SCRIPT=/usr/local/bin/"$1"
    printf 'Installing script: "%s"\n' "$SCRIPT" >&2
    cat > "$SCRIPT"
    chmod 755 "$SCRIPT"
}


install_cronjob () {
    SCRIPT=/etc/cron.d/"$1"
    printf 'Installing cronjob: "%s"\n' "$SCRIPT" >&2
    cat > "$SCRIPT"
    chmod 644 "$SCRIPT"
}


make_dir () {
    printf 'Creating directory: "%s"\n' "$1" >&2
    if [ ! -e "$1" ]; then
        mkdir -p "$1"
    fi
}


apt-get update

install_script monitor-system <<'EOF'
#!/bin/sh
cd /vagrant
python bin/monitor-system "$@"
EOF

make_dir /usr/local/etc/monitor-system.d

install_config monitor-system.conf

install_config monitor-system.d/monitor-passwd.conf
install_config monitor-system.d/monitor-netstat.conf

install_cronjob monitor-system < /vagrant/etc/cron-monitor-system.conf

install_packages \
    build-essential
