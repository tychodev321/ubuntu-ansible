FROM registry.access.redhat.com/ubi9/ubi-minimal:9.0.0
# FROM redhat/ubi9/ubi-minimal:9.0.0

LABEL maintainer=""

ENV PYTHON_VERSION=3 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    ANSIBLE_VERSION=7.0.0 \
    ANSIBLE_LINT_VERSION=6.9.0

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

RUN microdnf repolist enabled

RUN microdnf update -y \
    && microdnf install -y python${PYTHON_VERSION} \
    && microdnf install -y python${PYTHON_VERSION}-devel \
    && microdnf install -y python${PYTHON_VERSION}-setuptools \
    && microdnf install -y python${PYTHON_VERSION}-pip \
    && microdnf install -y git \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

RUN python3 -m pip install ansible==${ANSIBLE_VERSION} \ 
    && python3 -m pip install "ansible-lint[yamllint]==${ANSIBLE_LINT_VERSION}"

RUN echo "ansible version: $(ansible --version)" \
    && echo "ansible-playbook version: $(ansible-playbook --version | head -n 1)" \
    && echo "ansible-lint version: $(ansible-lint --version | head -n 1)" \
    && echo "git version: $(git --version)" \
    && echo "python version: $(python3 --version)" \
    && echo "pip version - $(python3 -m pip --version)"

USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
