// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title StreamPayCore
 * @dev Registry for streamers on the Arc Network
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

    event StreamerRegistered(string username, address wallet);

    function register(string memory _user, string[] memory _games, string memory _avatar) public {
        require(bytes(_user).length > 0, "Username cannot be empty");
        require(!streamers[_user].isRegistered, "Username already taken");
        require(bytes(walletToUser[msg.sender]).length == 0, "Wallet already registered");

        streamers[_user] = Streamer({
            username: _user,
            games: _games,
            avatar: _avatar,
            wallet: msg.sender,
            isRegistered: true
        });

        walletToUser[msg.sender] = _user;
        streamerList.push(_user);

        emit StreamerRegistered(_user, msg.sender);
    }

    function getStreamer(string memory _user) public view returns (Streamer memory) {
        require(streamers[_user].isRegistered, "Not found");
        return streamers[_user];
    }

    function getStreamerCount() public view returns (uint256) {
        return streamerList.length;
    }
}
