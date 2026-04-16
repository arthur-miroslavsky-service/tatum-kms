FROM node:20-alpine AS builder

WORKDIR /opt/app

RUN apk add --no-cache \
    git libtool curl jq py3-configobj py3-pip py3-setuptools python3 python3-dev \
    g++ make libusb-dev eudev-dev linux-headers \
 && ln -sf python3 /usr/bin/python

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile --unsafe-perm

COPY . .

RUN yarn build

USER node

ENTRYPOINT ["node", "/opt/app/dist/index.js"]
CMD ["daemon"]