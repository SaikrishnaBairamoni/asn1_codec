FROM ubuntu:18.04
USER root

WORKDIR /asn1_codec

VOLUME ["/asn1_codec_share"]

# Add build tools.
RUN apt-get update && apt-get install -y software-properties-common wget git make gcc-7 g++-7 gcc-7-base && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100

# Install cmake.
RUN apt-get install -y cmake

# install libtool and automake
RUN apt-get install -y automake libtool

# Install librdkafka.
RUN apt-get install -y sudo
RUN wget -qO - https://packages.confluent.io/deb/7.3/archive.key | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/7.3 stable main"
RUN add-apt-repository "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main"
RUN apt update
RUN apt-get install -y libsasl2-modules libsasl2-modules-gssapi-mit libsasl2-dev libssl-dev 
RUN apt install -y librdkafka-dev

# Install pugixml
ADD ./pugixml /asn1_codec/pugixml
RUN cd /asn1_codec/pugixml && mkdir -p build && cd build && cmake .. && make && make install

# Build and install asn1c submodule
ADD ./asn1c /asn1_codec/asn1c
RUN cd /asn1_codec/asn1c && aclocal && test -f configure || autoreconf -iv && ./configure && make && make install

# Generate ASN.1 API.
RUN export LD_LIBRARY_PATH=/usr/local/lib
ADD ./asn1c_combined /asn1_codec/asn1c_combined
ADD ./scms-asn1 /asn1_codec/scms-asn1
RUN cd /asn1_codec/asn1c_combined && bash doIt.sh

# add the source and build files
ADD CMakeLists.txt /asn1_codec
ADD ./config /asn1_codec/config
ADD ./include /asn1_codec/include
ADD ./src /asn1_codec/src
ADD ./kafka-test /asn1_codec/kafka-test
ADD ./unit-test-data /asn1_codec/unit-test-data
ADD ./run_acm.sh /asn1_codec

RUN echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.profile
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.bashrc
RUN echo "export CC=gcc" >> ~/.profile
RUN echo "export CC=gcc" >> ~/.bashrc

# Build acm.
RUN mkdir -p /build && cd /build && cmake /asn1_codec && make

# Add test data. This changes frequently so keep it low in the file.
ADD ./docker-test /asn1_codec/docker-test

# run ACM
RUN chmod 7777 /asn1_codec/run_acm.sh
CMD ["/asn1_codec/run_acm.sh"]
