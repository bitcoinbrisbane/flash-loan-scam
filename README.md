# flash-loan-scam
Analysis of "flash loan attack" from YouTuber https://www.youtube.com/watch?v=HynfsKoFlaw&amp;t=105s

## Background

The YouTuber "Crypto Academy" https://www.youtube.com/channel/UCgiMBbCjQnaf2q3_cs06KOw  posted a video on how to orchestrate a FlashLoan attack.  I decided to verify the claims of this video by inspecting the code. This is my analysis of the video with a review of the code.

## v 1:  Code on GhostBin
The attack code is on GhostBin, an anonymous file sharing platform not GitHub or GitHub gist. 

## Concern 2:  Code on IPFS
From the GhostBin code the contract imports a contract from IPFS at QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923.  This obfiscates the code from anyone wanting to inspect what the contract does.  I have included the IPFS code in this repo to inspect. 

## Conern 3:  Bad addresses
In the IPFS file LN 128 references the contract `0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B`.  This does not exist on the Ethereum blockchain.   https://etherscan.io/address/0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B



## Concern 3: Social profile
The YouTuber only has a few followings and only 3 videos at time of writing on "Flash Loans"

## Concern 4: Fake comments
There are profiles such as "