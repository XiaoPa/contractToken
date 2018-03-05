pragma solidity ^0.4.18;


import "./base/token/StandardToken.sol";
import "./base/math/SafeMath.sol";


contract StandardCrowdsale {
	using SafeMath for uint256;

	StandardToken public token;

	uint256 public startTime;
	uint256 public endTime;
    
	// address where funds are collected
	address public wallet;

	uint256 public rate;

	uint256 public weiRaised;




	event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);

	function StandardCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet){
		require(_startTime >= now);
		require(_endTime >=startTime);
		require(_rate > 0);
		require(_wallet != 0x0);

		startTime = _startTime;
		endTime = _endTime;
		rate = _rate;
		wallet = _wallet;

		token = createTokenContract();

	}

	// create Token to be sold
	// override this method to have crowdsale of a specific mintable token.
	function createTokenContract() internal returns(StandardToken){
		return new StandardToken();
	}

	function () payable {
		buyTokens();
	}

	function buyTokens() public payable {
		require(validPurchase);

		uint256 weiAmount = msg.value;

		uint256 tokens = weiAmount.mul(rate);

		weiRaised = weiRaised.add(weiAmount)
 		
 		require(token.transfer(msg.sender, tokens));

 		TokenPurchase(msg.sender, weiAmount, tokens);

 		forwardFunds();
	}

	function forwardFunds() internal {
		wallet.transfer(msg.value);
	}

	// @return true if the transaction can buy tokens
	function validPurchase() internal returns(bool){
		bool withinPeriod = now >= startTime && now <= endTime;
		bool nonZeroPurchase = msg.value != 0;

		return withinPeriod && nonZeroPurchase;
	}
    function hasEnded() 
        public 
        constant 
        returns(bool) 
    {
        return now > endTime;
    }
    modifier onlyBeforeSale() {
    	require(now < startTime);
    	_;
    }
    modifier only24HBeforeSale(){
    	require(now < startTime.sub(1 days));
    	_;
    }

}
