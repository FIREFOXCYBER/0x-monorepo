/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;

import "./MixinFees.sol";
import "./MixinForwarderCore.sol";
import "./MixinConstants.sol";
import "./MixinMarketBuyZrx.sol";
import "./MixinExpectedResults.sol";
import "./MixinTransfer.sol";


contract Forwarder is
    MixinConstants,
    MixinExpectedResults,
    MixinFees,
    MixinMarketBuyZrx,
    MixinTransfer,
    MixinForwarderCore
{

    constructor (
        address _exchange,
        address _etherToken,
        address _zrxToken,
        bytes memory _zrxAssetData,
        bytes memory _wethAssetData
    )
        public
        MixinConstants(
            _exchange,
            _etherToken,
            _zrxToken,
            _zrxAssetData,
            _wethAssetData
        )
        MixinForwarderCore()
    {}
}
