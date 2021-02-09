FROM  jgwill/pix2pix:gia-pix2pix-tensorflow-memo


ENV DEBIAN_FRONTEND noninteractive
RUN apt install imagemagick -y

####
WORKDIR /work
COPY run_iti_inference.sh .
COPY split.sh .
COPY starting.sh .
RUN chmod 777 *sh

ENTRYPOINT ["/bin/bash","run_iti_inference.sh"]

