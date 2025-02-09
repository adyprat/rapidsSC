ARG BASE_IMAGE=rapidsai/rapidsai:22.04-cuda11.4-runtime-ubuntu20.04-py3.8

FROM ${BASE_IMAGE}
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git python3-setuptools python3-pip build-essential libcurl4-gnutls-dev \
    zlib1g-dev rsync vim cmake tabix

RUN git clone \
    https://github.com/cjnolet/AtacWorks.git atacworks


RUN /opt/conda/envs/rapids/bin/pip install \
    scanpy==1.8.1 wget pytabix dash-daq \
    dash-html-components dash-bootstrap-components dash-core-components

RUN cd atacworks && /opt/conda/envs/rapids/bin/pip install .

WORKDIR /workspace
ENV HOME /workspace
RUN git clone \
    https://github.com/clara-parabricks/rapids-single-cell-examples.git \
    rapids-single-cell-examples

ARG GIT_BRANCH=master
RUN cd rapids-single-cell-examples && git checkout ${GIT_BRANCH} && git pull
WORKDIR /data
RUN cd /data
CMD jupyter-lab \
		--no-browser \
		--allow-root \
		--port=8888 \
		--ip=0.0.0.0 \
		--notebook-dir=/workspace \
		--NotebookApp.password="" \
		--NotebookApp.token="" \
		--NotebookApp.password_required=False


# install nvidia-docker first https://docs.nvidia.com/cuda/wsl-user-guide/index.html
# ENV LD_LIBRARY_PATH /usr/local/cuda-10.2/compat
# RUN echo "export PATH=$PATH:/workspace/data" >> ~/.bashrc
# docker build -t rapidsc:1.1 .
# docker run --gpus 0 --name scDock -p 8992:8992 -v /mnt/??/??/:/data rapidsc:1.0
