config_opts['yum.conf'] += """

[go-el$releasever-$basearch]
name=go-el$releasever-$basearch
baseurl=https://ftp.redsleeve.org/pub/misc/golang/$releasever/RPMS/$basearch
enabled=1
gpgcheck=0

"""