FROM fedora:latest

CMD ["/bin/zsh"]

# Repo
RUN dnf upgrade -y && dnf install -y dnf-plugins-core
RUN dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
RUN dnf upgrade -y \
        && dnf install -y ncurses ncurses-devel \
                          zsh iproute perl git unzip bzip2 wget curl ripgrep fd-find python3 python3-devel python3-pip htop iftop iotop \
                          neovim emacs \
                          autoconf automake cmake bear global tmux libtool \
                          dtc texinfo \
                          gcc gcc-c++ clang clang-tools-extra \
                          gh \
        && dnf clean all \
        && rm -rf /var/cache/yum

# 24-bit color terminal
COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /usr/share/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

# Python Pip
RUN python3 -m pip install pynvim debugpy 'python-lsp-server[all]' flake8 black pyls-black pyls-isort tqdm numpy matplotlib scipy ipython jupyter pandas sympy nose

# For gem5
RUN dnf install -y scons m4 protobuf protobuf-devel protobuf-compiler zlib zlib-devel gperftools gperftools-devel gperftools-libs python3-devel python3-six libpng libpng-devel hdf5 hdf5-devel \
        && dnf clean all \
        && rm -rf /var/cache/yum

# removed boost boost-devel

# For riscv toolchain
RUN dnf install -y autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel \
        && dnf clean all \
        && rm -rf /var/cache/yum

# Applications
RUN dnf install -y graphviz pandoc \
                   verilator iverilog \
                   glibc-static libstdc++-static compat-libpthread-nonshared \
        && dnf clean all \
        && rm -rf /var/cache/yum

# svls
RUN curl --silent "https://api.github.com/repos/dalance/svls/releases/latest" | grep browser_download_url | grep x86_64-lnx.zip | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.zip -i - && unzip -d /usr/bin tmp.zip && rm -f tmp.zip

# python3 as python
RUN ln -s /usr/bin/python3 /usr/bin/python

# RUN git clone https://github.com/riscv/riscv-gnu-toolchain -b rvv-intrinsic
# RUN cd riscv-gnu-toolchain && git submodule update --init --recursive
# RUN cd riscv-gnu-toolchain && ./configure --prefix=/opt/riscv64-newlib-intrinsic
# RUN cd riscv-gnu-toolchain && make

# User setup
RUN useradd -u 1000 tssu && usermod -s /bin/zsh tssu
USER tssu
WORKDIR /home/tssu
VOLUME /home/tssu
