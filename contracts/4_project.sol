// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;



contract local{

address owner;

constructor (){

    owner = msg.sender;

}




//Checking the balance of contract

function get_balance() public view returns(uint){
    return address(this).balance;
}


//Transfering the money collected to owner 

function remove_eth() public {

    require(msg.sender==owner);
    address payable  user = payable (owner);
    user.transfer(get_balance());

}


//Product details

struct Product {

string name;
string name_of_company;
address payable company_owner;
uint expiry;
bool expiry_status;
uint uuid;
uint cost;  //This is in ether too 
bool sold; // By default it is false only

}

mapping (uint=>Product) public no_of_products;
uint nth_product=0;


//Registering new prodcuts

function register(string memory _name, string memory _name_of_company,address payable  _company_owner,uint _expiry,uint _uuid, uint _cost)public payable  
{


Product storage newproduct = no_of_products[nth_product];
nth_product++;

newproduct.name = _name;
newproduct.name_of_company = _name_of_company;
newproduct.company_owner = _company_owner;
newproduct.expiry = _expiry;
newproduct.uuid = _uuid;
newproduct.cost = _cost;

require(msg.value == (5*(_cost)/100),"Please pay the only 5% of your product cost");


}







//Users data

struct Users{

address user_address;
string name;
string password;   //This is the password of user thriugh which he wil login.This will be 12 characters long  

}

mapping (uint => Users) private no_of_users;   //For storing the no of users
uint nth_user;   //This  will also uniquely represent each user

bool status_of_login=false;  //THis is necesssary consition to check that users login before sacnning qr





//Sign up for first time users

function sign_in(address _user_address, string memory _name, string memory _password) public 
{

    Users storage new_user = no_of_users[nth_user];
    nth_user++;

    new_user.user_address = _user_address;
    new_user.name = _name;
    new_user.password = _password;
    status_of_login = true;
}

// Login 

function login(address _user_address,string memory _password)public 
{

//Here i will get only address and then i will run a for loop and check for that address in whole no_of_users mapping . But this is making more gas 


    Users storage this_user = no_of_users[nth_user];
    this_user.user_address = _user_address;
    this_user.password = _password;


    status_of_login = true;



}





//Scaning the QR code 


function scan_qr() public view returns(uint)
{



    require(status_of_login == true,"Please login first");
    //Now after scanning i will get an uuid on screen which i will compare with my all uuids in the no_of_products and according to require condition i will say my answer 
    //After veriyfu=ing the rpoduct add check its expiry too
    require(block.timestamp<expiry,"Product is expired");


    //We will return the product nth_product number which will be used in payment



    return (nth_product);
}





//Paying for the cost of product through ether

function pay_for_product() payable public  
{     

require(status_of_login == true);


    Product storage this_product = no_of_products[scan_qr()];    //We got the same product which was scanned using its nth_product number

    require(this_product.sold==false,"This product is already sold");
    require(msg.value == this_product.cost);
    this_product.sold = true;

    this_product.company_owner.transfer(this_product.cost);    //Transfering the ether back to company

}





















}