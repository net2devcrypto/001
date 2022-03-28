// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@net2devcrypto/001/IERC20.sol";
import "@net2devcrypto/001/NftStakingParent.sol";

contract NftStakingCall is NftStakingParent {

    mapping(uint256 => uint64) public weightByTokenAttribute;

    constructor(
        uint32 cycleLengthInSeconds_,
        uint16 periodLengthInCycles_,
        IERC1155721Transferrable whitelistedNftContract_,
        IERC20 rewardsTokenContract_,
        uint256[] memory tokenAttribute,
        uint64[] memory weights
    ) NftStakingParent(
        cycleLengthInSeconds_,
        periodLengthInCycles_,
        whitelistedNftContract_,
        rewardsTokenContract_
    ) public {
        require(tokenAttribute.length == weights.length, "NftStakingCall: inconsistent array lengths");
        for (uint256 i = 0; i < tokenAttribute.length; ++i) {
            weightByTokenAttribute[tokenAttribute[i]] = weights[i];
        }
    }

    function _validateAndGetNftWeight(uint256 nftId) internal virtual override view returns (uint64) {
        uint256 tokenType = nftId >> 240 & 0xFF;
        require(tokenType == 1, "NftStakingCall: Wrong NFT type");
        uint256 attributeValue = nftId >> 176 & 0xFF;
        return weightByTokenAttribute[attributeValue];
    }
}
