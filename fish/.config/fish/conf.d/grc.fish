if type -q grc
  set -U grc_plugin_execs \
    cat \
    cvs \
    df \
    diff \
    dig \
    gcc \
    g++ \
    ls \
    ifconfig \
    make \
    mount \
    mtr \
    netstat \
    ping \
    ps \
    tail \
    traceroute \
    wdiff \
    blkid \
    du \
    dnf \
    docker \
    docker-machine \
    env \
    id \
    ip \
    iostat \
    last \
    lsattr \
    lsblk \
    lspci \
    lsmod \
    lsof \
    getfacl \
    getsebool \
    ulimit \
    uptime \
    nmap \
    fdisk \
    findmnt \
    free \
    semanage \
    sar \
    ss \
    sysctl \
    systemctl \
    stat \
    showmount \
    tcpdump \
    tune2fs \
    vmstat \
    w \
    who
  set -U grc_plugin_execs_ignore \
    ls \
    ip

  for executable in $grc_plugin_execs
    if type -q $executable; and not contains $executable $grc_plugin_execs_ignore
      function $executable --inherit-variable executable --wraps=$executable
        grc $executable $argv
      end
    end
  end
end
