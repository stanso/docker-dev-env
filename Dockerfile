FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

CMD ["/bin/zsh"]
COPY xterm-24bit.terminfo /root
RUN /usr/bin/tic -x -o /lib/terminfo /root/xterm-24bit.terminfo && rm -f /root/xterm-24bit.terminfo

# Change Ubuntu apt mirror
# COPY sources.list /etc/apt
# RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1sg.\2/" /etc/apt/sources.list && \
#         apt-get update && apt-get upgrade --yes 

# Repo
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install lsb-release software-properties-common fuse \
    # PPAs
    && add-apt-repository ppa:kelleyk/emacs \
    && apt-get -y update \
    # Utils
    && apt-get -y install build-essential git unzip \
                          wget curl python3 python3-pip fzf htop iftop iotop \
                          emacs27-nox \
                          autoconf automake autotools-dev cmake bear global tmux zsh \
                          man-db pandoc libvterm-dev libvterm-bin libtool libtool-bin gvfs-fuse gvfs-backends\
                          verilator iverilog \
                          device-tree-compiler graphviz \
    # Clean-up cache
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Neovim nightly
RUN wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /usr/bin/nvim \
    && chmod 755 /usr/bin/nvim

# Python
RUN python3 -m pip install pynvim debugpy 'python-lsp-server[all]' flake8 black pyls-black pyls-isort tqdm numpy matplotlib

# ripgrep
RUN curl --silent "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep browser_download_url | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb

# fd
run curl --silent "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep browser_download_url | grep fd-musl_ | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb

# bat
RUN curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep browser_download_url | grep bat-musl_ | grep _amd64.deb | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.deb -i - && dpkg -i tmp.deb && rm -f tmp.deb

# svls
# RUN curl --silent "https://api.github.com/repos/dalance/svls/releases/latest" | grep browser_download_url | grep x86_64-lnx.zip | sed -E 's/.*"([^"]+)".*/\1/' | wget -q -O tmp.zip -i - && unzip -d /usr/bin tmp.zip && rm -f tmp.zip

# For gem5
RUN apt-get -y update \
    && apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
                          libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
                          python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
                          libhdf5-serial-dev python3-pydot libpng-dev libelf-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# For riscv-gnu-toolchain & spike
RUN apt-get -y update \
    && apt-get -y install device-tree-compiler \
                          autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# LLVM
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Github commnadline
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get -y update \
    && apt-get -y install gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN useradd -u 1000 tssu && chsh -s /bin/zsh tssu
USER tssu
WORKDIR /home/tssu
VOLUME /home/tssu
