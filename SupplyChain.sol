pragma solidity >=0.4.24 ;

 

// inherited contracts
import './Ownable.sol';
import './FarmerRole.sol';
import './DistributorRole.sol';
import './RetailerRole.sol';
import './ConsumerRole.sol';

 


// Define a contract 'Supplychain'
contract SupplyChain is Ownable,FarmerRole,DistributorRole,RetailerRole,ConsumerRole {


  // Définition du proprietaire
  address owner;


  // Define a variable called 'upc' for Universal Product Code (UPC)
  //uint  upc;
  
  //Declaration de la variable MeatID (équivalent au code barre)
  uint meatID;
  
  // Define a variable called 'sku' for Stock Keeping Unit (SKU)
  //uint  sku;


  // Declaration du mapping entre MeatID et un item
  mapping (uint => Item) items;

 

  // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash,
  // that track its journey through the supply chain.
  
  //Definit un mapping "ItemHistory" entre MeatID 
  
  mapping (uint => Txblocks) itemsHistory;

 

  // Define enum 'State' with the following values:
  enum State
  {
    ProduceByFarmer,         // 0
    //ForSaleByFarmer,         // 1
    //PurchasedByDistributor,  // 2
    ShippedByFarmer,         // 3
    ReceivedByDistributor,   // 4
    ProcessedByDistributor,  // 5
    //PackageByDistributor,    // 6
    //ForSaleByDistributor,    // 7
    //PurchasedByRetailer,     // 8
    ShippedByDistributor,    // 9
    ReceivedByRetailer,      // 10
    //ForSaleByRetailer,       // 11
    PurchasedByConsumer      // 12
    }

 


  State constant defaultState = State.ProduceByFarmer;

 

  // Declaration de la structure de l'item : 
  struct Item {
    //uint    sku;                  // Stock Keeping Unit (SKU)
    uint    meatID;                 // Numéro de lot assigné par le producteur (équivalent code barre)
    address ownerID;                // Adresse Metamask-Ethereum du proprietaire
    address originFarmerID;         // Adresse Metamask-Ethereum du producteur
    string  originFarmName;         // Nom du producteur
    string  originFarmInformation;  // Région du producteur
    //string  originFarmLatitude;     // Farm Latitude
    //string  originFarmLongitude;    // Farm Longitude
    //uint    productID;              // Product ID potentially a combination of upc + sku
    //string  productNotes;           // Product Notes
    uint256 productDate;            // Date de production de la viande
    //uint    productPrice;           // Product Price
    //uint    productSliced;          // Parent cheese
    State   itemState;              //Avancement du produit dans la chaine de production-distribution
    address distributorID;          // Adresse Metamask-Ethereum du distributeur
    address retailerID;             // Adresse Metamask-Ethereum du detaillant
    address consumerID;             // adresse Metamask-Ethereum 
  }

 

// Block number stuct
  struct Txblocks {
    uint FTD; // blockfarmerToDistributor
    uint DTR; // blockDistributorToRetailer
    uint RTC; // blockRetailerToConsumer
  }

 


event ProduceByFarmer(uint meatID);         //0
//event ForSaleByFarmer(uint meatID);         //1
//event PurchasedByDistributor(uint meatID);  //2
event ShippedByFarmer(uint meatID);         //3
event ReceivedByDistributor(uint meatID);   //4
//event ProcessedByDistributor(uint meatID);  //5
//event PackagedByDistributor(uint meatID);   //6
//event ForSaleByDistributor(uint meatID);    //7
//event PurchasedByRetailer(uint meatID);     //8
event ShippedByDistributor(uint meatID);    //9
event ReceivedByRetailer(uint meatID);      //10
//event ForSaleByRetailer(uint meatID);       //11
event PurchasedByConsumer(uint meatID);     //12

 


  // Define a modifer that checks to see if msg.sender == owner of the contract
  //Declare un modifier qui vérifie sur le msg.sender est le proprietaire du contrat 
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

 

  // Define a modifer that verifies the Caller
  //
  modifier verifyCaller (address _address) {
    require(msg.sender == _address);
    _;
  }

 

//Item State Modifiers
  modifier producedByFarmer(uint _meatID) {
    require(items[_meatID].itemState == State.ProduceByFarmer);
    _;
  }

 

  //modifier forSaleByFarmer(uint _upc) {
   // require(items[_upc].itemState == State.ForSaleByFarmer);
   // _;
 // }

 

  //modifier purchasedByDistributor(uint _meatID) {
    //require(items[_upc].itemState == State.PurchasedByDistributor);
    //_;
  //}

 

  modifier shippedByFarmer(uint _meatID) {
    require(items[_meatID].itemState == State.ShippedByFarmer);
    _;
  }

 

  modifier receivedByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ReceivedByDistributor);
    _;
  }

 

 /* modifier processByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ProcessedByDistributor);
    _;
  }
*/
 

  /* packagedByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.PackageByDistributor);
    _;
  }
  */
  

 

  /*modifier forSaleByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ForSaleByDistributor);
    _;
  }

 */


  modifier shippedByDistributor(uint _meatID) {
    require(items[_meatID].itemState == State.ShippedByDistributor);
    _;
  }

 

  /*modifier purchasedByRetailer(uint _meatID) {
    require(items[_meatID].itemState == State.PurchasedByRetailer);
    _;
  }
*/
 

  modifier receivedByRetailer(uint _meatID) {
    require(items[_meatID].itemState == State.ReceivedByRetailer);
    _;
  }

 

  /*modifier forSaleByRetailer(uint _meatID) {
    require(items[_upc].itemState == State.ForSaleByRetailer);
    _;
  }
*/
 

  modifier purchasedByConsumer(uint _meatID) {
    require(items[_meatID].itemState == State.PurchasedByConsumer);
    _;
  }

 

// constructor setup owner sku upc
  constructor() public /*payyable*/ {
    owner = msg.sender;
    //sku = 1;
    meatID = 1;
  }

 

/*
 1st step in supplychain
 Autorisation du producteur a produire de la viande 
*/

  function produceItemByFarmer(uint _meatID, string memory _originFarmName, string memory _originFarmInformation /*string memory _originFarmLatitude, string memory _originFarmLongitude, string memory _productNotes, uint _price*/) public
    onlyFarmer() // check address belongs to farmerRole
    {

 

    address distributorID; // Empty distributorID address
    address retailerID; // Empty retailerID address
    address consumerID; // Empty consumerID address
    Item memory newProduce; // Create a new struct Item in memory
    //newProduce.sku = sku;  // Stock Keeping Unit (SKU)
    newProduce.meatID = _meatID; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
    newProduce.ownerID = msg.sender;  // Metamask-Ethereum address of the current owner as the product moves through 8 stages
    newProduce.originFarmerID = msg.sender; // Metamask-Ethereum address of the Farmer
    newProduce.originFarmName = _originFarmName;  // Farmer Name
    newProduce.originFarmInformation = _originFarmInformation; // Farmer Information
    //newProduce.originFarmLatitude = _originFarmLatitude; // Farm Latitude
    //newProduce.originFarmLongitude = _originFarmLongitude;  // Farm Longitude
    //newProduce.productID = _upc+sku;  // Product ID
    //newProduce.productNotes = _productNotes; // Product Notes
    //newProduce.productPrice = _price;  // Product Price
    newProduce.productDate = now;
    //newProduce.productSliced = 0;
    newProduce.itemState = defaultState; // Product State as represented in the enum above
    newProduce.distributorID = distributorID; // Metamask-Ethereum address of the Distributor
    newProduce.retailerID = retailerID; // Metamask-Ethereum address of the Retailer
    newProduce.consumerID = consumerID; // Metamask-Ethereum address of the Consumer // ADDED payable
    items[_meatID] = newProduce; // Add newProduce to items struct by meatID
    uint placeholder; // Block number place holder
    Txblocks memory txBlock; // create new txBlock struct
    txBlock.FTD = placeholder; // assign placeholder values
    txBlock.DTR = placeholder;
    txBlock.RTC = placeholder;
    itemsHistory[_meatID] = txBlock; // add txBlock to itemsHistory mapping by upc

 

    // Increment sku
    //sku = sku + 1;

 

    // Emit the appropriate event
    emit ProduceByFarmer(_meatID);

 

  }

 

/*
2nd step in supplychain
Allows farmer to sell cheese

  function sellItemByFarmer(uint _upc, uint _price) public
    onlyFarmer() // check msg.sender belongs to farmerRole
    producedByFarmer(_upc) // check items state has been produced
    verifyCaller(items[_upc].ownerID) // check msg.sender is owner
    {
      items[_upc].itemState = State.ForSaleByFarmer;
      items[_upc].productPrice = _price;
      emit ForSaleByFarmer(_upc);
  }
*/
 

/*
3rd step in supplychain
Allows distributor to purchase cheese

  function purchaseItemByDistributor(uint _upc) public 
    onlyDistributor() // check msg.sender belongs to distributorRole
    forSaleByFarmer(_upc) // check items state is for ForSaleByFarmer
    {

 

    items[_upc].ownerID = msg.sender; // update owner
    items[_upc].distributorID = msg.sender; // update distributor
    items[_upc].itemState = State.PurchasedByDistributor; // update state
    itemsHistory[_upc].FTD = block.number; // add block number
    emit PurchasedByDistributor(_upc);

 

  }
*/
 

  /*
  4th step in supplychain
  Allows farmer to ship meat purchased by distributor
  */
  function shippedItemByFarmer(uint _meatID) public 
    onlyFarmer() // check msg.sender belongs to FarmerRole
    producedByFarmer(_meatID)
    verifyCaller(items[_meatID].originFarmerID) // check msg.sender is originFarmID
    {
    items[_meatID].itemState = State.ShippedByFarmer; // update state
    emit ShippedByFarmer(_meatID);
  }

  

  /*
  5th step in supplychain
  Allows distributor to receive meat
  */
  function receivedItemByDistributor(uint _meatID) public
    onlyDistributor() // check msg.sender belongs to DistributorRole
    shippedByFarmer(_meatID)
    verifyCaller(items[_meatID].ownerID) // check msg.sender is owner
    {
    items[_meatID].itemState = State.ReceivedByDistributor; // update state
    emit ReceivedByDistributor(_meatID);
  }

 

  /*
  6th step in supplychain
  Allows distributor to process cheese
  
  function processedItemByDistributor(uint _meatID) public
    onlyDistributor() // check msg.sender belongs to DistributorRole
    receivedByDistributor(_upc)
    verifyCaller(items[_upc].ownerID) // check msg.sender is owner
    {
    items[_upc].itemState = State.ProcessedByDistributor; // update state
    items[_upc].productSliced = slices; // add slice amount
    emit ProcessedByDistributor(_upc);
  }
*/ 
 

  /*
  7th step in supplychain
  Allows distributor to package cheese
  
  function packageItemByDistributor(uint _upc) public
    onlyDistributor() // check msg.sender belongs to DistributorRole
    processByDistributor(_upc)
    verifyCaller(items[_upc].ownerID) // check msg.sender is owner
    {
    items[_upc].itemState = State.PackageByDistributor;
    emit PackagedByDistributor(_upc);
  }
*/
 

  /*
  8th step in supplychain
  Allows distributor to sell cheese
  
  function sellItemByDistributor(uint _upc, uint _price) public
    onlyDistributor() // check msg.sender belongs to DistributorRole
    packagedByDistributor(_upc)
    verifyCaller(items[_upc].ownerID) // check msg.sender is owner
    {
        items[_upc].itemState = State.ForSaleByDistributor;
        items[_upc].productPrice = _price;
        emit ForSaleByDistributor(upc);
  }

 */

  /*
  9th step in supplychain
  Allows retailer to purchase cheese
  
  function purchaseItemByRetailer(uint _upc) public 
    onlyRetailer() // check msg.sender belongs to RetailerRole
    forSaleByDistributor(_upc)
    {
    items[_upc].ownerID = msg.sender;
    items[_upc].retailerID = msg.sender;
    items[_upc].itemState = State.PurchasedByRetailer;
    itemsHistory[_upc].DTR = block.number;
    emit PurchasedByRetailer(_upc);
  }

*/

  /*
  10th step in supplychain
  Allows Distributor to
  */
  function shippedItemByDistributor(uint _meatID) public
    onlyDistributor() // check msg.sender belongs to DistributorRole
    receivedByDistributor(_meatID)
    verifyCaller(items[_meatID].distributorID) // check msg.sender is distributorID
    {
      items[_meatID].itemState = State.ShippedByDistributor;
      emit ShippedByDistributor(_meatID);
  }

 

  /*
  11th step in supplychain
  */
  function receivedItemByRetailer(uint _meatID) public
    onlyRetailer() // check msg.sender belongs to RetailerRole
    shippedByDistributor(_meatID)
    verifyCaller(items[_meatID].ownerID) // check msg.sender is ownerID
    {
      items[_meatID].itemState = State.ReceivedByRetailer;
      emit ReceivedByRetailer(_meatID);
  }

 

  /*
  12th step in supplychain
  
  function sellItemByRetailer(uint _upc, uint _price) public
    onlyRetailer()  // check msg.sender belongs to RetailerRole
    receivedByRetailer(_upc)
    verifyCaller(items[_upc].ownerID) // check msg.sender is ownerID
    {
      items[_upc].itemState = State.ForSaleByRetailer;
      items[_upc].productPrice = _price;
      emit ForSaleByRetailer(_upc);
  }
*/
 

  /*
  13th step in supplychain
  */
  function purchaseItemByConsumer(uint _meatID) public 
    onlyConsumer()  // check msg.sender belongs to ConsumerRole
    receivedByRetailer(_meatID)
    verifyCaller(items[_meatID].ownerID) // check msg.sender is ownerID
    {
      items[_meatID].consumerID = msg.sender;
      items[_meatID].ownerID = msg.sender;
      items[_meatID].consumerID = msg.sender;
      items[_meatID].itemState = State.PurchasedByConsumer;
      itemsHistory[_meatID].RTC = block.number;
    emit PurchasedByConsumer(_meatID);
  }

 
  // Define a function 'fetchItemBufferOne' that fetches the data
  function fetchItemBufferOne(uint _meatID) public view returns
    (
    //uint    itemSKU,
    uint    itemMeatID,
    address ownerID,
    address originFarmerID,
    string memory  originFarmName,
    string memory originFarmInformation,
    //string memory originFarmLatitude,
    //string memory originFarmLongitude,
    uint productDate
    //uint productSliced
    )
    {
    // Assign values to the 8 parameters
    Item memory item = items[_meatID];

 

    return
    ( 
      //item.sku,
      item.meatID,
      item.ownerID,
      item.originFarmerID,
      item.originFarmName,
      item.originFarmInformation,
      //item.originFarmLatitude,
      //item.originFarmLongitude,
      item.productDate
      //item.productSliced
    );
  }


  /* Define a function 'fetchItemBufferTwo' that fetches the data */ 
  
  function fetchItemBufferTwo(uint _meatID) public view returns 
    (
    //uint    itemSKU,
    uint    itemMeatID,
    //uint    meatID,
    //string  memory productNotes,
    //uint    productPrice,
    uint256 productDate,
    State   itemState,
    address distributorID,
    address retailerID,
    address consumerID
    )
    {
      // Assign values to the 9 parameters
    Item memory item = items[_meatID];



    return
    (
      //item.sku,
      item.meatID,
     // item.productID,
      //item.productNotes,
      //item.productPrice,
      item.productDate,
      item.itemState,
      item.distributorID,
      item.retailerID,
      item.consumerID
    );


  }

 

  // Define a function 'fetchItemHistory' that fetaches the data
  function fetchitemHistory(uint _meatID) public view returns
    (
      uint blockfarmerToDistributor,
      uint blockDistributorToRetailer,
      uint blockRetailerToConsumer
    )
    {
      // Assign value to the parameters
      Txblocks memory txblock = itemsHistory[_meatID];
      return
      (
        txblock.FTD,
        txblock.DTR,
        txblock.RTC
      );

 

    }

 

  }
