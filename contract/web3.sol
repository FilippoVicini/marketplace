// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    address payable owner;
    uint256 listingFee = 0.025 ether;
    struct Item {
        uint256 id;
        address payable seller;
        address buyer;
        string name;
        string description;
        uint256 price;
        bool sold;
    }

    Item[] public items;
    uint256 public nextItemId;

    event ItemCreated(
        uint256 id,
        address seller,
        string name,
        string description,
        uint256 price
);

    event ItemSold(
        uint256 id,
        address seller,
        address buyer,
        uint256 price
);

    constructor() {
        owner = payable(msg.sender);
    }

    function createItem(string memory _name, string memory _description, uint256 _price) public payable {
        require(msg.value == listingFee, "Must pay listing fee");
        require(_price > 0, "Price must be at least 1 wei");

        items.push(Item({
            id: nextItemId,
            seller: payable(msg.sender),
            buyer: address(0),
            name: _name,
            description: _description,
            price: _price,
            sold: false
        }));

        emit ItemCreated(nextItemId, msg.sender, _name, _description, _price);
        nextItemId++;
    }

    function buyItem(uint256 _id) public payable {
        require(_id < items.length && _id >= 0, "Item does not exist");
        Item storage item = items[_id];
        require(msg.value == item.price, "Incorrect value");
        require(!item.sold, "Item already sold");

        item.seller.transfer(msg.value);
        item.buyer = msg.sender;
        item.sold = true;

        emit ItemSold(_id, item.seller, item.buyer, item.price);
    }

    function getListingFee() public view returns(uint256) {
        return listingFee;
    }

    // Function to change listing fee (Only owner can change it)
    function setListingFee(uint256 _newFee) external {
        require(msg.sender == owner, "Only the contract owner can change the listing fee.");
        listingFee = _newFee;
    }

    // Withdraw function for the contract's owner to withdraw the accumulated fees
    function withdrawFees() external {
        require(msg.sender == owner, "Only the contract owner can withdraw fees.");
        owner.transfer(address(this).balance);
    }
}
