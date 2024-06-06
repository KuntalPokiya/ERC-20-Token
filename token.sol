// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balance_of_account(address account) external view returns (uint256);
    function transaction_of_token(address recipient, uint256 amount) external returns (bool);
    function amount_of_allowance_given(address owner, address spender) external view returns (uint256);
    function amount_to_approve(address spender, uint256 amount) external returns (bool);
    function receive_from_founder(address sender, address recipient, uint256 amount) external returns (bool);

    event Transaction(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Kyren is IERC20{

  string internal name="Kyren"; //name of the token
  string internal symbol="KYN"; //symbol of the token
  uint public decimal=18;
  address public founder;//initially this will have the total supply
  mapping(address=>uint) internal balances; //information of balance of each address
  uint public totalSupply;

  mapping(address=>mapping(address=>uint)) allowed;
  
  constructor(uint256 supply_of_Tokens){
     totalSupply=supply_of_Tokens;
     founder=msg.sender;
     balances[founder]=totalSupply;
  }

  function name_of_token() public view returns (string memory){
    return name;
  }
  

  function symbol_of_token() public view returns (string memory){
    return symbol;
  }

  function balance_of_account(address account) external view returns (uint256){
     return balances[account];
  }

  function transaction_of_token(address recipient, uint256 amount) external returns (bool){
     require(amount>0,"amount must be greater than zero");
     require(balances[msg.sender]>=amount,"Balance must be greater than zero");
     balances[msg.sender]-=amount;
     balances[recipient]+=amount;
     emit Transaction(msg.sender, recipient, amount);
     return true;
  }
  
  function amount_of_allowance_given(address owner, address spender) external view returns (uint256){
        return allowed[owner][spender];
  } 
  
  function amount_to_approve(address spender, uint256 amount) external returns (bool){
        require(amount>0,"amount must be greater than zero");
        require(balances[msg.sender]>=amount,"Balance must be greater than zero");
        allowed[msg.sender][spender]=amount;
        emit Approval(msg.sender, spender, amount);
        return true;
  }
  

  function receive_from_founder(address sender, address recipient, uint256 amount) external returns (bool){
     require(allowed[sender][recipient]>=amount,"Recipient don't have authority to spend sender's token");
     require(balances[sender]>=amount,"Insufficient balance");
     balances[sender]-=amount;
     balances[recipient]+=amount;
     emit Transaction(msg.sender, recipient, amount);
     return true;
  }
  
}
