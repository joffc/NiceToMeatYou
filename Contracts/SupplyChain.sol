pragma solidity >=0.4.24;

// appelle des fichiers, contract
import './Ownable.sol';
import './Farmer.sol';
import './Distributor.sol';
import './Retailer.sol';
import './Label.sol';


// Déclaration du contrat 'SupplyChain'
contract SupplyChain is Ownable,FarmerRole,DistributorRole,RetailerRole,Label {

  // Déclaration du proprietaire
  address owner;

  // Déclaration de la variable meatId équivalent au code bar d'un produit
  uint  meatID;

  // Déclaration d'un mapping entre meatID et chaque item.
  mapping (uint => Item) items;
  
  //Déclaration d'un mapping pour suivre l'historique du produit
  mapping (uint => Txblocks) itemsHistory;

  // Définition des étapes
  enum State
  {
    ProduceByFarmer,         // 0
    ShippedByFarmer,         // 1
    ReceivedByDistributor,   // 2
    ProcessedByDistributor,  // 3
    ShippedByDistributor,    // 4
    ReceivedByRetailer      // 5
    }
    
    //Définition pour la validation du label 
    enum Lab
    {
        ReceivedByLabel,         //I0
        ValidatedByLabel         //I1
    }

  // State et Lab par default
  State constant defaultState = State.ProduceByFarmer; // par défaut prduit par le Farmer
  Lab constant defaultLab = Lab.ReceivedByLabel;

  // Déclaration de la structure 'Item' avec les champs suivant:
  
  struct Item {
    uint    meatID;                  // Numéro de lot assigné par le producteur, équivalent à un code bar qui peut être vérifier par le client
    address ownerID;                // Adressse Metamask-Ethereum du propriétaire du produit à un instant t
    address originFarmerID;         // Adresse Metamask-Ethereum du producteur
    string  originFarmName;         // Nom du producteur
    string  originFarmInformation;  // Orifine de la viande (région)
    string  originMeatType;         // Type de viande (boeuf, veau ...)
    uint256 productDate;            // Date de production /////////// mais pour le moment c'est pas une forme compréhensible
    State   itemState;              // Avancement du produit dans la chaine de productin et distribution
    Lab     itemLab;                // Avancement de la validation du label
    address distributorID;          // Adresse Metamask-Ethereum du Distributeur
    address labelID;                // Adresse Metamask-Ethereum du Label
    address retailerID;             // Adresse Metamask-Ethereum du Détaillant
  }

// Block number stuct

  struct Txblocks {
    uint FTD; // farmer To Distributor
    uint DTR; // Distributor To Retailer
  }

// les event vont être lié aux étapes 
event ProduceByFarmer(uint meatID);         //0
event ShippedByFarmer(uint meatID);         //1
event ReceivedByDistributor(uint meatID);   //2
event ReceivedByLabel(uint meatID);         //I1
event ValidatedByLabel(uint meatID);        //I2
event ShippedByDistributor(uint meatID);    //3
event ReceivedByRetailer(uint meatID);      //4


  // Verifie que celui qui effectue une action sur le contrat est le propriétairedu contrat 
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Vérifie que celui qui effectue l'action est bien le propriétaire du contract
  modifier verifyCaller (address _address) {
    require(msg.sender == _address);
    _;
  }
/*
Item State Modifiers
Permet du mettre des barrières si une étape veut être passer sur le contrat suivant
*/
  modifier producedByFarmer(uint _meatID) {
    require(items[_meatID].itemState == State.ProduceByFarmer);
    _;
  }

  modifier shippedByFarmer(uint _meatID) {
    require(items[_meatID].itemState == State.ShippedByFarmer);
    _;
  }

  modifier receivedByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ReceivedByDistributor);
    _;
  }
  
  modifier receivedByLabel(uint _meatID) {
    require(items[_meatID].itemLab == Lab.ReceivedByLabel);
    _;
  }
  
 modifier validatedByLabel(uint _meatID) {
    require(items[_meatID].itemLab == Lab.ValidatedByLabel);
    _;
  }
  
  modifier shippedByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ShippedByDistributor);
    _;
  }

 
  modifier receivedByRetailer(uint _meatID) {
    require(items[_meatID].itemState == State.ReceivedByRetailer);
    _;
  }

// constructeur du propriétaire et du meatID 
  constructor() public {
    owner = msg.sender;
    meatID = 1;
  }

/*
 Etape 1 : Autorisation pour le producteur à produire de la viande
*/
  function NouvelleViande(uint _meatID, string memory _originFarmName, string memory _originFarmInformation, string memory _originMeatType) public
    onlyFarmer() // check address belongs to farmerRole
    {

    address distributorID;   // adresse vide du distributeur
    address labelID;         // celle du label
    address retailerID;      // celle du détaillant
    
    Item memory newProduce;  // Creéation d'une nouvelle structure en mémoire
    
    newProduce.meatID = _meatID;                                 //meatID généré par le producteur, pouvant être vérifié par le client
    newProduce.ownerID = msg.sender;                             // Adresse Metamask-Ethereum du propriétaire du produit à un instant t
    newProduce.originFarmerID = msg.sender;                      // Adresse Metamask-Ethereum du propriétaire
    newProduce.originFarmName = _originFarmName;                 // Nom du producteur
    newProduce.originFarmInformation = _originFarmInformation;   // Information du l'origine du produit 
    newProduce.originMeatType = _originMeatType;                 // type de viande
    newProduce.productDate = now;                                // date 
    newProduce.itemState = defaultState;                         // État du produit tel que représenté dans l'énumération ci-dessus
    newProduce.itemLab = defaultLab;                             // Etat de la validation du Label (0 ou 1)
    newProduce.distributorID = distributorID;                    // Adresse Metamask-Ethereum du distributeur
    newProduce.labelID = labelID;                                // Adresse Metamask-Ethereum du Label
    newProduce.retailerID = retailerID;                          // Adresse Metamask-Ethereum du détaillant
    
    items[_meatID] = newProduce;                                 // Ajout d'un nouveau produit à la structure 'items' en fonction du 'meatID'
    uint placeholder;                                            // Numéro de block de stockage
    Txblocks memory txBlock;                                     // Création d'une nouvelle structure txBlock
    txBlock.FTD = placeholder;                                   // Assignation d'un valeur de stockage
    txBlock.DTR = placeholder;                                   
    itemsHistory[_meatID] = txBlock;                             // Ajout du txBlock à l'historique 'itemsHistory' mappé par 'meatID'

    // Emettre l'évènement approprié comme pousser une info préalablement remplie
    emit ProduceByFarmer(_meatID);

  }

  /*
 Etape 2 : Autorisation pour le producteur à envoyer la viande au distributeur 
  */
  function ExpeditionProducteur(uint _meatID, address distributorIDD, address labelIDD) public
    onlyFarmer()                                      // Vérifie que celui qui effectue est bien un producteur cette action vient d'un modifier au dessus qui s'appelle onlyFarmer
    producedByFarmer(_meatID)                         // Vérifie que le producteur à bien crée le produit (assure le bon suivie)
    verifyCaller(items[_meatID].originFarmerID)       // Vérifie que celui qui effectue l'action est bien le propriétaire du contract
    {
        items[_meatID].distributorID = distributorIDD;     // met à jour les droits sur le contrat
        items[_meatID].labelID = labelIDD;                 //met à jour les droit du label
        items[_meatID].itemState = State.ShippedByFarmer; // met à jour l'étape
        itemsHistory[_meatID].FTD = block.number;         // ajout du numéro du bloc
        emit ShippedByFarmer(_meatID);                    // pousse les mises à jours suivant le meatID 
  }
  
    /*
 Etape Intermédiare 1 : Autoriser le label à recevoir la viande
  */
  function RecuLabel(uint _meatID) public
    onlyLabel() 
    shippedByFarmer(_meatID)
    verifyCaller(items[_meatID].labelID) 
    {
    items[_meatID].itemLab = Lab.ReceivedByLabel; 
    emit ReceivedByLabel(_meatID);
  }
  
 /*
 Etape Intermédiare 2 : Validation de la qualité du produit
  */
  function ValidationLabel(uint _meatID) public
    onlyLabel() 
    receivedByLabel(_meatID)
    verifyCaller(items[_meatID].labelID) 
    {
    items[_meatID].itemLab = Lab.ValidatedByLabel;
    emit ValidatedByLabel(_meatID);
  }
  
  /*
 Etape 3 : Autoriser le distributeur à recevoir la viande
  */
  function RecuDistributeur(uint _meatID) public
    onlyDistributor() 
    shippedByFarmer(_meatID)
    verifyCaller(items[_meatID].distributorID) 
    {
    items[_meatID].itemState = State.ReceivedByDistributor; 
    emit ReceivedByDistributor(_meatID);
  }

  /*
Etape 4 : Autoriser le distributeur à envoyer de la viande
  */
  function ExpeditionDistributeur(uint _meatID, address retailerIDD) public
    onlyDistributor() 
    receivedByDistributor(_meatID)
    validatedByLabel(_meatID)
    verifyCaller(items[_meatID].distributorID) 
    {
        items[_meatID].retailerID = retailerIDD; 
        items[_meatID].itemState = State.ShippedByDistributor; 
        itemsHistory[_meatID].DTR = block.number;
        emit ShippedByDistributor(_meatID);
  }

  /*
  Etape 5 : Autoriser le détaillant à recevoir la viande
  */
  function RecuDetaillant(uint _meatID) public
    onlyRetailer() 
    shippedByDistributor(_meatID)
    verifyCaller(items[_meatID].retailerID)
    {
        items[_meatID].itemState = State.ReceivedByRetailer;
        emit ReceivedByRetailer(_meatID);
  }


  // Declaration d'une fonction 'rechercheHistorique' permettant de chercher les données implémentées c'est à dire le suivi du produit
  function RechercheHistorique(uint _meatID) public view returns
    (
      uint    itemMeatID,
      address ownerID,
      address originFarmerID,
      string memory  originFarmName,
      string memory originFarmInformation,
      string memory originMeatType,
      uint productDate,
      State   itemState,
      Lab   itemLab,
      address distributorID,
      address labelID,
      address retailerID
    )
    {
      // Assigner des valeurs aux paramètres
      Item memory item = items[_meatID];
      
    return
    (
        item.meatID,
        item.ownerID,
        item.originFarmerID,
        item.originFarmName,
        item.originFarmInformation,
        item.originMeatType,
        item.productDate,
        item.itemState,
        item.itemLab,
        item.distributorID,
        item.labelID,
        item.retailerID
    );

    }
    
    // Declaration d'un fontion 'numeroBlock' généré par les mineurs pour tracer les blocks executant le code
  function NumeroBlock(uint _meatID) public view returns
    (
      uint blockfarmerToDistributor,
      uint blockDistributorToRetailer
    )
    {
      // Assigner des valeurs aux paramètres
      Txblocks memory txblock = itemsHistory[_meatID];
      
    return
    (
        txblock.FTD,
        txblock.DTR
    );

    }
  }
