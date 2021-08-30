pragma solidity ^0.5.16;

contract ExerciseC6A {

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/


    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    address private contractOwner;                  // Account used to deploy contract
    mapping(address => UserProfile) userProfiles;   // Mapping for storing user profiles
    bool public operational;
    uint constant M = 3;

    address[] multicalls = new address[](0);

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor () 
        public 
    {
        contractOwner = msg.sender;
        operational = true;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireIsOperational() {
        require(operational == true, "This contract is not operational");
        _;
    }



    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

   /**
    * @dev Check if a user is registered
    *
    * @return A bool that indicates if the user is registered
    */   
    function isUserRegistered ( address account )
        external
        view
        returns(bool)
    {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    function setOperatingStatus(bool status) 
        public 
    {
        require(status != operational, "The status is alreay set");
        require(userProfiles[msg.sender].isAdmin, "User needs to be admin");
        bool duplicate = false;

        for(uint i = 0; i < multicalls.length; i++) {
            if (multicalls[i] == msg.sender) {
                duplicate = true;
                break;
            }
        }
        require(!duplicate, "Caller already called this function");

        multicalls.push(msg.sender);
        if (multicalls.length >= M) {
            operational = status;
            multicalls = new address[](0);
        }
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser ( address account, bool isAdmin )
        external
        requireContractOwner
        requireIsOperational
    {
        require(!userProfiles[account].isRegistered, "User is already registered.");

        userProfiles[account] = UserProfile({ 
            isRegistered: true,
            isAdmin: isAdmin
        });
    }
}

