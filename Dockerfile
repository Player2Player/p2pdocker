FROM node:18.13-bullseye-slim

RUN mkdir -p /home/LogFiles /opt/startup \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /etc/bash.bashrc

RUN npm install -g pm2 \
     && apt-get update \
     && apt-get install --yes --no-install-recommends \
      openssh-server \
      vim \
      curl \
      wget \
      tcptraceroute \
      openrc \
      yarn \
      net-tools \
      dnsutils \
      tcpdump \
      cron \
      iproute2

COPY tcpping /usr/bin/tcpping
RUN chmod 755 /usr/bin/tcpping

RUN rm -f /etc/ssh/sshd_config

RUN mkdir -p /tmp
COPY sshd_config /etc/ssh/

COPY ssh_setup.sh /tmp

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/* \
   && npm install

COPY startssh.sh /opt/startup
COPY init_container.sh /opt/startup
RUN chmod +x /opt/startup/startssh.sh
RUN chmod u+x /opt/startup/init_container.sh

# Bundle app source
COPY . .

ENV SSH_PORT 2222
EXPOSE 8000

CMD [ "npm", "start" ]
#ENTRYPOINT ["/opt/startup/init_container.sh"]
