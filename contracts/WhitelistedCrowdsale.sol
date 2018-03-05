pragma solidity ^0.4.18;

import "./StandardCrowdsale.sol";
import "./base/ownership/Ownable.sol";

//@dev addd whitelist to a crowdsale
contract WhitelistedCrowdsale is StandardCrowdsale, Ownable {
 	mapping(address => bool) public registered;
    
    event RegistrationStatusChanged(address target, bool isRegistered);


    function changeRegistrationStatus(address target, bool isRegistered) public onlyOwner only24HBefore {
    	registered[target] = isRegistered;
    	RegistrationStatusChanged(target, isRegistered);
    }


    function changeRegistrationStatuses(address[] targets, bool isRegistered) public onlyOwner only24HBefore {
    	for (uint i = 0; i < targets.length; i++) {
    		changeRegistrationStatus(targets[i], isRegistered)
    	}
    }

    function validPurchase() internal returns(bool){
    	return super.validPurchase() && registered[msg.sender];
    }
}