pragma solidity >=0.4.24;

import "./Roles.sol";

contract DistributorRole {
  using Roles for Roles.Role;
  event DistributorAdded(address indexed account);
  event DistributorRemoved(address indexed account);
  Roles.Role private distributors;
  constructor() public {
    _addDistributor(msg.sender);
  }

  modifier onlyDistributor() {
    require(EstDistributeur(msg.sender));
    _;
  }

  function EstDistributeur(address account) public view returns (bool) {
    return distributors.has(account);
  }

  function AjoutDistributeur(address account) public onlyDistributor {
    _addDistributor(account);
  }

  function SuppDistributeur() public {
    _removeDistributor(msg.sender);
  }

  function _addDistributor(address account) internal {
    distributors.add(account);
    emit DistributorAdded(account);
  }

  function _removeDistributor(address account) internal {
    distributors.remove(account);
    emit DistributorRemoved(account);
  }
}
