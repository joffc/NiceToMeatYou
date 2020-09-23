pragma solidity >=0.4.24;

import "./Roles.sol";

contract RetailerRole {
  using Roles for Roles.Role;

  event RetailerAdded(address indexed account);
  event RetailerRemoved(address indexed account);

  Roles.Role private retailers;
 
  constructor() public {
    _addRetailer(msg.sender);
  }

  
  modifier onlyRetailer() {
     require(EstDetaillant(msg.sender));
    _;
  }

  
  function EstDetaillant(address account) public view returns (bool) {
    return retailers.has(account);
  }

  
  function AjoutDetaillant(address account) public onlyRetailer {
    _addRetailer(account);
  }

  function SuppDetaillant() public {
    _removeRetailer(msg.sender);
  }

  function _addRetailer(address account) internal {
    retailers.add(account);
    emit RetailerAdded(account);
  }

  function _removeRetailer(address account) internal {
    retailers.remove(account);
    emit RetailerRemoved(account);
  }
}
