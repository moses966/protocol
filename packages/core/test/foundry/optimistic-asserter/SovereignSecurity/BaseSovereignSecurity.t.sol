// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../Common.sol";
import "../../../../contracts/optimistic-asserter/implementation/sovereign-security/BaseSovereignSecurity.sol";

contract BaseSovereignSecurityTest is Common {
    BaseSovereignSecurity ss;

    bytes32 identifier = "test";
    uint256 time = 123;
    bytes ancillaryData = "ancillary";

    event PriceRequestAdded(bytes32 indexed identifier, uint256 time, bytes ancillaryData);

    function setUp() public {
        ss = new BaseSovereignSecurity();
    }

    function test_GetAssertionPolicies() public {
        BaseSovereignSecurity.AssertionPolicies memory policies = ss.getAssertionPolicies(bytes32(0));
        assertTrue(policies.allowAssertion);
        assertTrue(policies.useDvmAsOracle);
        assertTrue(policies.useDisputeResolution);
        assertFalse(policies.validateDisputers);
    }

    function test_IsDisputeAllowed() public {
        assertTrue(ss.isDisputeAllowed(bytes32(0), address(0)));
    }

    function test_RequestPrice() public {
        vm.expectEmit(true, true, true, true);
        emit PriceRequestAdded(identifier, time, ancillaryData);
        ss.requestPrice(identifier, time, ancillaryData);
    }

    function test_GetPrice() public {
        int256 price = ss.getPrice(identifier, time, ancillaryData);
        assertTrue(price == 0);
    }
}