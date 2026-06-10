config_opts['yum.conf'] += """

[go-el$releasever-$basearch]
name=go-el$releasever-$basearch
baseurl=https://ftp.redsleeve.org/pub/misc/golang/$releasever/RPMS/$basearch
gpgkey=https://ftp.redsleeve.org/pub/misc/golang/RPM-GPG-KEY-golang.pub
gpgcheck=1
enabled=1

"""