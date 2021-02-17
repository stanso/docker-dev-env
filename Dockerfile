FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Repo
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install lsb-release software-properties-common fuse \
    # PPAs
    && add-apt-repository ppa:kelleyk/emacs \
    && apt-get -y update \
    # Utils
    && apt-get -y install build-essential git \
                          wget curl python3-pip ripgrep fd-find fzf htop iftop iotop \
                          emacs27-nox \
                          cmake bear global tmux zsh \
                          man-db \
    # Neovim nightly
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/bin/nvim \
    chmod 755 /usr/bin/nvim \
    # LLVM
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
    # Python
    && python3 -m pip install pynvim 'python-language-server[all]' flake8 black pyls-black pyls-isort tqdm numpy matplotlib \
    # Clean-up cache
    && rm -rf /var/lib/apt/lists/*

# For gem5
RUN apt-get -y update \
    && apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
                          libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
                          python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
                          libhdf5-serial-dev python3-pydot libpng-dev libelf-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 tssu && chsh -s /bin/zsh tssu
VOLUME /home/tssu
USER tssu
WORKDIR /home/tssu
CMD ["/bin/zsh"]

