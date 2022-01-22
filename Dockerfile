FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4
# FROM redhat/ubi8/ubi-minimal:8.4

LABEL maintainer=""

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    ANSIBLE_VERSION=2.9

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

RUN microdnf update -y \
    && microdnf install -y python39 \
    && microdnf install -y git \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

RUN pip3 install ansible && pip3 install "ansible-lint[yamllint]"

RUN ansible --version && ansible-playbook --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
