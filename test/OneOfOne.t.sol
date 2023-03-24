// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {Test} from "lib/forge-std/src/Test.sol";

import {OneOfOne} from "src/OneOfOne.sol";

contract OneOfOneTest is Test {

    OneOfOne public one;

    address bob = vm.addr(111);
    address bill = vm.addr(222);
    
    function setUp() public {
        one = new OneOfOne();

        vm.label(bob, "BOB");
        vm.label(bill, "BILL");
    }

    function testDeploy() public {
        one = new OneOfOne();
    }

    function testMint() public {
        one._mint(bill);

        assertEq(one.balanceOf(bill), 1);
    }

    function testFailDoubleMint() public {
        one._mint(bill);
        one._mint(bill);

        assertEq(one.balanceOf(bill), 1);
    }

    function testFailMintZero() public {
        address zero = vm.addr(0);

        vm.expectRevert();
        one._mint(zero);

        assertEq(one.balanceOf(zero), 0);
    }

    function testFailMintTwoAddress() public {
        vm.startPrank(bill);
        one._mint(bill);
        assertEq(one.balanceOf(bill), 1);

        one._mint(bob);
        vm.stopPrank();
        assertEq(one.balanceOf(bill), 1);
        assertEq(one.balanceOf(bob), 0);
    }

    
    function testBurn() public {
        vm.startPrank(bill);
        one._mint(bill);

        assertEq(one.balanceOf(bill), 1);

        one._burn();
        assertEq(one.balanceOf(bill), 0);
    }

    function testFailBurnDouble() public {
        vm.startPrank(bill);
        one._mint(bill);

        assertEq(one.balanceOf(bill), 1);

        one._burn();
        one._burn();
    }

    function testFailBurnFromOtherAddress() public {
        vm.startPrank(bill);
        one._mint(bill);

        assertEq(one.balanceOf(bill), 1);
        vm.stopPrank();

        vm.prank(bob);
        vm.expectRevert();
        one._burn();
    }

    function testFailBurnUnMinted() public {
        one._burn();
    }

    function testApprove() public {
        vm.startPrank(bob);
        one._mint(bob);

        one.approve(bill);

        assertEq(one.getApproved(), address(bill));
    }

     function testApproveBurn() public {
        vm.startPrank(bob);
        one._mint(bob);

        one.approve(bill);
        vm.stopPrank();

        vm.prank(bill);
        one._burn();

        assertEq(one.balanceOf(bob), 0);
        assertEq(one.getApproved(), address(0));

        vm.expectRevert("NOT_MINTED");
        one.ownerOf();
    }

    function testApproveAll() public {
        one.setApprovalForAll(address(bill), true);

        assertTrue(one.isApprovedForAll(address(this), address(bill)));
    }

    function testTransferFrom() public {
        one._mint(bob);

        vm.prank(bob);
        one.approve(address(this));
        
        one.transferFrom(bob, bill);

        assertEq(one.getApproved(), address(0));
        assertEq(one.ownerOf(), bill);
        assertEq(one.balanceOf(bill), 1);
        assertEq(one.balanceOf(bob), 0);

    }
    function testTransferFromSelf() public {
        vm.startPrank(bob);
        one._mint(bob);
        
        one.transferFrom(bob, bill);
        vm.stopPrank();

        assertEq(one.getApproved(), address(0));
        assertEq(one.ownerOf(), bill);
        assertEq(one.balanceOf(bill), 1);
        assertEq(one.balanceOf(bob), 0);
    }

     function testTransferFromApproveAll() public {
        one._mint(bob);

        vm.prank(bob);
        one.setApprovalForAll(address(this), true);
        
        one.transferFrom(bob, bill);

        assertEq(one.getApproved(), address(0));
        assertEq(one.ownerOf(), bill);
        assertEq(one.balanceOf(bill), 1);
        assertEq(one.balanceOf(bob), 0);
    }

    function testSafeTransferFromToEOA() public {
        one._mint(bob);

        vm.prank(bob);
        one.setApprovalForAll(address(this), true);
        
        one.safeTransferFrom(bob, bill);

        assertEq(one.getApproved(), address(0));
        assertEq(one.ownerOf(), bill);
        assertEq(one.balanceOf(bill), 1);
        assertEq(one.balanceOf(bob), 0);
    }
}