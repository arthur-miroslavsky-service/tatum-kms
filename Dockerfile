FROM node:18.20.5-alpine3.20 AS builder

WORKDIR /opt/app

RUN apk add --no-cache \
    git libtool curl jq py3-configobj py3-pip py3-setuptools python3 python3-dev \
    g++ make libusb-dev eudev-dev linux-headers \
 && ln -sf python3 /usr/bin/python \
 && ln -s /lib/arm-linux-gnueabihf/libusb-1.0.so.0 libusb-1.0.dll

RUN corepack enable

COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

RUN yarn install --immutable

COPY . .

RUN yarn build

USER node

ENTRYPOINT ["node", "/opt/app/dist/index.js"]
CMD ["daemon"]