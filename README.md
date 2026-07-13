# cc-connect-image

可复现的 `cc-connect` Docker 运行镜像，内置 Reasonix CLI，供
`reasonix acp` 作为 cc-connect 的 ACP agent 使用。

镜像由 GitHub Actions 发布：

- `ghcr.io/zlwu/cc-connect-image:main`
- `ghcr.io/zlwu/cc-connect-image:sha-<shortsha>`

Homelab 现网通过 `ghcr.nju.edu.cn/zlwu/cc-connect-image:main` 拉取。

## 镜像约定

- 基础镜像、cc-connect 和 Reasonix 版本都固定在 `Dockerfile`。
- cc-connect Linux amd64 release 在构建时使用其官方 `checksums.txt` 校验。
- 运行用户为 `ccc`（uid/gid 1000），HOME 为 `/home/ccc`。
- 使用 `tini` 作为 PID 1，工作目录为 `/home/ccc/workspace`。

不要把 cc-connect 平台凭据、Reasonix 配置或任何会话状态提交到本仓库。
Reproducible Docker image for cc-connect with Reasonix ACP
