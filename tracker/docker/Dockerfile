ARG CUDA="10.2"
ARG CUDNN="7"

# To use this Dockerfile:
# 1. `nvidia-docker build -t detectron2:v0 .`
# 2. `nvidia-docker run -it --name detectron2 detectron2:v0`
# 
# To enable GUI support (Linux):
# 1. Grant the container temporary access to your x server (will be reverted at reboot of your host): 
#    `xhost +local:`docker inspect --format='{{ .Config.Hostname }}' detectron2``
# 2. `nvidia-docker run -it --name detectron2 --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" detectron2:v0`


FROM nvcr.io/nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# install basics
RUN apt-get update -y && apt-get install -y \
        libglib2.0-0 libsm6 libxext6 libxrender-dev \
        libpng-dev libjpeg-dev python3-opencv ca-certificates \
        python3-dev build-essential pkg-config git curl wget automake libtool git && \
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

RUN conda update -n base -c defaults conda

SHELL ["/bin/bash", "-c"]
ARG CONDA_ENV=detectron2
RUN conda --version \ 
    && conda create --name ${CONDA_ENV} python=3.7
RUN conda init
RUN source activate ${CONDA_ENV}


RUN pip install ninja yacs cython matplotlib jupyter tqdm

# Install PyTorch
RUN conda install pytorch==1.9.0 torchvision==0.10.0 torchaudio==0.9.0 cudatoolkit=10.2 -c pytorch

RUN pip install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

RUN git clone https://github.com/facebookresearch/detectron2 /detectron2_repo
ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
RUN pip install -e /detectron2_rep

WORKDIR /detectron2_repo

# run it, for example:
# wget http://images.cocodataset.org/val2017/000000439715.jpg -O input.jpg
# python3 demo/demo.py  \
	#--config-file configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml \
	#--input input.jpg --output outputs/ \
	#--opts MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl