FROM ubuntu:20.04


RUN apt-get update && \
    apt-get install -y tree

COPY app_folder ./parent/app

RUN mkdir /parent/merged

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
