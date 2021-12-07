pragma solidity ^0.4.25;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract ExerciseC6CApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    address private contractOwner; // Account used to deploy contract
    ExerciseC6C exerciseC6C;
    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    constructor(address contractDataAddress) public {
        contractOwner = msg.sender;
        exerciseC6C = new ExerciseC6C(contractDataAddress);
    }

    function calculateBonus(uint256 sales)
        internal
        view
        requireContractOwner
        returns (uint256)
    {
        if (sales < 100) {
            return sales.mul(5).div(100);
        } else if (sales < 500) {
            return sales.mul(7).div(100);
        } else {
            return sales.mul(10).div(100);
        }
    }

    function addSale(string id, uint256 amount) external requireContractOwner {
        exerciseC6C.updateEmployee(id, amount, calculateBonus(amount));
    }
}

contract ExerciseC6C {
       function updateEmployee(
        string id,
        uint256 sales,
        uint256 bonus
    ) external;
}