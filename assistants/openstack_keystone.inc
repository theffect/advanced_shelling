
[ -z "$(which keystone)" ] && return 1

ks_admin_openrc() {
    cat > admin-openrc.sh << EOF

export OS_AUTH_URL=http://controller:35357/v2.0

export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS

export OS_TENANT_NAME=admin

export PS1='[\u@\h \W(ks \$OS_USERNAME)]\$ '
EOF
}


alias ks="keystone"
