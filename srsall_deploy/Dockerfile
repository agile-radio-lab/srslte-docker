FROM igorskh/srslte:uhd.dev as builder

ARG srs_folder=./
ARG service_folder=srsall

COPY $srs_folder /$service_folder
RUN rm -rf /$service_folder/build
RUN mkdir /$service_folder/build
WORKDIR /$service_folder/build
RUN cmake \
	-DENABLE_GUI=OFF \
	-DENABLE_BLADERF=OFF \
	-DENABLE_BLADERF=OFF \
	-DENABLE_SOAPYSDR=OFF\
	-DENABLE_SRSEPC=ON\
	-DENABLE_SRSUE=ON \
	-DENABLE_SRSENB=ON ../ && \
	make

FROM igorskh/srslte:uhd.dev
ARG service_folder=srsall

RUN mkdir /$service_folder
COPY --from=builder /$service_folder/build /$service_folder
WORKDIR /$service_folder