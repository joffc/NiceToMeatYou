pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Acces.sol";

// Define a contract 'DistributorRole' to manage this role - add, remove, check
contract DistributeurRole {
  using Roles for Roles.Role;
  // Define 2 events, one for Adding, and other for Removing
  event DistributeurAdded(address indexed account);
  event DistributeurRemoved(address indexed account);
  // Define a struct 'distributors' by inheriting from 'Roles' library, struct Role
  Roles.Role private distributeurs;
  // In the constructor make the address that deploys this contract the 1st distributor
  constructor() public {
    _addDistributeur(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyDistributeur() {
    require(isDistributeur(msg.sender));
    _;
  }

  // Define a function 'isDistributor' to check this role
  function isDistributeur(address account) public view returns (bool) {
    return distributeurs.has(account);
  }

  // Define a function 'addDistributor' that adds this role
  function addDistributeur(address account) public onlyDistributeur {
    _addDistributeur(account);
  }

  // Define a function 'renounceDistributor' to renounce this role
  function renounceDistributeur() public {
    _removeDistributeur(msg.sender);
  }

  // Define an internal function '_addDistributor' to add this role, called by 'addDistributor'
  function _addDistributeur(address account) internal {
    distributeurs.add(account);
    emit DistributeurAdded(account);
  }

  // Define an internal function '_removeDistributor' to remove this role, called by 'removeDistributor'
  function _removeDistributeur(address account) internal {
    distributeurs.remove(account);
    emit DistributeurRemoved(account);
  }
}
