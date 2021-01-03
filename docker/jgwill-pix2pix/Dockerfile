#FROM guillaumeai/tf:1.4.1  # CUDA WONT LOAD
#FROM brannondorsey/pix2pix  NOT WORKING
FROM jorgesece/pix2pix-tensorflow

RUN apt update
RUN apt install vim git curl -y
RUN pip install  pyqtgraph
RUN apt install xterm -y
RUN apt-get install python-pyqt5 -y
RUN  apt-get install pyqt5-dev-tools -y
RUN apt-get install qttools5-dev-tools -y
RUN apt-get install python-opencv -y
RUN pip install --upgrade pip
RUN pip install httpserver
RUN pip install --upgrade pip
RUN  pip install tensorflowjs
# Fix the export in server/tools/...
RUN pip install backports.tempfile

#RUN pip install  pyqt5  
#jgwill/pix2pix:gia-pix2pix-tensorflow-memo
#RUN git clone 
WORKDIR /model

#COPY . .
RUN git clone https://github.com/GuillaumeAI/gia-pix2pix-tensorflow-memo.git .
RUN git clone https://github.com/GuillaumeAI/gia-memo-webcam-pix2pix-tensorflow.git /webcammemo