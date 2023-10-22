# encode-sui-educate
Examples from the Encode x Sui Educate programme

## Resources

Playlist: https://www.youtube.com/playlist?list=PLfEHHr3qexv_aE7p6oDyVtD3WQsDsJngr

Sui Foundation Git Repo: https://github.com/sui-foundation/encode-sui-educate

## Contents
---

- car -> Smart Contract

- nft_tutorial -> NFT Contract

- ??? -> ???


## Directions
in the source folder
sui move build

in the build folder
sui client publish nft_tutorial --gas-budget 200000000

mint form command line:
sui client call --package 0x859561cac93d42d07f455cf9debf98afee7782d9c8a5e2476eb2f60d8694483b --module nft_example --function mint_to_sender --args Roy'sNFT hello www.google.com --gas-budget 1000000000

