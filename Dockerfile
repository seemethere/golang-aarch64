FROM aarch64/ubuntu:xenial

RUN apt-get update && apt-get install -y \
	golang-go \
	apparmor \
	bash-completion \
	btrfs-tools \
	build-essential \
	cmake \
	curl \
	ca-certificates \
	debhelper \
	dh-apparmor \
	dh-systemd \
	git \
	libapparmor-dev \
	libdevmapper-dev \
	libltdl-dev \
	libseccomp-dev \
	pkg-config \
	vim-common \
	libsystemd-dev \
	--no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# Install Go
# We don't have official binary golang 1.7.5 tarballs for ARM64, eigher for Go or
# bootstrap, so we use golang-go (1.6) as bootstrap to build Go from source code.
# We don't use the official ARMv6 released binaries as a GOROOT_BOOTSTRAP, because
# not all ARM64 platforms support 32-bit mode. 32-bit mode is optional for ARMv8.
ENV GO_VERSION 1.8.3
RUN mkdir -p /usr/src/go && \
	curl -fsSL https://golang.org/dl/go${GO_VERSION}.src.tar.gz | tar -v -C /usr/src/go -xz --strip-components=1 \
	&& cd /usr/src/go/src \
	&& GOOS=linux GOARCH=arm64 GOROOT_BOOTSTRAP="$(go env GOROOT)" ./make.bash
ENV GOPATH /go
ENV PATH /go/bin:/usr/src/go/bin:$PATH
