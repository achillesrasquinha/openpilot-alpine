

FROM  python:alpine3.8

LABEL maintainer=achillesrasquinha@gmail.com

ENV OPEN_PILOT_DIR=/openpilot \
    CASADI_BRANCH=master \
    ONNXRUNTIME_BRANCH=master \
    CASADI_DIR=/casadi \
    ONNXRUNTIME_DIR=/onnxruntime \
    OPENPILOT_ALPINE_PATH=/usr/local/src/openpilot-alpine

RUN apk add --no-cache --virtual .build-deps \
        bash \
        git \
        make \
        gcc \
        g++ \
        cmake \ 
        swig \
        jq \
        musl-dev && \
    git clone https://github.com/casadi/casadi.git --depth 1 --branch ${CASADI_BRANCH} ${CASADI_DIR} && \
    cd ${CASADI_DIR} && \
    mkdir build && cd build && \
    cmake -DWITH_PYTHON=ON .. && \
    rm -rf ${CASADI_DIR}} && \
    # onnx
    git clone https://github.com/Microsoft/onnxruntime --depth 1 --branch ${ONNXRUNTIME_BRANCH} ${ONNXRUNTIME_DIR} && \
    cd /onnxruntime && \
    ./build.sh --parallel --build_wheel --enable_pybind \
        --cmake_extra_defines DPYTHON_EXECUTABLE=python \
        --cmake_extra_defines CMAKE_CXX_FLAGS=-Wno-deprecated-copy \
        --skip_tests && \
    cd .. && \
    rm -rf ${ONNXRUNTIME_DIR} && \
    git clone https://github.com/commaai/openpilot.git --depth 1 $OPEN_PILOT_DIR && \
    cd ${OPEN_PILOT_DIR} && \
    git submodule update --init --depth 1 && \
    pip install --upgrade pip && \
    pip install \
        scons && \
    jq -r '.default \
            | to_entries[] \
            | .key + .value.version' \
        ./Pipfile.lock > /requirements.txt && \
    cat /requirements.txt | grep -v "casadi" | xargs pip install && \
    # pipenv --python python install --clear && \
    # scons -u -j$(nproc) && \
    apk del \
        .build-deps && \
    pipenv --clear && \
    pip uninstall scons pipenv && \
    mkdir -p $OPENPILOT_ALPINE_PATH

COPY . $OPENPILOT_ALPINE_PATH
COPY ./docker/entrypoint.sh /entrypoint.sh

WORKDIR $OPENPILOT_ALPINE_PATH

RUN pip install -r ./requirements.txt && \
    python setup.py install

ENTRYPOINT ["/entrypoint.sh"]


CMD ["openpilot-alpine"]