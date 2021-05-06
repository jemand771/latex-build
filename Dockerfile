FROM ubuntu:20.04

# debian packages: tzdata, texlive, python, inkscape
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    apt-get install -y --no-install-recommends apt-utils \
    tzdata \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-lang-german \
    biber \
    texlive-bibtex-extra \
    python3 \
    python3-pip \
    inkscape

# pygments for syntax highlighting via minted
RUN pip3 install Pygments

ADD https://raw.githubusercontent.com/aclements/latexrun/master/latexrun /latexrun.py
# allow non-root container run
RUN chmod 644 /latexrun.py
WORKDIR /latex

# settings (used in compile.sh)
ENV WARNINGS -Wall
ENV DELETE_TEMP=
ENV CLEAN_BUILD=
ENV TARGET main

COPY compile.sh /

CMD ["bash", "/compile.sh"]