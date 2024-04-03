FROM ubuntu:latest

RUN apt update

# Download and install all the necessary dependencies for steamcmd
RUN dpkg --add-architecture i386 \
  && apt-get update -y && apt install wget lib32gcc-s1 lib32stdc++6 \
  curl libstdc++6:i386 lib32z1 build-essential -y

# Presetting Values for liscence agreement keys using debconf-set-selections
RUN echo steam steam/question select "I AGREE" |  debconf-set-selections 
RUN echo steam steam/license note '' | debconf-set-selections 

# Download and install steamcmd
RUN apt-get install -y --no-install-recommends steamcmd 

# Create symlink for executable in /bin
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Configura o servidor
# Adiciona a configuração fs.file-max ao arquivo /etc/sysctl.conf
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN echo "* soft nofile 100000" >> /etc/security/limits.conf
RUN echo "* hard nofile 100000" >> /etc/security/limits.conf
RUN echo "session optional  pam_limits.so" >> /etc/pam.d/common-session
# Executa o comando sysctl para aplicar a configuração
RUN sysctl -p

# Cria o usuário steam
RUN useradd -m steam
# Define o usuário steam como o usuário padrão
USER steam
# Define o diretório de trabalho
WORKDIR /home/steam
# Baixa o servidor de Ark Survival Evolved
RUN steamcmd +force_install_dir /home/steam/ark/ +login anonymous +app_update 376030 validate +quit


