pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/payment/PullPayment.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract TreasureContract is PullPayment {
	using SafeMath for uint256;
	using SafeMath for uint;

	mapping (bytes32 => Treasure) private treasures;

	struct Treasure {
		address creator;
		bool claimed;
		uint timestamp;
		uint256 bounty;
	}

	function addTreasure (bytes32 passwordSha) public payable {
		var treasure = treasures[passwordSha];
		require(treasure.creator == address(0));
		require(msg.value > 0);
		treasure.creator = msg.sender;
		treasure.claimed = false;
		treasure.timestamp = block.timestamp;
		treasure.bounty = msg.value;
	}

	function increaseBounty (bytes32 passwordSha) public payable {
		var treasure = treasures[passwordSha];
		require(treasure.creator != address(0));
		require(treasure.claimed != true);
		require(msg.value > 0);
		treasure.bounty = treasure.bounty.add(msg.value);
	}

	function claimTreasure (string password) public {
		var passwordSha = calculateHash(password);
		var treasure = treasures[passwordSha];
		require(treasure.creator != address(0));
		require(treasure.claimed != true);
		treasure.claimed = true;
		asyncSend(msg.sender, treasure.bounty);
	}

	function getTreasureByHash(bytes32 passwordSha) public constant returns (address creator, uint timestamp, bool claimed, uint256 bounty) {
		var treasure = treasures[passwordSha];
		require(treasure.creator != address(0));
		creator = treasure.creator;
		timestamp = treasure.timestamp;
		claimed = treasure.claimed;
		bounty = treasure.bounty;
	}

	function calculateHash(string password) internal pure returns (bytes32) {
		return sha256(password);
	}
}
