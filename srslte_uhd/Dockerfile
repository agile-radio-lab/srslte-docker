FROM igorskh/uhd:v3.10

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
	libboost-program-options-dev && \
	rm -rf /var/lib/apt/lists/*
