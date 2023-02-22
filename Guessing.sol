// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// import "@openzeppelin/contracts/utils/math/Math.sol";
// import "@openzeppelin/contracts/utils/math/SignedMath.sol";

contract Guessing {
    // using SignedMath for uint;

    mapping(address => uint) balances;
    mapping(address => uint) guesses;
    address winner;
    address[] orderGuessing = new address[](0);
    uint val;
    uint public number;
    address Owner;

    constructor(){
        Owner = msg.sender;
        val = 2**256-1;
    }

    modifier isOwner(bool f){
        require((msg.sender==Owner)==f);
        _;
    }

    modifier justOne(){
        require(balances[msg.sender] == 0,"you can guess just once");
        _;
    }

    modifier posAmount(){
        require(msg.value>0,"You have to put your fund");
        _;
    }

    function sub(uint a,uint b)internal pure returns(uint){
        if(a>b)return a-b;
        else return b-a;
    }

    function min(uint a,uint b)internal pure returns(uint){
        if(a<b)return a;
        else return b;
    }

    function changeNumber(uint _number)public isOwner(true) {
        // require(msg.sender)
        number = _number;
    }

    function guess(uint _num)public payable justOne posAmount isOwner(false){
        // require(msg.sender != Owner,"owner mustn't guess");
        guesses[msg.sender] = _num;
        balances[msg.sender] += msg.value;
        orderGuessing.push(msg.sender);
    }

    function getResult()public payable isOwner(true) returns(address,uint){
        
        
        for(uint i = 0; i < orderGuessing.length ; i++ ){
            address addr = orderGuessing[i];
            uint diff = sub(number , guesses[msg.sender]);
            
            if(diff < val){
                val = diff;
                winner = addr;
            }
        }
       

        payable(winner).transfer(address(this).balance);
        
        return (winner,guesses[winner]);
    }

    function reset()public{
        val = 2**256-1;
        number = 0;
        for(uint i = 0; i < orderGuessing.length ; i++ ){
            address addr = orderGuessing[i];
            balances[addr] = 0;
        }
        for(;orderGuessing.length>0;){
            orderGuessing.pop();
        }
    }

    function test()public view returns(uint256){
        return guesses[msg.sender];
    }

}
