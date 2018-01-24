pragma solidity ^0.4.6;

import "./StandardToken.sol";
import "./SafeMath.sol";

/// @title Token contract - Implements Standard Token Interface but adds Pyramid Scheme Support :)
/// @author Rishab Hegde - <contact@rishabhegde.com>
contract PonziCoin is StandardToken, SafeMath {

    /*
     * Token meta data
     */
    string constant public name = "PonziCoin";
    string constant public symbol = "SEC";
    uint8 constant public decimals = 3;

    uint public buyPrice = 10 szabo;
    uint public sellPrice = 2500000000000 wei;
    uint public tierBudget = 100000;

    // Address of the founder of PonziCoin.
    address public founder = 0x9acBAE8ece4E82DDAecca4cd78A148E137356d50;

    /*
     * Contract functions
     */
    /// @dev Allows user to create tokens if token creation is still going
    /// and cap was not reached. Returns token count.
    function fund()
      public
      payable 
      returns (bool)
    {
      uint tokenCount = msg.value / buyPrice;
      if (tokenCount > tierBudget) {
        tokenCount = tierBudget;
      }
      
      uint investment = tokenCount * buyPrice;

      balances[msg.sender] += tokenCount;
      Issuance(msg.sender, tokenCount);
      totalSupply += tokenCount;
      tierBudget -= tokenCount;

      if (tierBudget <= 0) {
        tierBudget = 100000;
        buyPrice *= 2;
        sellPrice *= 2;
      }
      if (msg.value > investment) {
        msg.sender.transfer(msg.value - investment);
      }
      return true;
    }

    function withdraw(uint tokenCount)
      public
      returns (bool)
    {
      if (balances[msg.sender] >= tokenCount) {
        uint withdrawal = tokenCount * sellPrice;
        balances[msg.sender] -= tokenCount;
        totalSupply -= tokenCount;
        msg.sender.transfer(withdrawal);
        return true;
      } else {
        return false;
      }
    }

    /// @dev Contract constructor function sets initial token balances.
    function PonziCoin()
    {   
        // It's not a good scam unless it's pre-mined
        balances[founder] = 200000;
        totalSupply += 200000;
    }
}
