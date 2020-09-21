pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Acces.sol";

// Define a contract 'FarmerRole' to manage this role - add, remove, check
contract Producteur {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event ProducteurAdded(address indexed account);
  event ProducteurRemoved(address indexed account);

  // Define a struct 'farmers' by inheriting from 'Roles' library, struct Role
  Roles.Role private Producteurs;

  // In the constructor make the address that deploys this contract the 1st farmer
  constructor() public {
    _addProducteur(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyProducteur() {
    require(isProducteur(msg.sender));
    _;
  }

  // Define a function 'isFarmer' to check this role
  function isProducteur(address account) public view returns (bool) {
    return Producteurs.has(account);
  }

  // Define a function 'addFarmer' that adds this role
  function addProducteur(address account) public onlyProducteur {
    _addProducteur(account);
  }

  // Define a function 'renounceFarmer' to renounce this role
  function renounceProducteur() public {
    _removeProducteur(msg.sender);
  }

  // Define an internal function '_addFarmer' to add this role, called by 'addFarmer'
  function _addProducteur(address account) internal {
    Producteurs.add(account);
    emit ProducteurAdded(account);
  }

  // Define an internal function '_removeFarmer' to remove this role, called by 'removeFarmer'
  function _removeProducteur(address account) internal {
    Producteurs.remove(account);
    emit ProducteurRemoved(account);
  }
}
