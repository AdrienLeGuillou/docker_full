# https://hub.docker.com/r/nvidia/cuda/
FROM nvidia/cuda:9.0-base
#FROM ubuntu:18.04

# https://github.com/ContinuumIO/docker-images/blob/master/miniconda/Dockerfile
# Install miniconda 
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion \
# R dependencies
    libxt-dev && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN conda update --yes --all && \
    conda install --yes \
        jupyter_console \
        jupyterlab 

run conda install --yes \
        seaborn \
        scikit-learn \
        pandas \
        joblib \
        tensorflow-gpu \
        pandas-profiling


run conda install --yes -c conda-forge \
        catboost

run conda install --yes -c r \
        r-irkernel


# copy config file for jupyter and set permissions
COPY jupyter_notebook_config.py /root/.jupyter/

RUN chmod 777 /root/.jupyter/jupyter_notebook_config.py

RUN mkdir /work

WORKDIR "/work"

CMD [ "/bin/bash" ]

