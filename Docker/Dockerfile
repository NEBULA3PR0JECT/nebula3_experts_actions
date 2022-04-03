ARG BASE_IMAGE=nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
FROM $BASE_IMAGE

# change the downloading source
RUN sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list
RUN sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu\//g' /etc/apt/sources.list

# To use this Dockerfile:
# 1. `nvidia-docker build -t step:v0 .`
# 2. `nvidia-docker run -it --name step step:v0`


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
	libpng-dev libjpeg-dev ca-certificates ffmpeg libsm6 libxext6 \
	python3-dev build-essential pkg-config git curl wget automake libtool libegl1-mesa-dev && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    cmake \
    curl \
    libsm6 \
    libxext6 \
    libxrender-dev


ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics


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

# install apex for GPU
# RUN git clone https://github.com/NVIDIA/apex.git  #TODO fork
# RUN source activate ${CONDA_ENV} && cd apex && pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" .
#

# ENV PATH /opt/conda/bin:$PATH
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# RUN apt-get update && \
#     apt-get -y install gcc mono-mcs
RUN pip install gdown

RUN source activate ${CONDA_ENV} && pip3 install cython && pip3 install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

# ENV PATH="/usr/local/cuda-10.2/bin:$PATH"
# ENV LD_LIBRARY_PATH="/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH"
ENV CUDA_HOME="/usr/local/cuda-10.2"
LABEL com.nvidia.volumes.needed="nvidia_driver"
# ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
# ENV PATH=/usr/local/cuda/bin:\$PATH
# ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH

# RUN git clone https://github.com/AnaRhisT94/STEP.git

# RUN source activate ${CONDA_ENV} && python STEP/setup.py build develop
# RUN python STEP/demo.py  # test STEP setup

COPY run.sh .
RUN chmod a+x run.sh
# CMD ./run.sh


