FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Repo
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install lsb-release software-properties-common
RUN add-apt-repository ppa:kelleyk/emacs
RUN apt-get -y update

# For gem5
RUN apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
    libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
    python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
    libhdf5-serial-dev python3-pydot libpng-dev libelf-dev

# Utils
RUN apt-get -y install wget curl python3-pip ripgrep fd-find fzf htop iftop iotop
RUN apt-get -y install neovim python3-neovim emacs27-nox
RUN apt-get -y install cmake bear global tmux zsh
# LLVM
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
# Python language server
RUN python3 -m pip install 'python-language-server[all]'
RUN python3 -m pip install flake8 black pyls-black pyls-isort

