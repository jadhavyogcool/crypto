// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;
    uint public productId;
    
    enum State { Created, InTransit, Delivered }
    State public currentState;
    
    struct Product {
        string name;
        uint quantity;
        address producer;
        address distributor;
        address retailer;
    }
    
    mapping(uint => Product) public products;

    event ProductCreated(uint productId, string name, uint quantity, address producer, address distributor, address retailer);
    event StateChanged(uint productId, State newState);
    event QuantityUpdated(uint productId, uint newQuantity);
    event OwnershipTransferred(address newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier inState(State state) {
        require(currentState == state, "Invalid state for this operation");
        _;
    }

    modifier validProduct(uint _productId) {
        require(products[_productId].producer != address(0), "Product does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProduct(string memory _name, uint _quantity, address _producer, address _distributor, address _retailer) public onlyOwner {
        productId++;
        products[productId] = Product({
            name: _name,
            quantity: _quantity,
            producer: _producer,
            distributor: _distributor,
            retailer: _retailer
        });
        
        currentState = State.Created;
        
        emit ProductCreated(productId, _name, _quantity, _producer, _distributor, _retailer);
    }

    function changeState(uint _productId, State _newState) public onlyOwner validProduct(_productId) {
        currentState = _newState;
        emit StateChanged(_productId, _newState);
    }

    function updateQuantity(uint _productId, uint _newQuantity) public onlyOwner validProduct(_productId) {
        products[_productId].quantity = _newQuantity;
        emit QuantityUpdated(_productId, _newQuantity);
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnershipTransferred(_newOwner);
    }

    function getProductDetails(uint _productId) public view returns (string memory, uint, address, address, address) {
        Product storage product = products[_productId];
        return (product.name, product.quantity, product.producer, product.distributor, product.retailer);
    }
}
