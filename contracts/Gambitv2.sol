// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }
  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}

abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    _transferOwnership(_msgSender());
  }

  modifier onlyOwner() {
    _checkOwner();
    _;
  }

  function owner() public view virtual returns (address) {
    return _owner;
  }

  function _checkOwner() internal view virtual {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
  }

  function renounceOwnership() public virtual onlyOwner {
    _transferOwnership(address(0));
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal virtual {
    address oldOwner = _owner;
    _owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
  }
}

interface IERC20 {
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address to, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) external returns (bool);
}

library Address {
  function isContract(address account) internal view returns (bool) {
    return account.code.length > 0;
  }

  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    (bool success, ) = recipient.call{value: amount}("");
    require(success, "Address: unable to send value, recipient may have reverted");
  }

  function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCallWithValue(target, data, 0, "Address: low-level call failed");
  }

  function functionCall(
      address target,
      bytes memory data,
      string memory errorMessage
  ) internal returns (bytes memory) {
      return functionCallWithValue(target, data, 0, errorMessage);
  }

  function functionCallWithValue(
      address target,
      bytes memory data,
      uint256 value
  ) internal returns (bytes memory) {
    return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
  }

  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(address(this).balance >= value, "Address: insufficient balance for call");
    (bool success, bytes memory returndata) = target.call{value: value}(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
    return functionStaticCall(target, data, "Address: low-level static call failed");
  }

  function functionStaticCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal view returns (bytes memory) {
    (bool success, bytes memory returndata) = target.staticcall(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
    return functionDelegateCall(target, data, "Address: low-level delegate call failed");
  }

  function functionDelegateCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal returns (bytes memory) {
    (bool success, bytes memory returndata) = target.delegatecall(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  function verifyCallResultFromTarget(
    address target,
    bool success,
    bytes memory returndata,
    string memory errorMessage
  ) internal view returns (bytes memory) {
    if (success) {
      if (returndata.length == 0) {
        require(isContract(target), "Address: call to non-contract");
      }
      return returndata;
    } else {
      _revert(returndata, errorMessage);
    }
  }

  function verifyCallResult(
    bool success,
    bytes memory returndata,
    string memory errorMessage
  ) internal pure returns (bytes memory) {
    if (success) {
      return returndata;
    } else {
      _revert(returndata, errorMessage);
    }
  }

  function _revert(bytes memory returndata, string memory errorMessage) private pure {
    if (returndata.length > 0) {
      assembly {
        let returndata_size := mload(returndata)
        revert(add(32, returndata), returndata_size)
      }
    } else {
      revert(errorMessage);
    }
  }
}

interface IERC20Permit {
  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;
  function nonces(address owner) external view returns (uint256);
  function DOMAIN_SEPARATOR() external view returns (bytes32);
}

library SafeERC20 {
  using Address for address;

  function safeTransfer(
    IERC20 token,
    address to,
    uint256 value
  ) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  ) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
  }

  function safeApprove(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    require(
      (value == 0) || (token.allowance(address(this), spender) == 0),
      "SafeERC20: approve from non-zero to non-zero allowance"
    );
    _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
  }

  function safeIncreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    uint256 newAllowance = token.allowance(address(this), spender) + value;
    _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
  }

  function safeDecreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    unchecked {
      uint256 oldAllowance = token.allowance(address(this), spender);
      require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
      uint256 newAllowance = oldAllowance - value;
      _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
  }

  function safePermit(
    IERC20Permit token,
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal {
    uint256 nonceBefore = token.nonces(owner);
    token.permit(owner, spender, value, deadline, v, r, s);
    uint256 nonceAfter = token.nonces(owner);
    require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
  }

  function _callOptionalReturn(IERC20 token, bytes memory data) private {
    bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
    if (returndata.length > 0) {
      require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }
  }
}

abstract contract ReentrancyGuard {
  uint256 private constant _NOT_ENTERED = 1;
  uint256 private constant _ENTERED = 2;

  uint256 private _status;

  constructor () {
    _status = _NOT_ENTERED;
  }
  
  modifier nonReentrant() {
    require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
    _status = _ENTERED;
    _;
    _status = _NOT_ENTERED;
  }
}

interface ISportsAMMV2 {
  struct CombinedPosition {
    uint16 typeId;
    uint8 position;
    int24 line;
  }

  struct TradeData {
    bytes32 gameId;
    uint16 sportId;
    uint16 typeId;
    uint maturity;
    uint8 status;
    int24 line;
    uint24 playerId;
    uint[] odds;
    bytes32[] merkleProof;
    uint8 position;
    CombinedPosition[][] combinedPositions;
  }
}

interface ISportsAMMV2G {
  function trade(
    ISportsAMMV2.TradeData[] calldata _tradeData,
    uint _buyInAmount,
    uint _expectedQuote,
    uint _additionalSlippage,
    address _referrer,
    address _collateral,
    bool _isEth
  ) external payable returns (address _createdTicket);

  function tradeLive(
    ISportsAMMV2.TradeData[] calldata _tradeData,
    uint _buyInAmount,
    uint _expectedQuote,
    address _recipient,
    address _referrer,
    address _collateral
  ) external returns (address _createdTicket);

  function exerciseTicket(address _ticket) external;

  function exerciseTicketOffRamp(
    address _ticket,
    address _exerciseCollateral,
    bool _inEth
  ) external;
}

interface ILiveTradingProcessor {
  struct LiveTradeData {
    string _gameId;
    uint16 _sportId;
    uint16 _typeId;
    int24 _line;
    uint8 _position;
    uint _buyInAmount;
    uint _expectedQuote;
    uint _additionalSlippage;
    address _referrer;
    address _collateral;
  }

  function fulfillLiveTrade(bytes32 _requestId, bool allow, uint approvedAmount) external;

  function requestLiveTrade(LiveTradeData calldata _liveTradeData) external returns (bytes32);
}

contract Gambitv2 is Ownable, ReentrancyGuard {
  using SafeERC20 for IERC20;

  address public SportsAMMv2;
  address public LiveTradingProcessor;

  uint256 public treasuryFee = 10_0000_0000_0000_0000_00;
  uint256 public coreDecimal = 100_0000_0000_0000_0000_00;
  address public treasury;

  struct Ticket {
    address owner;
    address collateral;
  }
  mapping (bytes32 => Ticket) public userInfo;
  mapping (address => bytes32[]) public userKeys;

  event PlaceBet(address account, string referral, bytes32 key);
  event TreasuryFee(address token, uint256 fee, address treasury);
  event Claim(address account, bytes32 key, address token, uint256 amount);

  constructor (address _SportsAMMv2, address _LiveTradingProcessor, address _treasury) {
    SportsAMMv2 = _SportsAMMv2;
    LiveTradingProcessor = _LiveTradingProcessor;
    treasury = _treasury;
  }

  receive() external payable {}

  function trade(
    ISportsAMMV2.TradeData[] calldata _tradeData,
    uint _buyInAmount,
    uint _expectedQuote,
    uint _additionalSlippage,
    address _referrer,
    address _collateral,
    bool _isEth,
    string calldata referral_code
  ) public payable nonReentrant returns (address _createdTicket) {
    address collateral = _isEth ? address(0) : _collateral;
    _approveTokenIfNeeded(collateral, SportsAMMv2, _buyInAmount);

    address ticket = ISportsAMMV2G(SportsAMMv2).trade{value: msg.value}(_tradeData, _buyInAmount, _expectedQuote, _additionalSlippage, _referrer, _collateral, _isEth);
    bytes32 key = _addressToBytes32(ticket);
    userInfo[key].owner = msg.sender;
    userInfo[key].collateral = _collateral;
    userKeys[msg.sender].push(key);
    emit PlaceBet(msg.sender, referral_code, key);
    return ticket;
  }

  function getUserKeys(address user) public view returns (bytes32[] memory) {
    return userKeys[user];
  }

  function requestLiveTrade(
    ILiveTradingProcessor.LiveTradeData calldata _liveTradeData,
    string calldata referral_code
  ) public returns (bytes32 requestId) {
    _approveTokenIfNeeded(_liveTradeData._collateral, LiveTradingProcessor, _liveTradeData._buyInAmount);
    bytes32 key = ILiveTradingProcessor(LiveTradingProcessor).requestLiveTrade(_liveTradeData);
    userInfo[key].owner = msg.sender;
    userInfo[key].collateral = _liveTradeData._collateral;
    userKeys[msg.sender].push(key);
    emit PlaceBet(msg.sender, referral_code, key);
    return key;
  }

  function exerciseTicket(address _ticket) public {
    bytes32 key = _addressToBytes32(_ticket);

    require(userInfo[key].owner != address(0), "Gambit: non exist ticket");
    require(userInfo[key].owner == msg.sender, "Gambit: non owner");
    address collateral = userInfo[key].collateral;

    uint256 amount = 0;
    if (collateral == address(0)) {
      amount = address(this).balance;
    }
    else {
      amount = IERC20(collateral).balanceOf(address(this));
    }
    ISportsAMMV2G(SportsAMMv2).exerciseTicket(_ticket);
    if (collateral == address(0)) {
      amount = address(this).balance - amount;
    }
    else {
      amount = IERC20(collateral).balanceOf(address(this)) - amount;
    }

    if (amount > 0) {
      amount = _cutFee(collateral, amount);
      if (collateral == address(0)) {
        (bool success, ) = payable(userInfo[key].owner).call{value: amount}("");
        require(success, "Failed claim");
      }
      else {
        IERC20(collateral).safeTransfer(msg.sender, amount);
      }
      emit Claim(msg.sender, key, collateral, amount);
    }
  }

  function setTreasury(address _treasury) public onlyOwner {
    treasury = _treasury;
  }

  function _approveTokenIfNeeded(address token, address spender, uint256 amount) internal {
    if (token != address(0)) {
      uint256 oldAllowance = IERC20(token).allowance(address(this), spender);
      if (oldAllowance < amount) {
        if (oldAllowance > 0) {
          IERC20(token).safeApprove(spender, 0);
        }
        IERC20(token).safeApprove(spender, amount);
      }
    }
  }

  function _addressToBytes32(address addr) internal pure returns (bytes32) {
    return bytes32(uint256(uint160(addr)));
  }

  function _cutFee(address _token, uint256 _amount) internal returns(uint256) {
    if (_amount > 0) {
      uint256 fee = _amount * treasuryFee / coreDecimal;
      if (fee > 0) {
        if (_token == address(0)) {
          (bool success, ) = payable(treasury).call{value: fee}("");
          require(success, "Failed cut fee");
        }
        else {
          IERC20(_token).safeTransfer(treasury, fee);
        }
        emit TreasuryFee(_token, fee, treasury);
      }
      return _amount - fee;
    }
    return 0;
  }
}
