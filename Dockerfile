FROM ubuntu:22.10
WORKDIR /tmp
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    apt-get install -y --no-install-recommends \
    automake \
    autotools-dev \
    build-essential \
    ca-certificates \
    git \
    libwxgtk3.0-gtk3-dev \
    libpoppler-glib-dev \
    poppler-utils
RUN git clone https://github.com/vslavik/diff-pdf.git
WORKDIR /tmp/diff-pdf
RUN ./bootstrap
RUN ./configure
RUN make -j4

FROM ubuntu:22.10

COPY --from=0 /tmp/diff-pdf/diff-pdf /bin/diff-pdf
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    apt-get install -y --no-install-recommends \
    apt-utils \
    biber \
    inkscape \
    libwxgtk3.0-gtk3-dev \
    python-is-python3 \
    python3.10 \
    python3-pip \
    texlive-bibtex-extra \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-lang-german \
    texlive-latex-extra \
    texlive-plain-generic \
    tzdata \
    xvfb \
&& \
    pip3 install \
    Pygments \
&& \
    apt-get purge -y --auto-remove \
    python3-pip \
&& \
    rm -rf /var/lib/apt/lists/*

# NOTE on python-is-python3 minted expects "python" in PATH (not "python3")
# without this, things like autogobble with \inputminted break
# https://github.com/alexpovel/latex-extras-docker/blob/5429a82ef415c2e9eda0c20f71e7df63b51621e9/Dockerfile#L80-L87

# install custom pygments lexers
WORKDIR /usr/local/lib/python3.10/dist-packages/pygments/lexers
COPY pygments-lexers/* .
RUN python3 _mapping.py

ADD https://raw.githubusercontent.com/aclements/latexrun/master/latexrun /latexrun.py
# allow non-root container run
RUN chmod 644 /latexrun.py

# settings (used in compile.sh)
ENV BIND_PATH /latex
ENV BUILD_DIRECTORY .build
ENV CLEAN_BUILD=
ENV DELETE_TEMP=
ENV DISABLE_DIFFPDF=
ENV DISABLE_PYTHONTEX=
ENV DISABLE_SYNCTEX=
ENV HOST_PATH=
ENV TARGET main
ENV WARNINGS -Wall

WORKDIR $BIND_PATH
COPY compile.sh /

CMD ["bash", "/compile.sh"]
