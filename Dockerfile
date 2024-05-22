# Imagem de contêiner que executa seu código
FROM alpine:3.19

RUN apk update && apk add curl aws-cli \
&& curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x ./aws-iam-authenticator \
  && mkdir -p $HOME/bin \
  && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator \
  && export PATH=$PATH:$HOME/bin \
  && echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# Copia o arquivo de código do repositório de ação para o caminho do sistema de arquivos `/` do contêiner
COPY entrypoint.sh /entrypoint.sh

# Arquivo de código a ser executado quando o contêiner do docker é iniciado (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
