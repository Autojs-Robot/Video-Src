FROM mhart/alpine-node:12

ADD package.json /tmp/package.json
RUN cd /tmp && npm install --production

# Create app directory
RUN mkdir -p /usr/src/app && cp -a /tmp/node_modules /usr/src/app

WORKDIR /usr/src/app
# Install app dependencies
COPY . /usr/src/app

ENV PORT=3000
ENV NODE_ENV=production

# Bundle app source
EXPOSE 3000
CMD [ "npm", "start" ]
