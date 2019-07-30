FROM python:3.7.4-slim-buster

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install build-essential \
                          git \
                          openssh-server \
                          wget \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /tmp
RUN git clone https://github.com/RasaHQ/rasa.git

# install dev requirements
# see https://github.com/RasaHQ/rasa#development-internals
WORKDIR /tmp/rasa

RUN pip install -r requirements-dev.txt \
    && pip install -r requirements-docs.txt

# stuff for running the tests
# see https://github.com/RasaHQ/rasa#running-the-tests
ENV PIP_USE_PEP517 false
RUN pip install -e .

# stuff to build livedocs
# see https://stackoverflow.com/questions/36394101/pip-install-locale-error-unsupported-locale-setting for details
ENV LC_ALL C

# set up openssh server
# from https://docs.docker.com/engine/examples/running_ssh_service/
RUN mkdir /var/run/sshd
# note the root password you set!
RUN echo 'root:abc123' | chpasswd

# from https://stackoverflow.com/questions/42653676/how-to-configure-debian-sshd-for-remote-debugging-in-a-docker-container
# and https://unix.stackexchange.com/questions/79449/cant-ssh-into-remote-host-with-root-password-incorrect
# note: python uses debian as the OS
RUN sed -i 's/#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

WORKDIR /app
RUN rm -r /tmp/rasa/*

# Expose port for ssh
EXPOSE 22
# Expose port for livedocs
EXPOSE 8000
CMD ["/usr/sbin/sshd", "-D"]
