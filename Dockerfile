FROM debian:latest

# use bash
SHELL ["/bin/bash", "-c"]
# Create User
# username: docker
# password: docker
ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
  && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

# as su
RUN apt update -y
RUN apt install -y wget curl git build-essential gfortran mpich python3 python3-distutils && \
	curl -kL https://bootstrap.pypa.io/get-pip.py | python3
RUN apt install -y sudo
# for OOMMF
RUN apt install -y tk-dev tcl-dev
# for pseudopotential
RUN mkdir /usr/share/espresso && mkdir /usr/share/espresso/pseudo
COPY pseudourl /usr/share/espresso/pseudo/
RUN cd /usr/share/espresso/pseudo && \
	wget -i pseudourl

# change user
USER ${DOCKER_USER}
RUN mkdir ${HOME}/.local && \
	echo export PATH='${HOME}/.local/bin:$PATH' >> ~/.bashrc && \
	source ~/.bashrc
# Quantum Espresso, ASE
RUN cd ${HOME}/.local && \
	git clone https://github.com/QEF/q-e.git && \
	cd q-e && \
	./configure --with-internal-blas --with-internal-lapack && \
	make all && \
	echo export PATH='${HOME}/.local/q-e/bin:$PATH' >> ~/.bashrc && \
	echo "export ESPRESSO_PSEUDO=/usr/share/espresso/pseudo" >> ~/.bashrc

RUN pip3 install --upgrade --user  jupyter ase && \
	ase test

#OOMMF
RUN cd ${HOME}/.local && \
	wget https://math.nist.gov/oommf/dist/oommf20a2_20190930.tar.gz && \
	tar -zxvf  oommf20a2_20190930.tar.gz && \
	rm oommf20a2_20190930.tar.gz && \
	cd oommf && \
	tclsh oommf.tcl +platform && \
	./oommf.tcl pimake distclean && \
	./oommf.tcl pimake upgrade && \
	./oommf.tcl pimake && \
	echo "alias oommf='tclsh ${HOME}/.local/oommf/oommf.tcl'" >>  ~/.bashrc
