FROM node:24-bookworm-slim@sha256:6f7b03f7c2c8e2e784dcf9295400527b9b1270fd37b7e9a7285cf83b6951452d

ARG REASONIX_VERSION=1.17.17
ARG CC_CONNECT_VERSION=1.4.1

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/ccc
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        jq \
        openssh-client \
        procps \
        python3 \
        ripgrep \
        tini \
        vim-nox \
    && rm -rf /var/lib/apt/lists/*

RUN existing_user="$(getent passwd 1000 | cut -d: -f1 || true)" \
    && if [ -n "${existing_user}" ]; then \
        existing_group="$(id -gn "${existing_user}")" \
        && if [ "${existing_group}" != "ccc" ]; then groupmod --new-name ccc "${existing_group}"; fi \
        && if [ "${existing_user}" != "ccc" ]; then \
            usermod --login ccc --home /home/ccc --move-home "${existing_user}"; \
        else \
            usermod --home /home/ccc --move-home ccc; \
        fi; \
    else \
        useradd --create-home --shell /bin/bash --uid 1000 ccc; \
    fi

RUN npm install -g "reasonix@${REASONIX_VERSION}" \
    && npm cache clean --force \
    && asset="cc-connect-v${CC_CONNECT_VERSION}-linux-amd64.tar.gz" \
    && base_url="https://github.com/chenhg5/cc-connect/releases/download/v${CC_CONNECT_VERSION}" \
    && curl -fsSLO "${base_url}/${asset}" \
    && curl -fsSLO "${base_url}/checksums.txt" \
    && grep " ${asset}$" checksums.txt | sha256sum -c - \
    && tar -xzf "${asset}" \
    && install -m 0755 "cc-connect-v${CC_CONNECT_VERSION}-linux-amd64" /usr/local/bin/cc-connect \
    && rm -f "${asset}" checksums.txt \
    && mkdir -p /home/ccc/workspace \
    && chown -R ccc:ccc /home/ccc

USER ccc
WORKDIR /home/ccc/workspace

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["cc-connect", "--version"]
