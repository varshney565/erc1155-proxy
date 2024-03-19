// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyToken is Initializable, ERC1155Upgradeable, AccessControlUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable {
    /**
     * @notice 
     * 
     * basic structs that are going to be passed in the 
     * BatchMint and BatchCreate functions
     * 
     */
    struct mint_metadata {
        uint256 id;
        uint256 amount;
    }

    struct batchMintMetaData {
        address to;
        mint_metadata[] id_amount;
    }

    struct create_metadata {
        address to;
        uint256 amount;
    }
    
    struct batchCreateMetaData {
        string uri;
        create_metadata[] detail;
    }

    bytes32 public constant MANAGER = keccak256("MANAGER");
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant BURNER = keccak256("BURNER");

    uint256 private next_id;
    mapping(uint256 => string) private token_uri;

    // / @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address defaultAdmin, address minter,address manager) initializer public {
        __ERC1155_init("");
        __AccessControl_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();

        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER, minter);
        _grantRole(MANAGER,manager);
        next_id = 1;
    }

    function setURI(string memory newuri) public onlyRole(MANAGER) {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyRole(MINTER) {
        require(id < next_id && id > 0,"No such token exists !!");
        _mint(account, id, amount, data);
    }

    function create(address account,uint256 amount,bytes memory data,string memory _uri) public onlyRole(MINTER) {
        token_uri[next_id] = _uri;
        _mint(account,next_id,amount,data);
        next_id++;
    }

    function mintBatch(batchMintMetaData[] memory data) public onlyRole(MINTER) {
        for(uint256 i = 0 ; i < data.length ; i++) {
            for(uint256 j = 0 ; j < data[i].id_amount.length ; j++) {
                require(data[i].id_amount[j].id < next_id && data[i].id_amount[j].id > 0,"No such token exists !!");
            }
        }
        for(uint256 i = 0 ; i < data.length ; i++) {
            uint256[] memory ids = new uint256[](data[i].id_amount.length);
            uint256[] memory values = new uint256[](data[i].id_amount.length);
            for(uint256 j = 0 ; j < data[i].id_amount.length ; j++) {
                ids[j] = data[i].id_amount[j].id;
                values[j] = data[i].id_amount[j].amount;
            }
            _mintBatch(data[i].to, ids, values,"BatchMint");
        }
    }

    function uri(uint256 id) public view override(ERC1155Upgradeable) returns(string memory) {
        return token_uri[id];
    }

    function batchCreate(batchCreateMetaData[] memory data) public onlyRole(MINTER) {
        for(uint256 i = 0 ; i < data.length ; i++) {
            token_uri[next_id] = data[i].uri;
            for(uint256 j = 0 ; j < data[i].detail.length ; j++) {
                _mint(data[i].detail[j].to, next_id, data[i].detail[j].amount,"BatchCreate");
            }
            next_id++;
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._update(from, to, ids, values);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
