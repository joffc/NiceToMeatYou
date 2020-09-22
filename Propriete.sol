pragma solidity >=0.4.24;

/// Provides basic authorization control
contract Ownable {
    address private Owner;

    // Define an Event
    event TransfertPropriete(address indexed oldOwner, address indexed newOwner);

    /// Assign the contract to an owner
    constructor () internal {
        Owner = msg.sender;
        emit TransfertPropriete(address(0), origOwner);
    }

    /// Look up the address of the owner
    function ownerLookup() public view returns (address) {
        return Owner;
    }

    /// Define a function modifier 'onlyOwner'
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /// Check if the calling address is the owner of the contract
    function isOwner() public view returns (bool) {
        return msg.sender == Owner;
    }

    /// Define a function to renounce ownerhip
    function renoncePropriete() public onlyOwner {
        emit TransfertPropriete(origOwner, address(0));
        origOwner = address(0);
    }

    /// Define a public function to transfer ownership
    function transfertPropriete(address newOwner) public onlyOwner {
        _transfertPropriete(newOwner);
    }

    /// Define an internal function to transfer ownership
    function _transfertPropriete(address newOwner) internal {
        require(newOwner != address(0));
        emit transfertPropriete(origOwner, newOwner);
        origOwner = newOwner;
    }
}
