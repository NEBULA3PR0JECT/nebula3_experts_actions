ARG BASE_IMAGE=nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
FROM $BASE_IMAGE

# To use this Dockerfile:
# 1. `nvidia-docker build -t step:v0 .`
# 2. `nvidia-docker run -it --name step step:v0`


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
	libpng-dev libjpeg-dev ca-certificates ffmpeg libsm6 libxext6 \
	python3-dev build-essential pkg-config git curl wget automake libtool libegl1-mesa-dev && \
  rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "source activate base" > ~/.bashrc

SHELL ["/bin/bash", "-c"]
ARG CONDA_ENV=step
RUN conda --version \ 
    && conda create --name ${CONDA_ENV} python=3.7
RUN conda init
RUN source activate ${CONDA_ENV} && conda update -n base -c defaults conda \
    && pip3 install scipy==1.6.0 && pip3 install opencv-python \
    && pip3 install tqdm && pip3 install numpy && conda install ninja -y \
    && pip install torch==1.10.1+cu102 torchvision==0.11.2+cu102 torchaudio==0.10.1 -f https://download.pytorch.org/whl/torch_stable.html

ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

RUN pip install gdown

RUN source activate ${CONDA_ENV} && pip3 install cython && pip3 install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

COPY run.sh .
RUN chmod a+x run.sh
# CMD ./run.sh


