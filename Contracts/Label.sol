pragma solidity >=0.4.24;

import "./Roles.sol";

contract Label {
  using Roles for Roles.Role;
  event LabelAdded(address indexed account);
  event LabelRemoved(address indexed account);

  Roles.Role private labels;
  constructor() public {
    _addLabel(msg.sender);
  }

  modifier onlyLabel() {
    require(EstLabel(msg.sender));
    _;
  }

  function EstLabel(address account) public view returns (bool) {
    return labels.has(account);
  }

  function AjoutLabel(address account) public onlyLabel {
    _addLabel(account);
  }

  function SuppLabel() public {
    _removeLabel(msg.sender);
  }

  function _addLabel(address account) internal {
    labels.add(account);
    emit LabelAdded(account);
  }

  function _removeLabel(address account) internal {
    labels.remove(account);
    emit LabelRemoved(account);
  }
}
