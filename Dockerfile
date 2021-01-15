FROM ubuntu:20.04

RUN apt-get update
# fix for delayed debconf
RUN apt-get install -y --no-install-recommends apt-utils
# fix for tzdata package:
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get install tzdata
# texlive stuff and things
RUN apt-get install -y texlive-latex-base
RUN apt-get install -y texlive-fonts-recommended
#RUN apt-get install -y texlive-fonts-extra
RUN apt-get install -y texlive-latex-extra
# support for babel ngerman
RUN apt-get install -y texlive-lang-german
# bibtex
RUN apt-get install -y biber
RUN apt-get install -y texlive-bibtex-extra
# pygmentize
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install Pygments
# inkscape
RUN apt-get install -y inkscape
# compilation script and working directory
# there might drastically change in the future
COPY compile.sh /
RUN mkdir /latex
WORKDIR /latex
CMD ["bash", "/compile.sh"]