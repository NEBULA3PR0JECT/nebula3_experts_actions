#!/bin/bash


ENV_NAME="step"
ACTION_DETECTOR_DIR="/actions/stepwrapper"

APEX_PATH_EXPORT="export PATH=/usr/local/cuda/bin:\$PATH"
APEX_LD_LIB_EXPORT="export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH"
# cd ..
# PWD = pwd

function install_step {
    # install dependencies
    # conda install ninja -y
    # python -m pip install torch==1.10.1+cu102 torchvision==0.11.2+cu102 torchaudio==0.10.1 -f https://download.pytorch.org/whl/torch_stable.html
    # python -m pip install opencv-python tqdm requests

    # pushd $PWD$ACTION_DETECTOR_DIR

    # (Optional) You may skip this. Install APEX for half-precision training:
    # git clone https://github.com/NVIDIA/apex.git  #TODO fork
    # pushd apex/
    # python setup.py install --cuda_ext --cpp_ext
    # popd  # apex/

    # install STEP package
    if [ -d "STEP/" ] 
    then    
        rm -rf STEP/
    git clone https://github.com/NEBULA3PR0JECT/STEP.git
    pushd STEP/
    mkdir -p pretrained/
    pushd pretrained/
    gdown https://drive.google.com/uc?id=1hIzrTzR50pYwLLzu_5GpmEGY4Q-e1-BX
    popd
    python setup.py build develop
    python demo.py  # test STEP setup
    popd  # STEP/



}


# function install_remote {
#     # install dependencies
#     python -m pip install python-arango boto3 gdown
# }


function install_env {
    echo "======================================="
    echo "===== Installing STEP Environment ====="
    echo "======================================="
    # remove env if exists
    # conda env remove -n $ENV_NAME

    # install and activate env
    # conda create -n $ENV_NAME python=3.7 -y

    conda activate $ENV_NAME

    # install core
    install_step
    # install_remote

    # deactivate env
    # conda deactivate
    echo "============================================"
    echo "===== Environment Installed ====="
    echo "============================================"
}


function load_base_env {
    # load base directly
    source "$(dirname $(dirname $(which conda)))/bin/activate"

    # check for errors
    if [[ "$?" != "0" ]] || [[ $CONDA_DEFAULT_ENV != "base" ]]; then
        echo "ERROR: issue loading conda. please run with conda \"base\" env"
        exit 1
    fi
}


pushd "$(dirname "$0")"  # go to current script directory

if [ ! -d "STEP/" ] || [ ! -d "/notebooks/STEP/" ]
then
# run everything from base
load_base_env

# install environment
install_env

popd  # "$(dirname "$0")"
else
    echo "STEP alraedy exists. Skipping installation."
fi

# sleep infinity

# prepare environment variables in .zshrc
# if grep -Fxq "$APEX_PATH_EXPORT" ~/.zshrc
# then
#     echo "\"$APEX_PATH_EXPORT\" already in ~/.zshrc"
# else
#     eval $APEX_PATH_EXPORT
#     echo $APEX_PATH_EXPORT >> ~/.zshrc
#     echo "added \"$APEX_PATH_EXPORT\" to ~/.zshrc"
# fi

# if grep -Fxq "$APEX_LD_LIB_EXPORT" ~/.zshrc
# then
#     eval $APEX_LD_LIB_EXPORT
#     echo "\"$APEX_LD_LIB_EXPORT\" already in ~/.zshrc"
# else
#     echo $APEX_LD_LIB_EXPORT >> ~/.zshrc
#     echo "added \"$APEX_LD_LIB_EXPORT\" to ~/.zshrc"
# fi