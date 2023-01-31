FROM node:18.13-bullseye-slim

RUN npm install pm2 -g

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080

CMD ["pm2-runtime", "app.js"]
#ENTRYPOINT ["/opt/startup/init_container.sh"]
