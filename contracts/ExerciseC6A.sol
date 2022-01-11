pragma solidity >=0.4.24;

contract ExerciseC6A {

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    uint constant M = 2;
    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    /**
    * @dev Account used to deploy the contract.
    */
    address private contractOwner;
    /**
    * @dev Mapping of addresses to "UserProfile" structs.
    */
    mapping(address => UserProfile) userProfiles;
    /**
    * @dev Determines if a contract is currently operational.
    */
    bool private operational = true;
    /**
    * @dev
    */
    address[] multiCalls = new address[](0);

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;
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

    /**
    * @dev Modifier that requires the contract to be "operational".
    */
    modifier requireOperational()
    {
        require(operational, "Contract is not currently operational.");
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
    function isUserRegistered
                            (
                                address account
                            )
                            external
                            view
                            returns(bool)
    {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    /**
    * @dev Check if the contract is operational.
    * @return A bool that indicates if the contract is operational.
    */
    function isOperational() external view returns(bool)
    {
        return operational;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser
                                (
                                    address account,
                                    bool isAdmin
                                )
                                external
                                requireContractOwner
                                requireOperational
    {
        require(!userProfiles[account].isRegistered, "User is already registered.");

        userProfiles[account] = UserProfile({
                                                isRegistered: true,
                                                isAdmin: isAdmin
                                            });
    }

    function setOperatingStatus
                            (
                                bool mode
                            )
                            external
    {
        require(mode != operational, "New mode must be different from existing mode.");
        require(userProfiles[msg.sender].isAdmin, "Caller is not an admin.");

        bool isDuplicate = false;
        for(uint c=0; c<multiCalls.length;c++) {
            if(multiCalls[c] == msg.sender){
                isDuplicate = true;
                break;
            }
        }
        require(!isDuplicate, "Caller has already called this function.");
        multiCalls.push(msg.sender);
        if(multiCalls.length >= M){
            operational = mode;
            multiCalls = new address[](0);
        }
    }
}

