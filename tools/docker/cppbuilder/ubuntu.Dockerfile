FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

#ENV TZ=Europe/Lisbon
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
                build-essential \
                clang \
                clang-12 \
                clang-format \
                #cmake \
                cppcheck \
                doxygen \
                gcovr \
                gdb \
                git \
                #lld \
                lcov \
                libboost-all-dev \
                libc++-12-dev \
                libc++abi-12-dev \
                libgtest-dev \
                libssl-dev \
                #make \
                ninja-build \
                python3 \
                python3-pip \
                python-is-python3 \
                wget \
                unzip \
        && rm -rf /var/lib/apt/lists/*

RUN wget "https://github.com/boyter/scc/releases/download/v3.0.0/scc-3.0.0-x86_64-unknown-linux.zip"
RUN unzip "scc-3.0.0-x86_64-unknown-linux.zip" -d /
RUN chmod +x /scc

RUN pip install cmake cppcheck-codequality matplotlib numpy

# Intel C++ SDK (linux-sgx)
RUN apt-get update && apt-get install -y --no-install-recommends \
                automake \
                autoconf \
                libtool \
                ocaml \
                ocamlbuild \
                perl \
        && rm -rf /var/lib/apt/lists/*

RUN git clone "https://github.com/intel/linux-sgx" /dockerfiles/linux-sgx
WORKDIR /dockerfiles/linux-sgx
RUN git checkout sgx_2.15.1 && make preparation
RUN cd /dockerfiles/linux-sgx/external/toolset/ubuntu20.04; cp ./* /usr/local/bin
RUN cd /dockerfiles/linux-sgx && make -j sdk && make -j sdk_install_pkg
RUN cd /dockerfiles/linux-sgx/linux/installer/bin/ && echo yes | ./sgx_linux_x64_sdk_2.15.101.1.bin
#RUN cd /dockerfiles/linux-sgx/linux/installer/bin/ && echo yes | ./sgx_linux_x64_sdk_2.16.100.4.bin
RUN echo "source /dockerfiles/linux-sgx/linux/installer/bin/sgxsdk/environment" > /startsgxenv.sh
RUN chmod +x /startsgxenv.sh

#COPY --from=initc3/linux-sgx:2.15-ubuntu20.04 /opt/sgxsdk /opt/sgxsdk

WORKDIR /builder
CMD ["bash"]
