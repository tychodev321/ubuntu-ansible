# https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

LABEL maintainer=""

ENV PYTHON_VERSION=3.10.10 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    POETRY_VERSION=1.2.2 \
    ANSIBLE_VERSION=7.0.0 \
    ANSIBLE_LINT_VERSION=6.9.0

# Install Base Tools
RUN apt update -y && apt upgrade -y \
    && apt install -y unzip \
    && apt install -y gzip \
    && apt install -y tar \
    && apt install -y wget \
    && apt install -y curl \
    && apt install -y git \
    && apt install -y sudo \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt update -y && apt upgrade -y \
    && apt install -y python3-pip \
    && apt install -y python3-venv \
    && apt install -y python3-setuptools \
    && apt install -y python-is-python3 \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN python -m pip install ansible==${ANSIBLE_VERSION} \ 
    && python -m pip install "ansible-lint[yamllint]==${ANSIBLE_LINT_VERSION}"

RUN echo "ansible version: $(ansible --version | head -n 1)" \
    && echo "ansible-playbook version: $(ansible-playbook --version | head -n 1)" \
    && echo "ansible-lint version: $(ansible-lint --version | head -n 1)" \
    && echo "git version: $(git --version)" \
    && echo "python version: $(python --version)" \
    && echo "pip version: $(python -m pip --version)"

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
