pragma solidity >=0.4.24;

// Provides basic authorization control

contract Ownable {
    address private origOwner;

    // Définition de l'évènement afin de permettre le changement de propriétaire
    
    event TransferOwnership(address indexed oldOwner, address indexed newOwner);

    // Assignation du contrat au propriétaire
    
    constructor () internal {
        origOwner = msg.sender;
        emit TransferOwnership(address(0), origOwner);
    }

    // LFonction permettant de récupérer l'adresse du propriétaire du contrat
    
    function ownerLookup() public view returns (address) {
        return origOwner;
    }

    // Gestion des droits par le propriétaire
    
    modifier onlyOwner() {
        require(EstProprietaire());
        _;
    }

    // Fonction permettant de vérifier que l'adresse appelé appartiene bien à la bonne personne 
    
    function EstProprietaire() public view returns (bool) {
        return msg.sender == origOwner;
    }

    // Définition de la fonction permettant de retirer les droits du propriétaire du contrat
    
    function SuppProprieter() public onlyOwner {
        emit TransferOwnership(origOwner, address(0));
        origOwner = address(0);
    }

    // Définition d'une fonction publique permettant le changement de propriétaire (tout le monde peut attribuer des droits)
    
    function ChangementPropriter(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    // Définition d'une fonction locale permettant le changement de propriétaire (seulement le propriétaire peut attribuer des droits)
    
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit TransferOwnership(origOwner, newOwner);
        origOwner = newOwner;
    }
}
