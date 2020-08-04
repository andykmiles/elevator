# Update the VARIANT arg in devcontainer.json to pick a Python version: 3, 3.8, 3.7, 3.6
ARG VARIANT=3
FROM python:${VARIANT}

# This Dockerfile adds a non-root user with sudo access. Update the “remoteUser” property in
# devcontainer.json to use it. More info: https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common setup script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} */tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && rm /tmp/common-setup.sh \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Setup default python tools in a venv via pipx to avoid conflicts
ARG DEFAULT_UTILS="\
    pylint \
    flake8 \
    autopep8 \
    black \
    yapf \
    mypy \
    pydocstyle \
    pycodestyle \
    bandit \
    virtualenv"
ENV PIPX_HOME=/usr/local/py-utils
ENV PIPX_BIN_DIR=${PIPX_HOME}/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN mkdir -p ${PIPX_BIN_DIR} \
    && export PYTHONUSERBASE=/tmp/pip-tmp \
    && pip3 install --disable-pip-version-check --no-warn-script-location --no-cache-dir --user pipx \
    && /tmp/pip-tmp/bin/pipx install --pip-args=--no-cache-dir pipx \
    && echo "${DEFAULT_UTILS}" | xargs -n 1 /tmp/pip-tmp/bin/pipx install --system-site-packages --pip-args=--no-cache-dir --pip-args=--force-reinstall \
    && chown -R ${USER_UID}:${USER_GID} ${PIPX_HOME} \
    && rm -rf /tmp/pip-tmp

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
#COPY requirements.txt /tmp/pip-tmp/
#RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update \
#     && export DEBIAN_FRONTEND=noninteractive \
#    && apt-get -y install --no-install-recommends <your-package-list-here>

# mongo

RUN apt-get install -y libcurl4 openssl liblzma5

USER root
WORKDIR /opt
RUN wget \
    https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-4.4.0.tgz
RUN tar -zxvf mongodb-linux-x86_64-debian10-4.4.0.tgz
RUN rm mongodb-linux-x86_64-debian10-4.4.0.tgz
RUN ln -s  /opt/mongodb-linux-x86_64-debian10-4.4.0/bin/* /usr/local/bin/
RUN mkdir -p /var/lib/mongo
RUN sudo mkdir -p /var/log/mongodb
RUN chown vscode /var/lib/mongo
RUN chown vscode /var/log/mongodb

# redis

RUN wget https://download.redis.io/redis-stable.tar.gz
RUN tar -zxvf redis-stable.tar.gz
RUN rm redis-stable.tar.gz
WORKDIR /opt/redis-stable
RUN make & make install
RUN echo -n | utils/install_server.sh
RUN chown -R vscode /var/lib/redis
RUN chown -R vscode /var/log/

# neo4j
RUN apt-get update && apt-get install -y openjdk-11-jdk-headless
WORKDIR /opt
RUN wget http://dist.neo4j.org/neo4j-community-4.1.1-unix.tar.gz
RUN tar -xzvf neo4j-community-4.1.1-unix.tar.gz
RUN rm neo4j-community-4.1.1-unix.tar.gz

# pgsql
RUN apt-get update && apt-get install -y postgresql

RUN curl -sLJO https://deb.secrethub.io/amd64 \
    && dpkg -i secrethub-cli-amd64.deb \
    && rm secrethub-cli-amd64.deb
