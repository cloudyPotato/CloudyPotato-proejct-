contract myCoin is StandardToken, Ownable {
    string public name = 'myCoin';
    string public symbol = 'mC';
    uint256 public decimals = 2;
    uint256 public INITIAL_SUPPLY = 10 * (10**decimals);
    
    function myCoin() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
