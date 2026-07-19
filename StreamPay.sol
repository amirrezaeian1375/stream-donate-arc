// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title StreamPayCore
 * @dev Registry and Donation platform for streamers on Arc Network
 */
contract StreamPayCore {
    
    struct Streamer {
        string username;
        string[] games;
        string avatar;
        address wallet;
        bool isRegistered;
    }

    mapping(string => Streamer) private streamers;
    mapping(address => string) public walletToUser;
    string[] public streamerList;

    event Registered(string username, address indexed wallet);
    event Donated(address indexed from, address indexed to, uint256 amount, string donorName, string message);

    function register(string memory _user, string[] memory _games, string memory _avatar) public {
        require(bytes(_user).length > 0, "Username cannot be empty");
        require(!streamers[_user].isRegistered, "Username taken");
        require(bytes(walletToUser[msg.sender]).length == 0, "Wallet already has a profile");

        streamers[_user] = Streamer({
            username: _user,
            games: _games,
            avatar: _avatar,
            wallet: msg.sender,
            isRegistered: true
        });

        walletToUser[msg.sender] = _user;
        streamerList.push(_user);

        emit Registered(_user, msg.sender);
    }

    function donate(string memory _user, string memory _donorName, string memory _message) public payable {
        require(streamers[_user].isRegistered, "Streamer not found");
        address target = streamers[_user].wallet;
        
        (bool success, ) = payable(target).call{value: msg.value}("");
        require(success, "Transfer failed");

        emit Donated(msg.sender, target, msg.value, _donorName, _message);
    }

    function getStreamer(string memory _user) public view returns (
        string memory username, 
        string[] memory games, 
        string memory avatar, 
        address wallet,
        bool isRegistered
    ) {
        require(streamers[_user].isRegistered, "Not found");
        Streamer memory s = streamers[_user];
        return (s.username, s.games, s.avatar, s.wallet, s.isRegistered);
    }

    function getStreamerCount() public view returns (uint256) {
        return streamerList.length;
    }
}
