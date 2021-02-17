FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get -y upgrade

# For gem5
RUN apt-get -y install build-essential git m4 scons zlib1g zlib1g-dev \
    libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
    python3-dev python3-six python-is-python3 doxygen libboost-all-dev \
    libhdf5-serial-dev python3-pydot libpng-dev libelf-dev

# Tools
RUN apt-get -y install wget curl python3-pip ripgrep fd-find fzf htop iftop iotop
RUN apt-get -y install neovim python3-neovim
RUN apt-get -y install cmake bear
RUN apt-get -y install lsb-release software-properties-common
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
RUN python3 -m pip install 'python-language-server[all]'
RUN python3 -m pip install flake8 black pyls-black pyls-isort

