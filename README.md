# eve-id-nfts

Basic smart contract for EveID NFT

## Install

First, on Mac and Linux, install NVM (https://github.com/nvm-sh/nvm)

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

```

on Windows, install nvm-windows (https://github.com/coreybutler/nvm-windows).

The use nvm to install Node 16.
``` 
nvm install v16
```

Then install pnpm globally:

```
npm i -g pnpm

```

then install the dependencies

```
pnpm i
```

## Compile and testing

First off, you need an env file. Create a file `.env` in the root and put inside the content of the file `example.env`. Later, you can put there real keys.

``` 
npm run compile
```

``` 
npm test
```

## Deploy

Syntax:

```
bin/deploy.sh network name symbol tokenUri validator operator
```

Example:

``` 
bin/deploy.sh ethereum \
  "Eve ID NFT" EVE "https://nft.eve.id/metadata/" \
  0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 \
  0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
```
