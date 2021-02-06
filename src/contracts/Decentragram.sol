pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  //store Images
  //uint is the key and the value is the actual image
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  //struct datatypes allow you to create multiple datatypes inside
  struct Image {
    uint id;  //unsigned integer, so basically in can't be negative
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //create Image posts
  function uploadImage( string memory _imgHash, string memory _description ) public {
    //require evaluates if its true, if false it will stop the execution.
    require(bytes(_description).length > 0);//make sure image desc is not blank
    require(bytes(_imgHash).length > 0);//make sure image hash is not blank
    require(msg.sender != address(0x0));//make sure sender address is not blank

    //increment image id
    imageCount ++;

    //add image to contract
    images[imageCount] = Image(imageCount,_imgHash, _description, 0, msg.sender);//Image(1,'abc123', 'Hellow World!', 0, address(0x0));

    //Trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  //tip images
  function tipImageOwner(uint _id) public payable{ //payable is used whenever we want to send crypto in a function
    //make sure image is valid
    require(_id > 0 && _id <= imageCount);

    //Fetch image
    Image memory _image = images[_id]; //we use memory because it is in memory, not in the blockchain
    //Fetch the author
    address payable _author = _image.author;

    //address(_author).transfer(1 ether)
    //pay the author by sending them ether
    address(_author).transfer(msg.value);

    //Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;

    //Update the image
    images[_id] = _image;

    //Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }

}
