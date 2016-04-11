FROM python:3.5

MAINTAINER Eugene Kazakov <eugene.a.kazakov@gmail.com>

ENV OPENCV_VERSION 3.1.0
ENV YASM_VERSION 1.3.0

COPY ./docker-build.sh /
RUN /docker-build.sh

