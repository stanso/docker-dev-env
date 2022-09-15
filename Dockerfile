FROM ubuntu:20.04
ARG TARGETPLATFORM

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV HOST_USER=user
ENV HOST_UID=1000
ENV HOST_GID=1000

COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /lib/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

# Change Ubuntu apt mirror
# COPY sources.list /etc/apt
# RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1sg.\2/" /etc/apt/sources.list && \
#         apt-get update && apt-get upgrade --yes 

RUN yes | unminimize \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Repo
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install apt-utils lsb-release software-properties-common fuse openssh-server sudo tzdata \
    # Utils
    && apt-get -y install build-essential git unzip pkg-config locales man-db iproute2 iputils-ping net-tools \
                          linux-tools-generic gdb \
                          wget curl python3 python3-pip fzf htop iftop iotop \
                          autoconf automake autotools-dev cmake global tmux zsh \
                          valgrind valgrind-mpi \
                          man-db pandoc libvterm-dev libvterm-bin libtool libtool-bin gvfs-fuse gvfs-backends \
                          libprotobuf-dev protobuf-compiler libprotoc-dev libncurses-dev libssl-dev \
                          verilator iverilog \
                          device-tree-compiler graphviz \
    # Clean-up cache
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cross compilers
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=aarch64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=x86-64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=x86-64; else ARCHITECTURE=aarch64; fi \
    && apt-get -y update \
    && apt-get -y install gcc-${ARCHITECTURE}-linux-gnu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# chezmoi
RUN sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b /usr/bin

# For Mosh
RUN git clone https://github.com/mobile-shell/mosh.git /tmp/mosh \
    && cd /tmp/mosh \
    && ./autogen.sh && ./configure && make && make install \
    && cd /root && rm -rf /tmp/mosh
RUN locale-gen en_US.UTF-8

# Github commnadline
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get -y update \
    && apt-get -y install gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# LLVM
RUN cd /tmp && wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 14 all && rm -f llvm.sh && cd \
    && apt-get -y update \
    && apt-get -y install clang-14 clang-tools-14 clangd-14 clang-format-14 clang-tidy-14 lldb-14 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Bear
RUN apt-get -y update \
    && apt-get -y install libfmt-dev libspdlog-dev nlohmann-json3-dev libgrpc++-dev protobuf-compiler-grpc libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && cd /tmp && curl --silent "https://api.github.com/repos/rizsotto/bear/releases/latest" | grep tarball_url | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.tar.gz -i - && mkdir -p tmp && tar xf tmp.tar.gz --strip-components 1 -C tmp && rm -f tmp.tar.gz && cd tmp && cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF --parallel 4 . && make all -j8 && make install && cd .. && rm -rf tmp && cd

#Node.js
#RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
#    && apt-get -y update \
#    && apt-get -y install nodejs \
#    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python
RUN python3 -m pip install pynvim debugpy 'python-lsp-server[all]' black tqdm numpy scipy pandas matplotlib plotly protobuf bitstring scons

# ripgrep
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=x86_64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=aarch64; else ARCHITECTURE=x86_64; fi \
    && curl --silent "https://api.github.com/repos/microsoft/ripgrep-prebuilt/releases/latest" | grep browser_download_url | grep ${ARCHITECTURE}-unknown-linux-musl.tar.gz | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.tar.gz -i - && tar xf tmp.tar.gz -C /usr/bin && rm -f tmp.tar.gz

# fd
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi \
    && curl --silent "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep browser_download_url | grep fd_ | grep _${ARCHITECTURE}.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb

# bat
# RUN curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep browser_download_url | grep bat-musl_ | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb

# svls
# RUN curl --silent "https://api.github.com/repos/dalance/svls/releases/latest" | grep browser_download_url | grep x86_64-lnx.zip | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.zip -i - && unzip -d /usr/bin tmp.zip && rm -f tmp.zip

# PPAs
RUN add-apt-repository -y ppa:kelleyk/emacs \
    && add-apt-repository -y ppa:neovim-ppa/stable \
    && apt-get -y update \
    && apt-get -y install neovim emacs28-nativecomp \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# For gem5
RUN apt-get -y update \
    && apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
                          libgoogle-perftools-dev \
                          python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
                          libhdf5-serial-dev python3-pydot libpng-dev libelf-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# For riscv-gnu-toolchain & spike
RUN apt-get -y update \
    && apt-get -y install device-tree-compiler \
                          autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# For SST
RUN apt-get -y update \
    && apt-get -y install openmpi-bin openmpi-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN service ssh start
EXPOSE 22
CMD ["/bin/bash", "-c", "env && { id -u ${HOST_USER} &>/dev/null || { useradd -rm -d /home/${HOST_USER} -s /bin/zsh -g root -G sudo -u ${HOST_UID} ${HOST_USER} ; } && { echo ${HOST_USER}':'${HOST_USER} | chpasswd ; } ; } && /usr/sbin/sshd -D"]

