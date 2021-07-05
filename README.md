# flash-loan-scam
Analysis of "flash loan attack" from YouTuber https://www.youtube.com/watch?v=HynfsKoFlaw&amp;t=105s

## Background

The YouTuber "Crypto Academy" https://www.youtube.com/channel/UCgiMBbCjQnaf2q3_cs06KOw  posted a video on how to orchestrate a FlashLoan attack.  I decided to verify the claims of this video by inspecting the code. This is my analysis of the video with a review of the code.

## Concern 1:  Code on GhostBin
The attack code is on GhostBin, an anonymous file sharing platform not GitHub or GitHub gist. 

## Concern 2:  Code on IPFS
From the GhostBin code the contract imports a contract from IPFS at QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923.  This obfiscates the code from anyone wanting to inspect what the contract does.  I have included the IPFS code in this repo to inspect. 

## Conern 3:  Bad addresses
In the IPFS file LN 128 references the contract `0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B`.  This does not exist on the Ethereum blockchain.   https://etherscan.io/address/0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B

# Inspecting the code
After downloading the IPFS file QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923 there are a lot of concerns.

## Concern 4:  Commented out code
Code in the "Router" contract are commented out and done using the `/*` method instead of `\\` which is technically correct, but easy to miss unless put into an IDE such as VS Code.

```
    function lendingPoolFlashloan(uint256 _asset) public pure {
        uint256 data = _asset; 
        require(data != 0, "Data can't be 0.");/*
        uint amount = 1 BNB;

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);*/
    }
```

Lots of methods are simply commented out or do nothing, such as 

```
    //5. Note that the transaction sender gains 3.29 BNB from the arbitrage, this particular transaction can be repeated as price changes all the time.
    function completeTransation(uint256 balanceAmount) public pure {
        require(balanceAmount >= 0, "Amount should be greater than 0!");
    }
```

# Socials 
## Concern 3: Social profile
The YouTuber only has a few followings and only 3 videos at time of writing on "Flash Loans"
![Screenshot from 2021-07-05 10-55-32](https://user-images.githubusercontent.com/8411406/124405464-11db3e00-dd82-11eb-8346-de1eac423640.png)

## Concern 4: Fake comments
There are profiles such as "Marcus Canton" with no profile image commenting "Amazing I did it twice and earned over 5BNB. Great JOB!!".  Clicking "his" profile shows they only registered a few days ago at time of writing.

![Screenshot from 2021-07-05 11-07-01](https://user-images.githubusercontent.com/8411406/124405446-038d2200-dd82-11eb-80d0-dad085fabfba.png)

