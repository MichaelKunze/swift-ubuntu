FROM ubuntu:16.04

ENV SWIFT_DOWNLOAD https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
    build-essential \
    clang-3.8 \
    git \
    libcurl4-openssl-dev \
    libicu-dev \
    libpython2.7 \
    wget \

    # Set clang 3.8 as default
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \

    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

    && wget -O /swift.tar.gz ${SWIFT_DOWNLOAD} \

    && tar xzvf /swift.tar.gz \

    && rm /swift.tar.gz \

    # See following URL for details: http://tldp.org/LDP/lfs/LFS-BOOK-6.1.1-HTML/chapter06/pwdgroup.html
    && touch /var/run/utmp /var/log/{btmp,lastlog,wtmp} \
    && chgrp -v utmp /var/run/utmp /var/log/lastlog \
    && chmod -v 664 /var/run/utmp /var/log/lastlog \

    # See following URL for details: http://www.deer-run.com/~hal/sysadmin/pam_cracklib.html
    && touch /etc/security/opasswd \
    && chown root:root /etc/security/opasswd \
    && chmod 600 /etc/security/opasswd \

    # See following URL for details: http://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
    && grep -q '^net.ipv4.tcp_syncookies' /etc/sysctl.conf && sed -i 's/^net.ipv4.tcp_syncookies.*/net.ipv4.tcp_syncookies = 1/' /etc/sysctl.conf || echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf \
    && grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf && sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward = 0/' /etc/sysctl.conf || echo 'net.ipv4.ip_forward = 0' >> /etc/sysctl.conf \
    && grep -q '^net.ipv4.icmp_echo_ignore_broadcasts' /etc/sysctl.conf && sed -i 's/^net.ipv4.icmp_echo_ignore_broadcasts.*/net.ipv4.icmp_echo_ignore_broadcasts = 1/' /etc/sysctl.conf || echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf \

    && swift --version
