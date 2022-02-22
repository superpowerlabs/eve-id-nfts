#!/usr/bin/env bash
# must be run from the root

rm -rf cache
rm -rf artifacts
npx hardhat compile

node scripts/exportABIs.js
cp export/ABIs.json ../eve-app/client/config/.
cp export/deployed.json ../eve-app/client/config/.
