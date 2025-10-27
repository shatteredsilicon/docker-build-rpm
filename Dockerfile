FROM rockylinux/rockylinux:9.6-minimal

# Ignore return value of microdnf as it seems to succeed but return a failure code on some hosts
RUN microdnf -y update || /bin/true
RUN microdnf -y install yum
RUN yum -y install epel-release
RUN dnf module enable -y nodejs:22
RUN yum -y --allowerasing install nodejs npm yum-utils rpmdevtools createrepo_c mock git \
        jq make gcc-c++ rsync rkhunter coreutils file

COPY go.repo /etc/yum.repos.d/go.repo
RUN yum install -y golang

RUN npm uninstall -g yarn pnpm && npm install -g corepack

RUN useradd builder -u 1000 -m -G users,wheel,mock && \
    chmod 755 /home/builder

RUN \
	corepack enable &&\
	corepack prepare yarn@stable --activate

COPY ssm-7.tpl /etc/mock/templates/ssm-7.tpl
COPY ssm-7.cfg /etc/mock/ssm-7-.cfg

COPY ssm-9.tpl /etc/mock/templates/ssm-9.tpl
COPY ssm-9.cfg /etc/mock/ssm-9-.cfg

RUN \
	ARCH="$(rpm --eval "%{_arch}")" &&\
	sed "s/_ARCH_/${ARCH}/g" /etc/mock/ssm-7-.cfg > "/etc/mock/ssm-7-${ARCH}.cfg" &&\
	sed "s/_ARCH_/${ARCH}/g" /etc/mock/ssm-9-.cfg > "/etc/mock/ssm-9-${ARCH}.cfg" &&\
	rm /etc/mock/ssm-7-.cfg /etc/mock/ssm-9-.cfg &&\
	sed -i 's/^mirrorlist=/#mirrorlist=/g' /etc/mock/templates/rocky-9.tpl &&\
	sed -i 's/^#baseurl=/baseurl=/g' /etc/mock/templates/rocky-9.tpl

ENV GOPATH=/home/builder/go
RUN chown -R builder:builder /home/builder

#Configure build time caches
ENV npm_config_cache=/mnt/cache/npm
ENV GOCACHE=/mnt/cache/go
ENV YARN_CACHE_FOLDER=/mnt/cache/yarn

RUN mkdir -p "${npm_config_cache}"
RUN mkdir -p "${GOCACHE}"
RUN mkdir -p "${YARN_CACHE_FOLDER}"
RUN chown -R builder:builder /mnt/cache

RUN mkdir -p /mnt/tmp/mock && chown -R builder:builder /mnt/tmp/mock

VOLUME /mnt/cache
VOLUME /mnt/tmp

# Entrypoint runs as root to set up the system, then drops privs
USER root
COPY entrypoint /usr/local/sbin/entrypoint
RUN chmod 744 /usr/local/sbin/entrypoint
ENTRYPOINT ["/usr/local/sbin/entrypoint"]

ENV FLAVOR=rpmbuild OS=rockylinux DIST=el9 PATH=$PATH:${GOPATH}/bin
WORKDIR /home/builder
