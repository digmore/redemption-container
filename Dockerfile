FROM debian:latest
#MAINTAINER digmore

RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		ca-certificates \
		g++ \
		git \
		libboost-dev \
		libboost-test-dev \
		libboost-tools-dev \
		libgssglue-dev \
		libkrb5-dev \
		libpng12-dev \
		libsnappy-dev \
		libssl-dev \
                locales \
		python-dev \
                python-pkg-resources \
                python-pip \
        && rm -fr /var/lib/apt/lists/* \
        && rm -fr /tmp/* \
        && rm -fr /var/tmp/*

RUN pip install honcho
COPY Procfile /Procfile

RUN git clone https://github.com/wallix/redemption.git /opt/redemption
WORKDIR /opt/redemption
RUN git submodule init && git submodule update
RUN bjam exe
RUN bjam install

EXPOSE 3389/tcp
CMD ["/usr/local/bin/honcho", "-d", "/", "-f", "Procfile", "start"]

