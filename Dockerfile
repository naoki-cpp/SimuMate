FROM debian:latest

# Create User
# username: docker
# password: docker
ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
  && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd
# change user
USER ${DOCKER_USER}

RUN sudo apt update -y
RUN sudo apt install -y wget curl git build-essential gfortran mpich python3 python3-pip

# Quantum Espresso, ASE
RUN cd ${HOME} && \
	git clone https://github.com/QEF/q-e.git && \
	cd q-e && \
	./configure --with-internal-blas --with-internal-lapack && \
	make all && \
	echo "export PATH=${HOME}/q-e/bin:$PATH" >> ~/.bashrc && \
	mkdir /usr/share/espresso && mkdir /usr/share/espresso/pseudo && \
	echo "export ESPRESSO_PSEUDO=/usr/share/espresso/pseudo" >> ~/.bashrc
COPY pseudourl /usr/share/espresso/pseudo/
RUN cd /usr/share/espresso/pseudo && \
	wget -i pseudourl

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
	python3 -m pip install --upgrade --user ase
