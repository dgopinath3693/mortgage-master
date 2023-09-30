// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract LoanApp {
    
    //how much the total loan is, before splitting into monthly plans
    uint public totalLoanAmount;
    bool approved = false;
    address public user = msg.sender; //user's address
    mapping(address => uint256) userBalance;
    string public typeOfLoan; 

    event Withdrawal(uint _totalLoanAmount); // the event that will be emitted to frontend
    
    constructor(uint _totalLoanAmount) payable {
        setUserBalance(msg.sender, 100000); //currently hardcoded to 100000
        uint minReqBalance = _totalLoanAmount/4; 
        require(
            minReqBalance < userBalance[msg.sender],
            "User balance is under the required minimum amount"
        );
        totalLoanAmount = _totalLoanAmount;
        approved = true;
    }

    uint interestRate = 0; 
    uint monthlyLoan = 0; 

    /**
     * This payment plan is the shortest duration, but has the highest payments per month.
     */
    function shortestPaymentPlan() public returns (uint256) {
        uint256 numMonths;
        if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Home"))) {
            interestRate = 8; // 0.08 scaled by 100
            numMonths = 15 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Auto"))) {
            interestRate = 7; // 0.07 scaled by 100
            numMonths = 3 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Personal"))) {
            interestRate = 10; // 0.10 scaled by 100
            numMonths = 2 * 12;
        }

        uint256 rate = interestRate * 10**16; // further scale up by 10^16
        uint256 numerator = totalLoanAmount * rate * ((1 + rate)**numMonths);
        uint256 denominator = ((1 + rate)**numMonths - 1) * 10**18; // scale down by 10^18

        monthlyLoan = numerator / denominator;

        return monthlyLoan;
    }

    /**
     * This payment plan is the shortest duration, but has the highest payments per month.
     */
    function averagePaymentPlan() public returns (uint256) {
        uint256 numMonths;
        if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Home"))) {
            interestRate = 8; // 0.08 scaled by 100
            numMonths = 20 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Auto"))) {
            interestRate = 7; // 0.07 scaled by 100
            numMonths = 6 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Personal"))) {
            interestRate = 10; // 0.10 scaled by 100
            numMonths = 5 * 12;
        }

        uint256 rate = interestRate * 10**16; // further scale up by 10^16
        uint256 numerator = totalLoanAmount * rate * ((1 + rate)**numMonths);
        uint256 denominator = ((1 + rate)**numMonths - 1) * 10**18; // scale down by 10^18

        monthlyLoan = numerator / denominator;

        return monthlyLoan;
    }

    /**
     * This payment plan is the shortest duration, but has the highest payments per month.
     */
    function longestPaymentPlan() public returns (uint256) {
        uint256 numMonths;
        if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Home"))) {
            interestRate = 8; // 0.08 scaled by 100
            numMonths = 30 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Auto"))) {
            interestRate = 7; // 0.07 scaled by 100
            numMonths = 8 * 12;
        } else if (keccak256(abi.encodePacked(typeOfLoan)) == keccak256(abi.encodePacked("Personal"))) {
            interestRate = 10; // 0.10 scaled by 100
            numMonths = 7 * 12;
        }

        uint256 rate = interestRate * 10**16; // further scale up by 10^16
        uint256 numerator = totalLoanAmount * rate * ((1 + rate)**numMonths);
        uint256 denominator = ((1 + rate)**numMonths - 1) * 10**18; // scale down by 10^18

        monthlyLoan = numerator / denominator;

        return monthlyLoan;
    }
  
     /**
      * Withdraw the full loan amount to the user's account balance if they are approved.
      */
    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("The user's address: %s", user,"and the user's balance is %s", userBalance);
        require(approved);
        require(msg.sender == user, "You aren't the owner");

        userBalance[msg.sender] += totalLoanAmount;

        emit Withdrawal(totalLoanAmount);
    }



    /**
     * Method that updates the userBalance mapping to the user's current balance in their account when trying
     * to apply for a loan. The default userBalance is currently hardcoded to a specific value
     * for simpler functionality.
     */
    function setUserBalance(address _user, uint _balance) internal {
        userBalance[_user] = _balance;
    }
}
