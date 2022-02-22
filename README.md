# eve-id-nfts

Basic smart contract for EveID NFT

## Install
``` 
npm i -g pnpm
pnpm i
```

## Compile and testing

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
