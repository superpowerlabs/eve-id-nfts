#!/usr/bin/env bash

if [[ ! -d 'tmp' ]]; then
  mkdir tmp
fi
npx hardhat flatten contracts/$1.sol > ./tmp/$1-flatten.sol
