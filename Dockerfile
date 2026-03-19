FROM almalinux:9

RUN dnf install -y \
    cmake \
    gcc-c++ \
    make \
 && dnf clean all

COPY . /src/cetlib

RUN cmake -S /src/cetlib -B /build/cetlib \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /build/cetlib \
 && cmake --install /build/cetlib
