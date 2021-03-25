FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

CMD ["/bin/zsh"]
COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /lib/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

# Repo
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install lsb-release software-properties-common fuse \
    # PPAs
    && add-apt-repository ppa:kelleyk/emacs \
    && apt-get -y update \
    # Utils
    && apt-get -y install build-essential git unzip \
                          wget curl python3-pip fzf htop iftop iotop \
                          emacs27-nox \
                          cmake bear global tmux zsh \
                          man-db libvterm-dev libvterm-bin libtool libtool-bin gvfs-fuse gvfs-backends\
                          verilator iverilog \
    # Neovim nightly
    && wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/bin/nvim \
    && chmod 755 /usr/bin/nvim \
    # LLVM
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
    # Python
    && python3 -m pip install pynvim debugpy 'python-language-server[all]' flake8 black pyls-black pyls-isort tqdm numpy matplotlib \
    # ripgrep
    && curl --silent "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep browser_download_url | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb \
    # fd
    && curl --silent "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep browser_download_url | grep fd-musl_ | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb \
    # bat
    && curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep browser_download_url | grep bat-musl_ | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb \
    # svls
    && curl --silent "https://api.github.com/repos/dalance/svls/releases/latest" | grep browser_download_url | grep x86_64-lnx.zip | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.zip -i - && unzip -d /usr/bin tmp.zip && rm -f tmp.zip \
    # Clean-up cache
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# For gem5
RUN apt-get -y update \
    && apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
                          libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
                          python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
                          libhdf5-serial-dev python3-pydot libpng-dev libelf-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 tssu && chsh -s /bin/zsh tssu
USER tssu
WORKDIR /home/tssu
VOLUME /home/tssu
