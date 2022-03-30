

FROM  python:3.7-alpine

LABEL maintainer=achillesrasquinha@gmail.com

ENV OPENPILOT_ALPINE_PATH=/usr/local/src/openpilot-alpine

RUN apk add --no-cache \
        bash \
        git \
    && mkdir -p $OPENPILOT_ALPINE_PATH

COPY . $OPENPILOT_ALPINE_PATH
COPY ./docker/entrypoint.sh /entrypoint.sh

WORKDIR $OPENPILOT_ALPINE_PATH

RUN pip install -r ./requirements.txt && \
    python setup.py install

ENTRYPOINT ["/entrypoint.sh"]

CMD ["openpilot-alpine"]