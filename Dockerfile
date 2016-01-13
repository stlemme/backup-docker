FROM ubuntu:14.04

MAINTAINER Stefan Lemme <stefan.lemme@dfki.de>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ENV BKP_CONTENT /content-storage
ENV BKP_STORAGE /backup-storage
ENV BKP_SNAPSHOT "bkp.snapshot"

ENV BKP_PREFIX "bkp"
ENV BKP_LOCATION ""

RUN mkdir $BKP_CONTENT $BKP_STORAGE

ADD bootstrap.sh /bootstrap.sh
RUN chmod a+x /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]

VOLUME ["$BKP_CONTENT", "$BKP_STORAGE"]

CMD ["incremental"]
