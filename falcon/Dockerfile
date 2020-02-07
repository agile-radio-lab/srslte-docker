FROM igorskh/uhd18:3.10

RUN apt update && \
	apt install -y \
	sudo \
	cmake \
	git \
	software-properties-common \
	libfftw3-dev \
	libmbedtls-dev \
	libconfig++-dev \
	libsctp-dev \
	libboost-program-options-dev \
    libglib2.0-dev \
    libudev-dev \
    libcurl4-gnutls-dev \
    libboost-all-dev \
    qtdeclarative5-dev \
    libqt5charts5-dev &&\
	rm -rf /var/lib/apt/lists/*
