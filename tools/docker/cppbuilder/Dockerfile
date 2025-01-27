FROM debian:bullseye
#FROM initc3/linux-sgx:2.17

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -i -e's/ main/ testing main contrib non-free/g' /etc/apt/sources.list
RUN sed -i -e's/ bullseye/ bookworm/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends \
                build-essential \
                clang \
                clang-13 \
                clang-format \
                clang-format-13 \
                cmake \
                cppcheck \
                doxygen \
                lld \
                gcovr \
                gdb \
                git \
                libc++-13-dev \
                libc++abi-13-dev \
                libgtest-dev \
                libboost-dev \
                libssl-dev \
                libssl1.1 \
		#libclang-common-11-dev \
		libgcc-11-dev \
		libclang-common-13-dev \
		lcov \
                ninja-build \
                python3 \
                python3-pip \
                python-is-python3 \
                wget \
                vim \
                nasm \
                unzip \
        && rm -rf /var/lib/apt/lists/*

RUN wget 'https://github.com/boyter/scc/releases/download/v3.0.0/scc-3.0.0-x86_64-unknown-linux.zip'
RUN unzip 'scc-3.0.0-x86_64-unknown-linux.zip' -d /
RUN chmod +x /scc

RUN pip install cppcheck-codequality matplotlib numpy

# sgx sdk
COPY --from=initc3/linux-sgx:2.17 /opt/sgxsdk /opt/sgxsdk
COPY --from=initc3/linux-sgx:2.17 /opt/sgxsdk /opt/sgxsdk
COPY --from=initc3/linux-sgx:2.17 /opt /opt
#COPY --from=initc3/linux-sgx:2.1.3 /opt/sgxsdk /opt/sgxsdk
#COPY --from=initc3/linux-sgx:2.1.3 /opt/sgxsdk /opt/sgxsdk
#COPY --from=initc3/linux-sgx:2.1.3 /opt /opt

RUN echo "source /opt/sgxsdk/environment" > /startsgxenv.sh \
        && chmod +x /startsgxenv.sh \
        && echo "source /opt/sgxsdk/environment" >> /root/.bashrc

WORKDIR /builder/
CMD ["bash"]
