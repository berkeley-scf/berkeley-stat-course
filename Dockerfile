# https://github.com/rocker-org/rocker-versioned2/wiki/r-ver_65a8a3dc3323
FROM rocker/rstudio:4.4.2

ENV NB_USER=rstudio
ENV NB_UID=1000
ENV CONDA_DIR=/srv/conda

# Set ENV for all programs...
ENV PATH=${CONDA_DIR}/bin:$PATH

# Pick up rocker's default TZ
ENV TZ=Etc/UTC

# And set ENV for R! It doesn't read from the environment...
RUN echo "TZ=${TZ}" >> /usr/local/lib/R/etc/Renviron.site
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron.site

# Add PATH to /etc/profile so it gets picked up by the terminal
RUN echo "PATH=${PATH}" >> /etc/profile
RUN echo "export PATH" >> /etc/profile

ENV HOME=/home/${NB_USER}

WORKDIR ${HOME}

# texlive-xetex pulls in texlive-latex-extra > texlive-latex-recommended
# We use Ubuntu's TeX because rocker's doesn't have most packages by default,
# and we don't want them to be downloaded on demand by students.
# tini is necessary because it is our ENTRYPOINT below.
RUN apt-get update && \
    apt-get -qq install \
            curl \
            less \
            rsync \
            tini \
            fonts-symbola \
            libzmq5 \
            pandoc \
            texlive-xetex \
            texlive-fonts-recommended \
            texlive-fonts-extra \
            texlive-plain-generic \
            > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# While quarto is included with rocker/verse, we sometimes need different
# versions than the default. For example a newer version might fix bugs.
ENV _QUARTO_VERSION=1.6.40
RUN curl -L -o /tmp/quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v${_QUARTO_VERSION}/quarto-${_QUARTO_VERSION}-linux-amd64.deb
RUN apt-get install /tmp/quarto.deb && \
    rm -f /tmp/quarto.deb

RUN install -d -o ${NB_USER} -g ${NB_USER} ${CONDA_DIR}

USER ${NB_USER}

COPY --chown=1000:1000 install-miniforge.bash /tmp/install-miniforge.bash
RUN /tmp/install-miniforge.bash
RUN rm -f /tmp/install-miniforge.bash

COPY environment.yml /tmp/environment.yml
RUN env XDG_CACHE_HOME=/tmp \
    mamba env update -p ${CONDA_DIR} -f /tmp/environment.yml && \
	mamba clean -afy

# Install IRKernel
COPY install.R /tmp
RUN Rscript /tmp/install.R

ENTRYPOINT ["tini", "--"]
