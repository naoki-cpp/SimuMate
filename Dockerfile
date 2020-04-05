FROM debian:latest
RUN apt-get update -y
RUN apt-get install -y wget curl git build-essential gfortran mpich python3

RUN git clone https://github.com/QEF/q-e.git && \
	cd q-e && \
	./configure --with-internal-blas --with-internal-lapack && \
	make all && \
	echo "export PATH=${HOME}/q-e/bin:$PATH" > ~/.bashrc && \
	mkdir /usr/share/espresso && mkdir /usr/share/espresso/pseudo && \
	echo "export ESPRESSO_PSEUDO=/usr/share/espresso/pseudo" > ~/.bashrc
COPY pseudourl /usr/share/espresso/pseudo/
RUN cd /usr/share/espresso/pseudo && \
	wget -i pseudourl