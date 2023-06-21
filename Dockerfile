FROM python:3.9-bullseye

MAINTAINER Mateo Boudet <mateo.boudet@inrae.fr>

RUN echo "deb https://depot.galaxyproject.org/apt/ $(bash -c '. /etc/os-release; echo ${VERSION_CODENAME:-bullseye}') main" | tee /etc/apt/sources.list.d/galaxy-depot.list
RUN apt-key adv --keyserver keyserver.ubuntu.com:80 --recv-keys 18381AC8832160AF

RUN apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install \
     git slurmd slurmctld slurm-client libslurm-dev munge locales locales-all slurm-drmaa1 \
 && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
RUN sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG

# Some env var for slurm only
ADD requirements.txt /tmp/requirements.txt
ADD slurm.conf /tmp/slurm.conf

RUN pip install -U pip setuptools nose build && \
    pip install -r /tmp/requirements.txt

ENV MAX_CPUS=1 \
    MAX_MEM=4000 \
    DRMAA_LIBRARY_PATH="/usr/lib/slurm-drmaa/lib/libdrmaa.so.1"

ADD entrypoint.sh /
ADD /scripts/ /scripts/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
