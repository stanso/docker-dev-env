FROM fedora:latest

CMD ["/bin/zsh"]

# Repo
RUN dnf upgrade -y && dnf install -y dnf-plugins-core
RUN dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
RUN dnf upgrade -y \
        && dnf install -y ncurses ncurses-devel \
                          zsh git unzip wget curl ripgrep fd-find python3 python3-pip htop iftop iotop \
                          neovim emacs \
                          autoconf automake cmake bear global tmux libtool \
                          clang clang-tools-extra \
                          gh \
                          graphviz pandoc \
                          verilator iverilog
        # && dnf clean all \
        # && rm -rf /var/cache/yum

COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /lib/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

# Python
RUN python3 -m pip install pynvim debugpy 'python-lsp-server[all]' flake8 black pyls-black pyls-isort tqdm numpy matplotlib

# svls
# RUN curl --silent "https://api.github.com/repos/dalance/svls/releases/latest" | grep browser_download_url | grep x86_64-lnx.zip | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.zip -i - && unzip -d /usr/bin tmp.zip && rm -f tmp.zip

# For gem5
RUN dnf install -y scons m4 protobuf protobuf-devel protobuf-compiler zlib zlib-devel gperftools gperftools-devel gperftools-libs python3-devel python3-six boost boost-devel libpng libpng-devel hdf5 hdf5-devel
        # && dnf clean all \
        # && rm -rf /var/cache/yum
RUN dnf install -y dtc texinfo
RUN dnf install -y perl
RUN dnf install -y autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel
RUN dnf install -y bzip2

COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /usr/share/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

RUN useradd -u 1000 tssu && usermod -s /bin/zsh tssu
USER tssu
WORKDIR /home/tssu
VOLUME /home/tssu
