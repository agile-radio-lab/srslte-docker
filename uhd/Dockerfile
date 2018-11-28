FROM ubuntu:16.04

ARG uhd_tag=release_003_010_003_000
# Common build dependencies
RUN apt update && \
	apt install -y \
	--no-install-recommends \
	cmake \
	git \
	python \
	python-pip \
	libpython2.7-dev \
	libboost-all-dev \
	libusb-1.0-0-dev \
	python-mako \
	doxygen \
	python-docutils \
	build-essential && \
	git clone git://github.com/EttusResearch/uhd.git && \
	mkdir uhd/host/build && \
	cd /uhd/host/build && \
	git checkout tags/$uhd_tag && \
	cmake ../ && \
	make && \
	make install && \
	ldconfig && \
	rm -rf /uhd && \
	apt remove -y \
	cmake \
	git \
	python-mako \
	doxygen \
	python-docutils \
	build-essential \
	libboost-all-dev \
	python \
	python-pip \
	libpython2.7-dev && \
	# install libboost
	apt install -y \
	libboost-program-options1.58.0 \
	libboost-date-time1.58.0 \
	libboost-filesystem1.58.0 \
	libboost-serialization1.58.0 \
	libboost-regex1.58.0 \
	libboost-thread1.58.0 && \
	# clean
	apt autoremove -y && \
	rm -rf /var/lib/apt/lists/*