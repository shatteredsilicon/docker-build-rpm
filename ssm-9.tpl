config_opts['dnf.conf'] += """

[go-el$releasever-$basearch]
name=go-el$releasever-$basearch
baseurl=https://dl.shatteredsilicon.net/misc/$releasever/RPMS/$basearch
gpgkey=https://dl.shatteredsilicon.net/misc/RPM-GPG-KEY-SS-MISC
gpgcheck=1
enabled=1

"""