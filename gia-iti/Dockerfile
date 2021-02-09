FROM  jgwill/pix2pix:gia-pix2pix-tensorflow-memo


ENV DEBIAN_FRONTEND noninteractive
RUN apt install imagemagick -y
#RUN apt install python3-pip -y

####
WORKDIR /model
RUN git pull
RUN echo "---"
COPY run_iti_inference.sh .
COPY split.sh .
COPY starting.sh .
COPY pix2pix.py .

RUN chmod 777 *sh

ENTRYPOINT ["/bin/bash","run_iti_inference.sh"]

