FROM nebulabroadcast/casparcg-base as build-casparcg

ARG PROC_COUNT=8
ARG CC
ARG CXX
ARG GIT_HASH

ADD support/boost.tar.gz /opt
ADD support/cef.tar.gz /opt

ENV BOOST_ROOT=/opt/boost

RUN mkdir /source && mkdir /build && mkdir /install
COPY ./src /source
WORKDIR /build

RUN cmake /source
RUN make -j $PROC_COUNT

RUN ln -s /build/staging /staging && \
    /source/shell/copy_deps.sh shell/casparcg /staging/lib

