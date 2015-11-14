#!/bin/sh
#
# deploy.sh: Idempotent script voor de installatie van Polaris op Vagrant
#

set -e

install_packages () {
    while [ $# -ne 0 ] ; do
        if [ -e /usr/share/doc/"$1" ] ; then
            printf 'Package already installed: %s\n' "$1" >&2
            shift
        else
            apt-get -y install "$@"
            break
        fi
    done
}

install_script () {
    SCRIPT=/usr/local/bin/"$1"
    printf "Installing %s...\n" "$SCRIPT" >&2
    cat > "$SCRIPT"
    chmod 755 "$SCRIPT"
}

apt-get update

install_script monitor-system <<'EOF'
#!/bin/sh
cd /vagrant
python bin/monitor-system "$@"
EOF

install_packages \
    build-essential
