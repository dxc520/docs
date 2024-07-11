pragma solidity ^0.4.24;

library Address {

    function isContract(address addr) internal view returns(bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }  
        return size > 0;
    }

    function isEmptyAddress(address addr) internal pure returns(bool){
        return addr == address(0);
    }
}





2246de6d266444ef83df675f0af5238a


export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
