#!/usr/bin/env bash
# must be run from the root

if [[ "$4" == "" ]]; then
  echo "Syntax:

  bin/deploy.sh network name symbol tokenUri validator operator

Example:

  bin/deploy.sh ethereum \\
    \"Eve ID NFT\" EVE \"https://nft.eve.id/metadata/\" \\
    0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 \\
    0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
"
  exit 1
fi

rm -rf artifacts
rm -rf cache
npx hardhat compile
NAME=$2 SYMBOL=$3 TOKEN_URI=$4 VALIDATOR=$5 OPERATOR=$6 npx hardhat run scripts/deploy-nft.js --network $1
