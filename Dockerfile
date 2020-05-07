FROM debian:latest

# Create User
# username: docker
# password: docker
ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
  && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

# as su
RUN apt update -y && apt install -y \
	wget sudo \
# for QuantumEspresso and ASE
	curl git build-essential gfortran mpich python3 python3-distutils \
# for OOMMF
	tk-dev tcl-dev \ 
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	curl -kL https://bootstrap.pypa.io/get-pip.py | python3
RUN apt install -y 
# for pseudopotential
RUN mkdir /usr/share/espresso && mkdir /usr/share/espresso/pseudo
COPY pseudourl /usr/share/espresso/pseudo/
RUN cd /usr/share/espresso/pseudo && \
	wget -i pseudourl

# change user
USER ${DOCKER_USER}
RUN mkdir /home/${DOCKER_USER}/.local
ENV PATH $PATH:/home/${DOCKER_USER}/.local/bin
# Quantum Espresso, ASE
RUN cd /home/${DOCKER_USER}/.local && \
	git clone https://github.com/QEF/q-e.git && \
	cd q-e && \
	./configure --with-internal-blas --with-internal-lapack && \
	make all
ENV PATH $PATH:/home/${DOCKER_USER}/.local/q-e/bin
ENV ESPRESSO_PSEUDO '/usr/share/espresso/pseudo'

RUN pip3 install --upgrade --user  jupyter ase && \
	ase test

#OOMMF
RUN cd /home/${DOCKER_USER}/.local && \
	wget https://math.nist.gov/oommf/dist/oommf20a2_20190930.tar.gz && \
	tar -zxvf  oommf20a2_20190930.tar.gz && \
	rm oommf20a2_20190930.tar.gz && \
	cd oommf && \
	tclsh oommf.tcl +platform && \
	./oommf.tcl pimake distclean && \
	./oommf.tcl pimake upgrade && \
	./oommf.tcl pimake && \
	echo "alias oommf='tclsh ~/.local/oommf/oommf.tcl'" >>  ~/.bashrc
