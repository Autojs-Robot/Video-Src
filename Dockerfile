FROM node:14.18.3

# 服务器设置时区
ENV TZ=Asia/Shanghai 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD package.json /tmp/package.json
ADD yarn.lock /tmp/yarn.lock
RUN cd /tmp && yarn

# Create app directory
RUN mkdir -p /usr/src/app && cp -a /tmp/node_modules /usr/src/app

WORKDIR /usr/src/app
# Install app dependencies
COPY . /usr/src/app


ENV PORT=3000
ENV NODE_ENV=production

# Bundle app source
EXPOSE 3000
CMD [ "yarn", "start" ]