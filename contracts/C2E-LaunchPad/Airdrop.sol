// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
//空投合约
contract Airdrop {
     using SafeERC20 for IERC20;
    
    IERC20 public immutable token;

    uint256 public totalTokensWithdrawn;
    mapping(address =>bool) wasClaimed;

    uint public immutable amount = 100 * 1e36;

    constructor(address _token) {
        token = IERC20(_token);
    }

    //发放空投
    function send() external {
            require(msg.sender == tx.origin, "Require that message sender is tx-origin.");
            address beneficiary = msg.sender;
            bool isSend = wasClaimed[beneficiary];
            require(!isSend);
            token.safeTransfer(beneficiary,amount);
            wasClaimed[beneficiary] = true;
            totalTokensWithdrawn += amount;
    }
}