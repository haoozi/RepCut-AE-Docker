FROM ubuntu:22.04

WORKDIR /RepCut-AE

# Layer 1: Only AE packages
COPY RepCut-AE ./

# Layer 2: Install all dependencies
RUN apt-get update \
    && ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get install -y \
    build-essential clang git flex bison help2man perl device-tree-compiler \
    python3-matplotlib python3-numpy rsync numactl time cmake \
    openjdk-11-jdk linux-tools-generic \
    sudo \
    apt-transport-https curl gnupg \
    && echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" > /etc/apt/sources.list.d/sbt.list \
    && echo "deb https://repo.scala-sbt.org/scalasbt/debian /" > /etc/apt/sources.list.d/sbt_old.list \
    && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import \
    && chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg \
    && apt-get update && apt-get install -y sbt \
    && apt-get clean


# Layer 3: Build FIRRTL
RUN make design_firrtl


CMD ["/bin/bash"]
