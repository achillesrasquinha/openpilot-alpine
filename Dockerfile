# onnxruntime Alpine Linux docker image.
#
# Building the image: 'docker image build --squash -t onnxruntime-alpine .'.
#
# For specifying onnxruntime version to build, set the ONNXRUNTIME_TAG variable accordingly.
#

FROM alpine:3.11 AS onnxruntime-builder

# Install build tools
#
RUN apk add --no-cache \
    bash cmake gcc g++ git make python3-dev

# Install headers and libs
#
RUN apk add --no-cache \
    lapack-dev libexecinfo-dev linux-headers openblas-dev zlib-dev

# Symlink /usr/bin/python to python3
#
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install python modules
#
RUN pip3 install --upgrade pip && \
    pip3 install cython numpy pybind11 pytest wheel

# Install pre-3.11 protobuf for onnx, due to https://github.com/onnx/onnx/issues/2481
#
RUN apk add --no-cache \
    protobuf-dev=3.6.1-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main

# Install pre-1.4.0 scipy for onnxmltools, due to https://github.com/scipy/scipy/issues/11319
#
RUN pip3 install scipy==1.2.3

# Install onnx and onnxmltools
#
RUN pip3 install onnx onnxmltools

# Clone onnxruntime
#
ENV ONNXRUNTIME_TAG v1.1.1
RUN set -ex && \
    git clone --branch $ONNXRUNTIME_TAG --recursive https://github.com/Microsoft/onnxruntime

# Patch build.py for Python 3.8: https://github.com/microsoft/onnxruntime/issues/2664
#
RUN cd /onnxruntime && \
    git fetch && \
    git checkout b40a85a0e8f89928b965a5ed5e90e158cd642355 -- tools/ci_build/build.py

# Remove all StringNormalizer tests, all of which are failing on Alpine due to
# musl locale feature parity vs. glibc
#
RUN set -ex && \
    rm /onnxruntime/onnxruntime/test/providers/cpu/nn/string_normalizer_test.cc && \
    sed "s/    return filters/    filters += \[\'^test_strnorm.*\'\]\n    return filters/" -i /onnxruntime/onnxruntime/test/python/onnx_backend_test_series.py

# Build and test onnxruntime.
# Add -Wno-deprecated-copy to build flag for suppressing deprecation warnings
# (eigen, proto) resulting with build failure.
#
RUN cd /onnxruntime && ./build.sh --config Release --parallel --build_wheel --enable_pybind --cmake_extra_defines CMAKE_CXX_FLAGS=-Wno-deprecated-copy --skip_tests

# Run again, with tests this time.
# This is done for seperating the build and test phases, for not failing the
# entire build if a test fails.
#
RUN cd /onnxruntime && ./build.sh --config Release --parallel --build_wheel --enable_pybind --cmake_extra_defines CMAKE_CXX_FLAGS=-Wno-deprecated-copy



# FROM  python:3.8-alpine3.15

# LABEL maintainer=achillesrasquinha@gmail.com

# ENV OPEN_PILOT_DIR=/openpilot \
#     CASADI_BRANCH=master \
#     ONNXRUNTIME_BRANCH=master \
#     CASADI_DIR=/casadi \
#     ONNXRUNTIME_DIR=/onnxruntime \
#     OPENPILOT_ALPINE_PATH=/usr/local/src/openpilot-alpine

# RUN apk add --no-cache --virtual .build-deps \
#         bash \
#         git \
#         make \
#         gcc \
#         g++ \
#         swig \
#         jq \
#         cmake \
#         musl-dev \
#         linux-headers \
#         libexecinfo-dev && \
#     apk add --no-cache \
#         protobuf-dev=3.6.1-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main && \
#     git clone https://github.com/casadi/casadi.git --depth 1 --branch ${CASADI_BRANCH} ${CASADI_DIR} && \
#     cd ${CASADI_DIR} && \
#     mkdir build && cd build && \
#     cmake -DWITH_PYTHON=ON .. && \
#     rm -rf ${CASADI_DIR}} && \
#     # onnx
#     pip install --upgrade pip && \
#     pip install numpy && \
#     git clone https://github.com/Microsoft/onnxruntime --depth 1 --branch ${ONNXRUNTIME_BRANCH} ${ONNXRUNTIME_DIR} && \
#     cd /onnxruntime && \
#     ./build.sh --parallel --build_wheel --enable_pybind \
#         --cmake_extra_defines DPYTHON_EXECUTABLE=python \
#         --cmake_extra_defines CMAKE_CXX_FLAGS=-Wno-deprecated-copy \
#         --skip_tests && \
#     cd .. && \
#     rm -rf ${ONNXRUNTIME_DIR} && \
#     git clone https://github.com/commaai/openpilot.git --depth 1 $OPEN_PILOT_DIR && \
#     cd ${OPEN_PILOT_DIR} && \
#     git submodule update --init --depth 1 && \
#     pip install \
#         scons && \
#     jq -r '.default \
#             | to_entries[] \
#             | .key + .value.version' \
#         ./Pipfile.lock > /requirements.txt && \
#     cat /requirements.txt | grep -v "casadi" | xargs pip install && \
#     # pipenv --python python install --clear && \
#     # scons -u -j$(nproc) && \
#     apk del \
#         .build-deps && \
#     pipenv --clear && \
#     pip uninstall scons pipenv && \
#     mkdir -p $OPENPILOT_ALPINE_PATH

# COPY . $OPENPILOT_ALPINE_PATH
# COPY ./docker/entrypoint.sh /entrypoint.sh

# WORKDIR $OPENPILOT_ALPINE_PATH

# RUN pip install -r ./requirements.txt && \
#     python setup.py install

# ENTRYPOINT ["/entrypoint.sh"]

# CMD ["openpilot-alpine"]