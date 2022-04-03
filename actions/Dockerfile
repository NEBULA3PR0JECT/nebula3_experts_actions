ARG CUDA="10.1"
ARG CUDNN="7"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu16.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install basics
RUN apt-get update -y \
 && apt-get install -y apt-utils git curl ca-certificates bzip2 cmake tree htop bmon iotop g++ libgl1-mesa-glx libgtk2.0-dev libsm6 libxext6 libxrender1

# Install Miniconda
# Install Miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get install wget

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

RUN conda install -y ipython
RUN pip install ninja yacs cython matplotlib tqdm

# Install PyTorch
RUN conda install pytorch torchvision cudatoolkit=${CUDA} -c pytorch \
 && conda clean -ya
RUN pip install pillow==6.1
RUN conda install -c conda-forge opencv

# install pycocotools
RUN git clone https://github.com/cocodataset/cocoapi.git \
 && cd cocoapi/PythonAPI \
 && python setup.py build_ext install

# install apex
RUN python -c 'import torch; print(torch.__version__);from torch.utils.cpp_extension import CUDA_HOME; print(torch.cuda.is_available(), CUDA_HOME)'
RUN git clone https://github.com/NVIDIA/apex.git \
 && cd apex \
 && sed -i 's/check_cuda_torch_binary_vs_bare_metal(torch.utils.cpp_extension.CUDA_HOME)/pass/g' setup.py \
 && python3 setup.py install --cuda_ext --cpp_ext

# install PyTorch Detection
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
RUN git clone https://github.com/facebookresearch/maskrcnn-benchmark.git \
 && cd maskrcnn-benchmark \
 && sed -i -e 's/torch.cuda.is_available()/True/g' setup.py \
 && python setup.py build develop \
 && sed -i -e 's/True/torch.cuda.is_available()/g' setup.py 

WORKDIR /maskrcnn-benchmark