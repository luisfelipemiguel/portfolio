# Docker Challenge

Este guia descreve como instalar o Docker, Docker Compose e preparar um ambiente para executar o WordPress com MySQL utilizando Docker.

## 1. Instalar Docker e Docker Compose

### 1.1. Atualizar o Gerenciador de Pacotes

```bash
sudo dnf update
```

### 1.2. Instalar Docker

#### 1.2.1. Instalar as dependências do Docker:

```bash
sudo dnf install -y dnf-plugins-core
```

#### 1.2.2. Adicionar o repositório do Docker:

```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

#### 1.2.3. Instalar o Docker:

```bash
sudo dnf install docker-ce docker-ce-cli containerd.io
```

#### 1.2.4. Iniciar e habilitar o serviço Docker:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### 1.3. Instalar o Docker Compose

#### 1.3.1. Baixar o binário do Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/<VERSION>/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

(Substitua `<VERSION>` pela última versão disponível do Docker Compose.)

#### 1.3.2. Aplicar permissões executáveis ao binário:

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

#### 1.3.3. Verificar a instalação:

```bash
docker-compose --version
```

## 2. Preparar o arquivo Docker Compose para WordPress

Crie um arquivo `docker-compose.yml` no diretório desejado (por exemplo, `/home/user/wordpress`):

```yaml
services:
  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: your-password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: your-password
    restart: always
    networks:
      - app-network

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: your-password
      WORDPRESS_DB_NAME: wordpress
    networks:
      - app-network

networks:
  app-network:
```

## 3. Iniciar o Contêiner do WordPress

### 3.1. Navegue até o diretório onde seu arquivo `docker-compose.yml` está localizado:

```bash
cd /home/user/wordpress
```

### 3.2. Inicie os contêineres usando o Docker Compose:

```bash
docker-compose up -d
```

(Este comando irá baixar as imagens Docker necessárias (`wordpress:latest` e `mysql:5.7`) caso não estejam presentes e iniciará os contêineres em modo detached `-d`.)

## 4. Acessar o WordPress

O WordPress agora deve estar acessível a partir do navegador web da sua máquina local em:

```bash
http://localhost
```

## 5. Garantir que os contêineres Docker iniciem no reboot

Para garantir que seus contêineres Docker sejam iniciados automaticamente se a VM for reiniciada, o serviço Docker deve estar habilitado, o que já fizemos anteriormente com o comando:

```bash
sudo systemctl enable docker
```

## Dicas Adicionais

- Verificar o status do Docker:

```bash
sudo systemctl status docker
```

- Parar os contêineres:

```bash
docker-compose down
```

- Remover os contêineres e volumes:

```bash
docker-compose down -v
```

> Este setup deve fornecer uma instância do WordPress rodando no Docker em sua máquina virtual AlmaLinux. Ajuste os caminhos e configurações conforme necessário para o seu ambiente.
