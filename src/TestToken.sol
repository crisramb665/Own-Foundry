// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts@4.5.0/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
// import "@openzeppelin/contracts@4.5.0/token/ERC1155/utils/ERC1155Holder.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MigueToken3 is ERC1155Holder, ERC1155, Ownable {
     //token indexes
    uint256 public token1 = 1;
    uint256 public token2 = 2;

    constructor() ERC1155("") {
        _mint(address(this), token1, 1000, "");
        _mint(msg.sender, token1, 100, "");
        _mint(msg.sender, token2, 1, "");
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount)
        public
    {
        // require(totalSupply.token1 < 100);
        _mint(account, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts)
        public
    {   
        // require(totalSupply.token1 < 100, "Already minted top amount");
        // require(totalSupply.token2 < 1, "Already minted top amount");
        _mintBatch(to, ids, amounts, "");
    }
}

pragma solidity ^0.8.4;

contract Tarea3 is ERC1155Holder {

    MigueToken3 public testToken;

    uint256 public totalStaked;

    struct UserInfo {
        uint256 amount1;
        uint256 amount2;
    }

    mapping(address => UserInfo) public users;

    constructor(MigueToken3 _tokenAddress, uint256 _tokenId, uint256 _amount) {
        testToken = _tokenAddress;
        testToken.mint(address(this), _tokenId, _amount);
    }

    function depositar(uint256 _tokenId, uint256 _amount) public {
        require(_tokenId == testToken.token2(), "Solo se puede depositar token2");
        UserInfo storage user = users[msg.sender];

        testToken.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "");

        user.amount2 = user.amount2 + _amount;        

        totalStaked = testToken.balanceOf(address(this), _tokenId);

        distribuirRewards();

	}

    function distribuirRewards() public {
        UserInfo storage user = users[msg.sender];

        uint256 token1Supply = testToken.balanceOf(address(this), testToken.token1());
        uint256 token1Rewards;

        if (user.amount2 >= 1) {
            token1Rewards = token1Supply / 4;
        } else {
            token1Rewards = 0;
        }

        user.amount1 = user.amount1 + token1Rewards;
       
    }

    function reclamarYRetirar() external {
        UserInfo storage user = users[msg.sender];
        
        testToken.safeTransferFrom(address(this), msg.sender, testToken.token1(), user.amount1, "");
        testToken.safeTransferFrom(address(this), msg.sender, testToken.token2(), user.amount2, "");

        user.amount1 = 0;
        user.amount2 = 0;

    }
}
