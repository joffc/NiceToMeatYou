pragma solidity >=0.4.24;

// Importe la librairie de gestion des rôles
import "./Roles.sol";

// Définit un contrat nommé "FarmerRole" qui gere le role du meme nom (possibilité d'ajout, suppression et vérification)
contract FarmerRole {
  using Roles for Roles.Role;

  // Creation de 2 évènements : Ajout et Suppression.
  event FarmerAdded(address indexed account);
  event FarmerRemoved(address indexed account);
  
  // Definition d'une structure 'farmers' héritée de la librairie 'Roles'. 
  Roles.Role private farmers;

  // Par défaut, cette fonction ajoute le propriétaire du contrat comme 1er producteur
  constructor() public {
    _addFarmer(msg.sender);
  }

  // Définit un modifier qui vérifie si l'envoyeur de la commande a le role approprié.
  modifier onlyFarmer() {
    require(EstProducteur(msg.sender));
    _;
  }

  // Definit une fonction 'EstProducteur' pour vérifier si l'adresse a ce role
  // Si l'adresse a ce role, la fonction booleenne retourne 'True'
  function EstProducteur(address account) public view returns (bool) {
    return farmers.has(account);
  }

  // Définit une fonction d'"AjoutProducteur" pour ajouter une adresse comme producteur
  function AjoutProducteur(address account) public onlyFarmer {
    _addFarmer(account); // Ajoute le role de producteur a cette adresse
  }

  // Définit une fonction de "SuppProducteur" pour supprimer une adresse du role de producteur
  function SuppProducteur() public {
    _removeFarmer(msg.sender);
  }
  
  // Fonction appelé par 'AjoutProducteur' pour la gestion du role (ajout)
  function _addFarmer(address account) internal {
    farmers.add(account);
    emit FarmerAdded(account);
  }

  // Fonction appelé par 'SuppProducteur' pour la gestion du role (suppression)
  function _removeFarmer(address account) internal {
    farmers.remove(account);
    emit FarmerRemoved(account);
  }
}
