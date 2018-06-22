# https://hub.docker.com/r/nvidia/cuda/
FROM nvidia/cuda:9.0-base
#FROM ubuntu:18.04

# https://github.com/ContinuumIO/docker-images/blob/master/miniconda/Dockerfile
# Install miniconda
ENV PATH /opt/conda/bin:$PATH

# install dependencies
RUN apt-get update --fix-missing && apt-get install -y \
        bash-completion \
        bzip2 \
        ca-certificates \
        ccache \
        default-jdk \
        file \
        fonts-texgyre \
        g++ \
        gfortran \
        git \
        gsfonts \
        libblas-dev \
        libbz2-1.0 \
        libbz2-dev \
        libcairo2-dev \
        libcurl3 \
        libcurl4-openssl-dev \
        libglib2.0-0 \
        # libicu57 \
        libicu-dev \
        #libjpeg-turbo \
        libjpeg-dev \
        liblzma5 \
        liblzma-dev \
        libopenblas-dev \
        libpango1.0-dev \
        libpangocairo-1.0-0 \
        libpcre3 \
        libpcre3-dev \
        libpng16-16 \
        libpng-dev \
        #libreadline7 \
        libreadline-dev \
        libsm6 \
        libtiff5 \
        libtiff5-dev \
        libx11-dev \
        libxext6 \
        libxrender1 \
        libxt-dev \
        locales \
        make \
        mercurial \
        perl \
        subversion \
        tcl8.6-dev \
        texinfo \
        texlive-extra-utils \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-latex-recommended \
        tk8.6-dev \
        unzip \
        wget \
        x11proto-core-dev \
        xauth \
        xfonts-base \
        xvfb \
        zip \
        zlib1g \
        zlib1g-dev && \
    apt-get clean

# download and install miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# install jupyter elements
RUN conda update --yes --all && \
    conda install --yes \
        jupyter_console \
        jupyterlab

# install python elements
run conda install --yes \
        seaborn \
        scikit-learn \
        pandas \
        joblib \
        tensorflow-gpu \
        pandas-profiling

run conda install --yes -c conda-forge \
        catboost

# install R elements
run conda install --yes -c r \
        r-irkernel


# copy config file for jupyter and set permissions
COPY jupyter_notebook_config.py /root/.jupyter/

RUN chmod 777 /root/.jupyter/jupyter_notebook_config.py

RUN mkdir /work

WORKDIR "/work"

CMD [ "/bin/bash" ]
