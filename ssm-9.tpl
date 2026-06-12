config_opts['dnf.conf'] += """
[nodesource-nodejs]
name=Node.js Packages for Linux RPM based distros - $basearch
baseurl=https://rpm.nodesource.com/pub_22.x/nodistro/nodejs/$basearch
priority=9
enabled=1
gpgcheck=1
gpgkey=https://rpm.nodesource.com/gpgkey/ns-operations-public.key
module_hotfixes=1

[go-el$releasever-$basearch]
name=go-el$releasever-$basearch
baseurl=https://dl.shatteredsilicon.net/misc/$releasever/RPMS/$basearch
gpgkey=https://dl.shatteredsilicon.net/misc/RPM-GPG-KEY-SS-MISC
gpgcheck=1
enabled=1
"""