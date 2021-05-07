FROM ubuntu:20.04

# debian packages: tzdata, texlive, python, inkscape
# python packages: Pygments
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    apt-get install -y --no-install-recommends \
    apt-utils \
    biber \
    inkscape \
    python3 \
    python3-pip \
    texlive-bibtex-extra \
    texlive-fonts-recommended \
    texlive-lang-german \
    texlive-latex-base \
    texlive-latex-extra \
    tzdata \
&& \
    pip3 install \
    Pygments \
&& \
    apt-get purge -y --auto-remove \
    python3-pip \
&& \
    rm -rf /var/lib/apt/lists/*

ADD https://raw.githubusercontent.com/aclements/latexrun/master/latexrun /latexrun.py
# allow non-root container run
RUN chmod 644 /latexrun.py
WORKDIR /latex

# settings (used in compile.sh)
ENV WARNINGS -Wall
ENV DELETE_TEMP=
ENV CLEAN_BUILD=
ENV TARGET main
ENV BUILD_DIRECTORY_RELATIVE .build

COPY compile.sh /

CMD ["bash", "/compile.sh"]