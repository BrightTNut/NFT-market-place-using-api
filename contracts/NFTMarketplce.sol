// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//FOR CHEAK WHOLE CODE
//APPROX 53 MIN VIDEO OF Solidity Smart Contract For NFT Marketplace | Full-Stack NFT Marketplace Project (Smart Contract) BY Daulat Hussain
//LINK  (https://www.youtube.com/watch?v=vbs-_cVWXjY&list=PLWUCKsxdKl0olgEF4OxXVk2B-jwpGqL5d&index=2)


///INTERNAL IMPORT FOR NFT OPENZIPLLI
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721URISStorage.sol";
import "hardhat/console.sol";
contract NFTMarketplace is ERC721URIStorage{
    using Counter for Counter.Counter;

    Counter.Counter private_tokenIds;
    Counter.Counter private_itmesSold;
    uint256 listingPrice = 0.0025 ether;
    address payable owner;

    mapping(uint256 => MarketItem) private idMarketItem;

    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
        }

        event MarketItemCreated(
            uint256 indexed tokenId,
            address seller,
            address owner,
            uint256 price,
            bool sold
        );

       modifier onlyOwner(){
        require(msg.sender == owner,
        "omly owner of market place can change listing of item");
       _;}
        constructor() ERC721("NFT Meta Token", "MYNFT"){
            owner == payable(msg.sender);

        }
     
      function updateListingPrice(uint256 _listingPrice) public payable onlyOwner     
{
      listingPrice = _lisitingPrice;
      }
   
    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }
  // let create NFTtoken function

  function createToken(string memory tokenURI, uint256 price) public payable returns (uint256)
  {
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    _mint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, tokenURI);
    createMarketItem(newTokenId, price);
    return newTokenId;

  } 
  
  //creating maket items
  function createMarketItem(uint256 tokenId, uint256 price) private{
    require(price>0,"price must be atleast 1");
    require(msg.value == listingPrice, "price atleat listing equal");

    idMarketItem[tokenId] = MarketItem(
        tokenId,
        payable(msg.sender),
        payable(address(this)),
        price,
        false
    );

    _transfer(msg.sender , address(this), tokenId);

    emit MarketItemCreated(tokenId, msg.sender , address(this) , price , false);

  }

  //function for resele token
  function reSellerToken(uint256 tokenId, uint256 price) public payable{
    require(idToMarketItem[tokenId].owner == msg.sender,  "only item owner can do this");
  
  require(msg.sender == listingPrice, "pay price pls");

  idMarketItem[tokenId].sold = false;
  idMarketItem[tokenId].price = price;
  idMarketItem[tokenId].seller = payable(msg.sender);
  idMarketItem[tokenId].owner = payable(address(this));

  _itemSold.decrement();
   

    _transfer(msg.sender , address(this), tokenId);

  }


//function create  market sale

function createMarketSale(uint256 tokenId) public payable{
    uibt256 price = idMarketItem[tokenId].price;
    require(msg.sender == price,
    "pls pay "
    );

   
  
  idMarketItem[tokenId].owner = payable(msg.sender);
  idMarketItem[tokenId].sold = true;
  idMarketItem[tokenId].owner = payable(address(0));

  _itemSold.increment();

  _transfer(address(this), msg.sender, tokenId);

   payable(owner).transfer(listingPrice);
   payable(idMarketItem[tokenId].seller).transfer(msg.value);
   }

   //getting unsold nft data

   function fetchMarketItem() public view returns(MarketItem[] memory){
    uint256 itemCount  = _tokenIds.current();
    uint256 unSoldItemCount = _tokenIds.current(); - _itemSold.current();

    uint256 currentIndex = 0;

    MarketItem[] memory items = new MarketItem[](unSoldItemCount);
    for(uint256 i = 0; i < itemCount ; i++){
      if(idMarketItem[i + 1].owner == address(this)){
        uint256 currentId = i + 1;

        MarketItem storage currentItem = idMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
   }

   //purches item

   function fetchMyNFT() public view returns(MarketItem[] memory){
    uint256 totalCount = _tokenIds.current();
    uintr256 itemCount = 0;
    uint256 currentIndex = 0;

    for(uint256 i = 0; i< totalCount; i++){
      if(idMarketItem[i+1].owner == msg.sender){
        itemCount += 1;
      }
 
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for(uint256 o = 0 ; i<totalCount; i++){

      if(idMarketItem[i + 1].owner == msg.sender){
      uint256 currentId = i +1;
      MarketItem storage currentItem = idMaketItem[currentId];
      items[currentIndex] = currentItem;
      currentIndex += 1;
      }
    }
    return items;
   }

   //singul user items

   function fetchItemListed() public view returns(MarketItem memory){
    uint256 totalCount = _token.current();
    uint256 itemCount = 0;
    uint256 currentIndex = 0;

    for(uint256 i =0 ; i < totalCount; i ++){
      if(idMarketItem[i+1].seller = msg.sender){
        itemCount += 1;
      }
    }
    MarketItem[] memory items = new MarketItem[](itemCount);
     for(uint256 i = 0; i < totalCount; i ++){
      if(idMarketItem[i+1].seller = msg.sender){
        uint256 currentId = i + 1;

        MarketItem storage currentItem = idMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
     }
     return items;
   }
}