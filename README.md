# nebula3_experts_actions

# How to use with DOCKER
Run the following commands to use Docker

1. nvidia-docker build -t step:v0 .
2. docker run -it --gpus all step:v0
When you are inside the container run the following command:
3. ./run.sh

In order to run python scripts inside the container, make sure conda environment is activated first.
conda activate step
