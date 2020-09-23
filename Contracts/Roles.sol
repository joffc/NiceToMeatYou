pragma solidity >=0.4.24;

/**
 * @title Roles
 * @Librairie permettant la gestion des roles assignés aux acteurs.
 */
library Roles {
  struct Role {
    mapping (address => bool) admin;
  }

  /**
   * @ donne un droit d'acces a ce role sur un contrat suivant l'adresse
   */
  function add(Role storage role, address account) internal {
    require(account != address(0));
    require(!has(role, account));

    role.admin[account] = true;
  }

  /**
   * @ enleve le droit d'acces a ce role sur un contrat suivant l'adresse
   */
  function remove(Role storage role, address account) internal {
    require(account != address(0));
    require(has(role, account));

    role.admin[account] = false;
  }

  /**
   * @ verifie que le compte (l'adresse) a bien un droit d'acces
   * @return bool
   */
  function has(Role storage role, address account)
    internal
    view
    returns (bool)
  {
    require(account != address(0));
    return role.admin[account];
  }
}
