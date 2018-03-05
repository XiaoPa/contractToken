pragma solidity ^0.4.18;

import "./base/token/ERC20/StandardToken.sol";

contract MYToken is StandardToken {
	string public name = "MY Token";
	string public symbol = "MYT";
	uint8 public decimals = 18;
}
