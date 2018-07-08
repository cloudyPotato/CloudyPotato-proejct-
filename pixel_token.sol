pragma solidity ^0.4.18;


import "./main.sol";

contract PixelToken is StandardToken {
    string public name = 'PixelToken';
    string public symbol = 'mC';
    uint256 public decimals = 2;
    uint256 public INITIAL_SUPPLY = 10 * (10**decimals);
    
    mapping(address => uint256) creditScores;
    mapping(address => uint256) transactionTimes;
    
    function PixelToken() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
    
  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer_with_rate(address _to, uint256 _value) public  returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    if (_value != 0){

        //calculate the interest rate
        if (transactionTimes[_to] == 0){
            transactionTimes[_to] = transactionTimes[_to].add(block.timestamp);
        }
        if (creditScores[_to] == 0){
            creditScores[_to] = creditScores[_to].add(50);
        }
    
        if (!get_overdue(_to)){
            balances[msg.sender] = balances[msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value); 
            transactionTimes[_to] = block.timestamp;
            
            // add rating to credit score
            if (creditScores[_to] < 100){
                creditScores[_to] = creditScores[_to].add(10);
            }
        }
        else {
            // check credit score
            // no transfer will occur 
            if (creditScores[_to] > 10){
                balances[msg.sender] = balances[msg.sender].sub(_value);
                balances[_to] = balances[_to].add(_value); 
                creditScores[_to] = creditScores[_to].sub(10);
                transactionTimes[_to] = block.timestamp;
            }
        }
    }
  
    Transfer((msg.sender),  _to, _value);
    return true;
  }  

  function creditScoreOf(address _owner) public view returns (uint256 creditScore) {
    return creditScores[_owner];
  }
  
  function transactionTimeOf(address _owner) public view returns (uint256 transactionTime) {
    return transactionTimes[_owner];
  }  
  
  function get_overdue(address _owner) public returns (bool overdue) {
      // make an empty transfer to renew the timestamp
      uint256 overdue_time =  block.timestamp - transactionTimes[_owner];
      if (overdue_time > 20) {
          overdue = true;
      }
      else {
          overdue = false;
      }
      return overdue;
  }
}
