// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function freezeToken(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function unfreezeToken(address account) external returns (bool);

    function mint(address _to, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Unfreeze(
        address indexed _unfreezer,
        address indexed _to,
        uint256 _amount
    );
}

contract KBC_NODE_MINT {
    address public ownerWallet;
    uint public currUserID = 0;
    uint public currRound = 0;
    uint public leadershipReward = 0;
    uint public currRoundStartTime = 0;
    uint public totalNode = 50000;
    uint public endTime;
    uint public startTime = 0;
    uint public level_income = 0;
    address public globalInsurance;
    address public liquidityPool;
    address public tokenBuyBack;
    address public roundCloser;
    //uint public top4Pool = 0;
    //uint public top4Pool2Distribute = 0;
    //uint day;
    //
    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint ownNode;
        uint atPrice;
        uint referredUsers;
        uint income;
        uint rootBalance;
        uint assuredReward;
        uint levelIncomeReceived;
        uint takenROI;
        uint256 stakeTimes;
        mapping(uint => uint) levelExpired;
        uint incomeMissed;
    }

    struct RankStruct {
        uint starOne;
        uint starTwo;
        uint starThree;
        uint starFour;
        uint starFive;
        uint starSix;
        uint starSeven;
        bool starOnePaid;
        bool starTwoPaid;
        bool starThreePaid;
        bool starFourPaid;
        bool starFivePaid;
        bool starSixPaid;
        bool starSevenPaid;
        
    }

    struct LevelStruct {
        uint two;
        uint three;
        uint four;
        uint five;
        uint six;
        uint seven;
        uint eight;
        uint nine;
        uint ten;
        uint eleven;
        uint twelve;
        uint thirteen;
        uint forteen;
        uint fifteen;
        
    }

    struct LevelIncomeStruct {
        uint two;
        uint three;
        uint four;
        uint five;
        uint six;
        uint seven;
        uint eight;
        uint nine;
        uint ten;
        uint eleven;
        uint twelve;
        uint thirteen;
        uint forteen;
        uint fifteen;
        
    }

    struct TurnOverStruct {
        uint two;
        uint three;
        uint four;
        uint five;
        uint six;
        uint seven;
        uint eight;
        uint nine;
        uint ten;
        uint eleven;
        uint twelve;
        uint thirteen;
        uint forteen;
        uint fifteen;
        
    }

    struct ReportStruct {
        uint firstTO;
        uint secondTO;
        uint thirdTO;
        uint fourthTO;
        address first;
        address second;
        address third;
        address fourth;
        uint top4PoolForwarded;
        uint top4Pool;
        uint top4Pool2Distribute;
        uint actualTO;
    }

    struct DailyStruct {
        uint time;
        uint myTO;
        uint winAmount;
    }
    // USERS
    mapping(address => UserStruct) public users;
    mapping(address => RankStruct) public ranks;
    mapping(address => LevelStruct) public levels;
    mapping(address => LevelIncomeStruct) public levelsIncome;
    mapping(address => TurnOverStruct) public turnOver;
    mapping(uint => ReportStruct) public reports;

    mapping(uint => address) public userList;
    mapping(uint => uint) public LEVEL_PRICE;
    //mapping(uint => uint) public firstTO;
    //mapping(uint => uint) public secondTO;
    //mapping(uint => uint) public thirdTO;
    //mapping(uint => uint) public fourthTO;
    //mapping(uint => address) public firstRunner;
    //mapping(uint => address) public secondRunner;
    //mapping(uint => address) public thirdRunner;
    //mapping(uint => address) public fourthRunner;
    //mapping(address => uint256) public ownNode;
    mapping(address => uint256) public regTime;
    mapping(address => uint256) public takenTop4Income;
    mapping(address => uint256) public userTurnOver;
    mapping(address => uint256) public directIncome;
    mapping(uint256 => mapping(address => DailyStruct)) public dailyUserTO;
    mapping(address => uint256) public mintDays;
    //mapping(address => uint256) public mintCapping;
    //mapping(address => uint256) public totalIncomeTaken;
    //mapping(uint => uint) public top4Pool;
    //mapping(uint => uint) public top4Pool2Distribute;
    IBEP20 token;
    IBEP20 public stableCoin;

    bool ownerPaid;
    // Events
    event SponsorIncome(
        address indexed _user,
        address indexed _referrer,
        uint _time
    );
    event toInsurancePool(address indexed _user, uint _amount, uint _time);
    event toLiquidityPool(address indexed _user, uint _amount, uint _time);
    event toBuyBackPool(address indexed _user, uint _amount, uint _time);
    event WithdrawROI(address indexed user, uint256 reward);
    event WithdrawReward(address indexed user, uint256 reward);
    event WithdrawStable(address sender, address _to, uint256 amount);
    event SendBalance(address indexed user, uint256 amount);
    event LevelsIncome(
        address indexed _user,
        address indexed _referral,
        uint indexed _level,
        uint _amount,
        uint _time
    );
    event WithdrawalCoin(
        address sender,
        address _to,
        uint256 amount,
        string widrwalType
    );
    event DepositKBC(address _user, uint _amount, uint _time);
    event top4winners(uint Round, uint first, uint second, uint third, uint fourth);
    //event LevelsIncome(address indexed _user,address indexed _referral,uint indexed _level,uint _time);

    UserStruct[] private requests;

    constructor(
        address stableCoin_,
        address _gloabalInsurance,
        address _liquidityPool,
        address _tokenBuyBack,
        address _roundCloser
    ) {
        ownerWallet = msg.sender;
        currUserID++;
        currRound++;
        users[ownerWallet].isExist = true;
        users[ownerWallet].id = currUserID;
        regTime[ownerWallet] = block.timestamp;
        users[ownerWallet].ownNode = totalNode;
        startTime = block.timestamp;
        endTime = block.timestamp + 315360000;
        currRoundStartTime = block.timestamp;
        users[ownerWallet].stakeTimes = block.timestamp;
        users[ownerWallet].rootBalance = 100000000e18;
        users[ownerWallet].assuredReward = 100000000e18;
        userList[currUserID] = ownerWallet;
        globalInsurance = _gloabalInsurance;
        liquidityPool = _liquidityPool;
        tokenBuyBack = _tokenBuyBack;
        roundCloser = _roundCloser;
        stableCoin = IBEP20(stableCoin_);
    }

    modifier onlyOwner() {
        require(
            msg.sender == ownerWallet,
            "Only Owner can access this function."
        );
        _;
    }

    function Registration(uint _referrerID, uint256 _node) public payable {
        require(!users[msg.sender].isExist, "User Exists");
        require(
            _referrerID > 0 && _referrerID <= currUserID,
            "Incorrect referral ID"
        );
        require(
            _node > 0 && _node <= users[ownerWallet].ownNode,
            "Incorrect node count"
        );
        uint _amount = _node * nodePrice();
        require(
            stableCoin.allowance(msg.sender, address(this)) >= _amount,
            "NEED_TO_APPROVE_TOKEN"
        );
        stableCoin.transferFrom(msg.sender, address(this), _amount);
        currUserID++;
        users[msg.sender].isExist = true;
        users[msg.sender].id = currUserID;
        users[msg.sender].referrerID = _referrerID;
        users[msg.sender].ownNode = _node;
        userList[currUserID] = msg.sender;
        regTime[msg.sender] = block.timestamp;
        stableCoin.transfer(globalInsurance, _amount / 10);
        stableCoin.transfer(liquidityPool, _amount * 15 / 100);
        stableCoin.transfer(tokenBuyBack, _amount / 10);
        leadershipReward += _amount / 20;
        reports[currRound].actualTO += _amount;
        reports[currRound].top4Pool += _amount / 10;
        //reports[currRound].top4Pool2Distribute = reports[currRound].top4Pool / 2;
        users[msg.sender].stakeTimes = block.timestamp;
        users[userList[users[msg.sender].referrerID]].referredUsers =
            users[userList[users[msg.sender].referrerID]].referredUsers +
            1;
        users[msg.sender].atPrice = nodePrice();
        users[msg.sender].rootBalance =
            users[msg.sender].ownNode *
            ((endTime - block.timestamp) / 86400) *
            547945205479452000;
        users[msg.sender].assuredReward =
            users[msg.sender].ownNode *
            ((endTime - block.timestamp) / 86400) *
            547945205479452000;
        mintDays[msg.sender] = (endTime - block.timestamp) / 86400;
        
        //send reward to admin till the time of new user registration
        
        withdrawOwnerROI();
        payReferral(1, msg.sender, _amount);
        

        emit SponsorIncome(msg.sender, userList[_referrerID], block.timestamp);
        emit toInsurancePool(msg.sender, _amount / 10, block.timestamp);
        emit toLiquidityPool(msg.sender, _amount / 5, block.timestamp);
        emit toBuyBackPool(msg.sender, _amount / 10, block.timestamp);

        top4PoolDistribution(_referrerID, _amount);
        sendBalance();
        
    }

    function payReferral(uint _level, address _user, uint _value) internal {
        address referer;
        referer = userList[users[_user].referrerID];
        bool sent = false;
        uint level_price_local = 0;
        // Condition of level from 1- 1o and number of reffered user
        if (_level == 1 && users[referer].referredUsers >= 0) {
            level_price_local = (_value * 20) / 100;
            directIncome[referer] += level_price_local;
        } else if (_level == 2 && users[referer].referredUsers >= 1) {
            level_price_local = (_value * 8) / 100;
            levelsIncome[referer].two += level_price_local;
        } else if (_level == 3 && users[referer].referredUsers >= 1) {
            level_price_local = (_value * 4) / 100;
            levelsIncome[referer].three += level_price_local;
        } else if (_level == 4 && users[referer].referredUsers >= 2) {
            level_price_local = (_value * 4) / 100;
            levelsIncome[referer].four += level_price_local;
        } else if (_level == 5 && users[referer].referredUsers >= 2) {
            level_price_local = (_value * 4) / 100;
            levelsIncome[referer].five += level_price_local;
        } else if (_level == 6 && users[referer].referredUsers >= 2) {
            level_price_local = _value / 100;
            levelsIncome[referer].six += level_price_local;
        } else if (_level == 7 && users[referer].referredUsers >= 3) {
            level_price_local = _value / 100;
            levelsIncome[referer].seven += level_price_local;
        } else if (_level == 8 && users[referer].referredUsers >= 3) {
            level_price_local = _value / 100;
            levelsIncome[referer].eight += level_price_local;
        } else if (_level == 9 && users[referer].referredUsers >= 3) {
            level_price_local = _value / 100;
            levelsIncome[referer].nine += level_price_local;
        } else if (_level == 10 && users[referer].referredUsers >= 4) {
            level_price_local = _value / 100;
            levelsIncome[referer].ten += level_price_local;
        } else if (_level == 11 && users[referer].referredUsers >= 4) {
            level_price_local = _value / 100;
            levelsIncome[referer].eleven += level_price_local;
        } else if (_level == 12 && users[referer].referredUsers >= 4) {
            level_price_local = _value / 100;
            levelsIncome[referer].twelve += level_price_local;
        } else if (_level == 13 && users[referer].referredUsers >= 5) {
            level_price_local = _value / 100;
            levelsIncome[referer].thirteen += level_price_local;
        } else if (_level == 14 && users[referer].referredUsers >= 5) {
            level_price_local = _value / 100;
            levelsIncome[referer].forteen += level_price_local;
        } else if (_level == 15 && users[referer].referredUsers >= 5) {
            level_price_local = _value / 100;
            levelsIncome[referer].fifteen += level_price_local;
        } else {
            users[referer].incomeMissed++;
        }

        if (_level == 2) {
            levels[referer].two += 1;
            turnOver[referer].two += _value;
        } else if (_level == 3) {
            levels[referer].three += 1;
            turnOver[referer].three += _value;
        } else if (_level == 4) {
            levels[referer].four += 1;
            turnOver[referer].four += _value;
        } else if (_level == 5) {
            levels[referer].five += 1;
            turnOver[referer].five += _value;
        } else if (_level == 6) {
            levels[referer].six += 1;
            turnOver[referer].six += _value;
        } else if (_level == 7) {
            levels[referer].seven += 1;
            turnOver[referer].seven += _value;
        } else if (_level == 8) {
            levels[referer].eight += 1;
            turnOver[referer].eight += _value;
        } else if (_level == 9) {
            levels[referer].nine += 1;
            turnOver[referer].nine += _value;
        } else if (_level == 10) {
            levels[referer].ten += 1;
            turnOver[referer].ten += _value;
        } else if (_level == 11) {
            levels[referer].eleven += 1;
            turnOver[referer].eleven += _value;
        } else if (_level == 12) {
            levels[referer].twelve += 1;
            turnOver[referer].twelve += _value;
        } else if (_level == 13) {
            levels[referer].thirteen += 1;
            turnOver[referer].thirteen += _value;
        } else if (_level == 14) {
            levels[referer].forteen += 1;
            turnOver[referer].forteen += _value;
        } else if (_level == 15) {
            levels[referer].fifteen += 1;
            turnOver[referer].fifteen += _value;
        } 
        sent = stableCoin.transfer(
            address(uint160(referer)),
            level_price_local * 95 / 100
        );

        userTurnOver[referer] += _value;

        users[referer].levelIncomeReceived =
            users[referer].levelIncomeReceived +
            1;
        users[userList[users[_user].referrerID]]
                .income += level_price_local;
        
        if (sent) {
            emit LevelsIncome(referer, msg.sender, _level,level_price_local, block.timestamp);
            if (_level < 15 && users[referer].referrerID >= 1) {
                payReferral(_level + 1, referer, _value);
            } else {}
        }
        if (!sent) {
            payReferral(_level, referer, _value);
        }
        
    }

    
    function withdrawROI() public {
        require(msg.sender != ownerWallet, "Only user allowed");
        uint256 reward = withdrawableROI(msg.sender);
        require(reward > 0, "No any withdrawableROI Found");
        if (reward >= users[msg.sender].rootBalance) {
            reward = users[msg.sender].rootBalance;
            users[msg.sender].assuredReward = 0;
        }
        users[msg.sender].rootBalance -= reward;
        users[msg.sender].takenROI += reward;
        payable(msg.sender).transfer(reward);
        uint adjust = (block.timestamp - users[msg.sender].stakeTimes) % 86400;
        users[msg.sender].stakeTimes = block.timestamp - adjust;
        emit WithdrawROI(msg.sender, reward);
    }

    function withdrawAdminROI() public {
        require(msg.sender == ownerWallet, "Only owner allowed");
        uint256 reward = withdrawableAdminROI();
        require(reward > 0, "No any withdrawableROI Found");
        if (reward >= users[ownerWallet].rootBalance) {
            reward = users[ownerWallet].rootBalance;
            users[ownerWallet].assuredReward = 0;
        }
        users[ownerWallet].rootBalance -= reward;
        users[ownerWallet].takenROI += reward;
        payable(ownerWallet).transfer(reward);
        //totalFreeze[msg.sender] -= reward;
        // users[msg.sender].withdrawable = 0;
        //uint adjust = (block.timestamp - users[ownerWallet].stakeTimes) % 86400;
        users[ownerWallet].stakeTimes = block.timestamp;
        emit WithdrawROI(ownerWallet, reward);
    }
    
    function withdrawOwnerROI() internal  {
        //require(msg.sender == ownerWallet, "Only user allowed");
        uint256 reward = withdrawableAdminROI();
        //require(reward > 0, "No any withdrawableROI Found");
        if (reward > 0){
        if (reward >= users[ownerWallet].rootBalance) {
            reward = users[ownerWallet].rootBalance;
            users[ownerWallet].assuredReward = 0;
        }
        
        users[ownerWallet].takenROI += reward;
        payable(ownerWallet).transfer(reward);
        users[ownerWallet].ownNode = users[ownerWallet].ownNode - users[msg.sender].ownNode;
        users[ownerWallet].rootBalance =
            users[ownerWallet].ownNode *
            ((endTime - block.timestamp) / 86400) *
            547945205479452000;
        users[ownerWallet].assuredReward =
            users[ownerWallet].ownNode *
            ((endTime - block.timestamp) / 86400) *
            547945205479452000;
        
        //totalFreeze[msg.sender] -= reward;
        // users[msg.sender].withdrawable = 0;
        //uint adjust = (block.timestamp - users[ownerWallet].stakeTimes) % 86400;
        users[ownerWallet].stakeTimes = block.timestamp;
        
        emit WithdrawROI(ownerWallet, reward);
    }}

    /**
     * @dev Withrawable ROI amount till now
     */
    function withdrawableROI(
        address _address
    ) public view returns (uint reward) {
        uint256 numDays = (block.timestamp - users[_address].stakeTimes) /
            86400;
        if (numDays > 0) {
            return (users[_address].ownNode * 547945205479452000 * numDays);
            //return (users[_address].ownNode * 547945205479452000 * numDays) / 1000;
        } else {
            return (0);
        }
    }

    function withdrawableAdminROI() public view returns (uint reward) {
        uint256 numDays = (block.timestamp - users[ownerWallet].stakeTimes);
        if (numDays > 0) {
            return (users[ownerWallet].ownNode * 6341958396753 * numDays);
            //return (users[ownerWallet].ownNode * 6341958396753 * numDays) / (users[ownerWallet].ownNode * 1000);
        } else {
            return (0);
        }
    }

    function soldNode() public view returns (uint node) {
        return 50000 - users[ownerWallet].ownNode;
    }

    function nodePrice() public view returns (uint price) {
        if (soldNode() >= 0 && soldNode() < 1000) {
            return (((soldNode() / 100) + 1) * (100e18));
        }
        if (soldNode() == 1000) {
            return (1000e18);
        }
        if (soldNode() >= 1001 && soldNode() <= 50000) {
            return (((soldNode() / 5000) + 1) * (1000e18));
        }
    }

    function withdrawalStableCoin(
        address payable _to,
        uint256 _amount
    ) external onlyOwner {
        // Owner Withdraw Token From Contract

        stableCoin.transfer(_to, _amount);
        emit WithdrawStable(msg.sender, _to, _amount);
    }


    function depositKBC() public payable {
        require(msg.value >= 0, "VALUE_SHOULD_NOT_ZERO");

        emit DepositKBC(msg.sender, msg.value, block.timestamp);
    }

    function setLiquidityPoolAddress(address _address) public onlyOwner {
        liquidityPool = _address;
    }

    function setRoundCloserAddress(address _address) public onlyOwner {
        roundCloser = _address;
    }

    function setglobalInsuranceAddress(address _address) public onlyOwner {
        globalInsurance = _address;
    }

    function setbuyBackPoolAddress(address _address) public onlyOwner {
        tokenBuyBack = _address;
    }
    
    function gettrxBalance() public view returns (uint) {
             {  uint total = reports[currRound].top4Pool + leadershipReward;
                return (stableCoin.balanceOf(address(this)) -(total));
            }
        }
    

    function sendBalance() private {
        
          
            if (gettrxBalance() > 0) {
                uint sendingBalance = gettrxBalance(); 
                users[ownerWallet].income = users[ownerWallet].income +(gettrxBalance());
                
                // if(!stableCoin.transferFrom(msg.sender,address(uint160(ownerWallet)),gettrxBalance(_value))){}
                (stableCoin.transfer(address(uint160(ownerWallet)),gettrxBalance()));
                 
                emit SendBalance(msg.sender, sendingBalance);
            }
    }

    function top4PoolDistribution(
        uint256 _referrerID,
        uint256 _amount
    ) internal {
        uint256 replaceTo;
        address currentRunner;
        dailyUserTO[currRound][userList[_referrerID]].myTO += _amount;
        dailyUserTO[currRound][userList[_referrerID]].time = block.timestamp;

        if (reports[currRound].fourth == userList[_referrerID]) {
            reports[currRound].fourthTO += _amount;
        } else if (reports[currRound].third == userList[_referrerID]) {
            reports[currRound].thirdTO += _amount;
        } else if (reports[currRound].second == userList[_referrerID]) {
            reports[currRound].secondTO += _amount;
        } else if (reports[currRound].first == userList[_referrerID]) {
            reports[currRound].firstTO += _amount;
        } else {
            if (reports[currRound].firstTO == 0) {
                reports[currRound].firstTO = _amount;
                reports[currRound].first = userList[_referrerID];
            } else if (reports[currRound].secondTO == 0) {
                reports[currRound].secondTO = _amount;
                reports[currRound].second = userList[_referrerID];
            } else if (reports[currRound].thirdTO == 0) {
                reports[currRound].thirdTO = _amount;
                reports[currRound].third = userList[_referrerID];
            } else if (reports[currRound].fourthTO == 0) {
                reports[currRound].fourthTO = _amount;
                reports[currRound].fourth = userList[_referrerID];
            } else if (
                reports[currRound].fourthTO <
                dailyUserTO[currRound][userList[_referrerID]].myTO
            ) {
                reports[currRound].fourthTO = dailyUserTO[currRound][
                    userList[_referrerID]
                ].myTO;
                reports[currRound].fourth = userList[_referrerID];
            }
        }

        if (
            reports[currRound].thirdTO <
            reports[currRound].fourthTO
        ) {
            replaceTo = reports[currRound].thirdTO;
            currentRunner = reports[currRound].third;

            reports[currRound].thirdTO = reports[currRound]
                .fourthTO;
            reports[currRound].third = reports[currRound]
                .fourth;
            reports[currRound].fourthTO = replaceTo;
            reports[currRound].fourth = currentRunner;
        }

        if (
            reports[currRound].secondTO <
            reports[currRound].thirdTO
        ) {
            replaceTo = reports[currRound].secondTO;
            currentRunner = reports[currRound].second;

            reports[currRound].secondTO = reports[currRound]
                .thirdTO;
            reports[currRound].second = reports[currRound]
                .third;
            reports[currRound].thirdTO = replaceTo;
            reports[currRound].third = currentRunner;
        }

        if (
            reports[currRound].firstTO <
            reports[currRound].secondTO
        ) {
            replaceTo = reports[currRound].firstTO;
            currentRunner = reports[currRound].first;

            reports[currRound].firstTO = reports[currRound]
                .secondTO;
            reports[currRound].first = reports[currRound]
                .second;
            reports[currRound].secondTO = replaceTo;
            reports[currRound].second = currentRunner;
        }
    }

     
     function closeRound() public {
        require(msg.sender == roundCloser || msg.sender == ownerWallet, "You are not the round closer");
        if (block.timestamp - currRoundStartTime >= 86400) {
            //reports[currDay].top4Pool2Distribute = reports[currDay].top4Pool / 2;

            if (reports[currRound].firstTO > 0){
            stableCoin.transfer(
                reports[currRound].first,
                //((reports[currRound].top4Pool2Distribute * 380) / 1000)
                ((reports[currRound].top4Pool * 190) / 1000)
            );
            reports[currRound].top4Pool2Distribute +=((reports[currRound].top4Pool * 200) / 1000);
            takenTop4Income[reports[currRound].first] += ((reports[currRound].top4Pool * 200) / 1000);
            }
            if (reports[currRound].secondTO > 0){
            stableCoin.transfer(
                reports[currRound].second,
                //((reports[currRound].top4Pool2Distribute * 285) / 1000)
                ((reports[currRound].top4Pool * 1425) / 10000));
                reports[currRound].top4Pool2Distribute +=((reports[currRound].top4Pool * 1500) / 10000);
                takenTop4Income[reports[currRound].second] += ((reports[currRound].top4Pool * 1500) / 10000);
            }
            if (reports[currRound].thirdTO > 0){
            stableCoin.transfer(
                reports[currRound].third,
                //((reports[currRound].top4Pool2Distribute * 190) / 1000)
                ((reports[currRound].top4Pool * 95) / 1000));
                reports[currRound].top4Pool2Distribute +=((reports[currRound].top4Pool * 100) / 1000);
                takenTop4Income[reports[currRound].third] += ((reports[currRound].top4Pool * 100) / 1000);
            }
            if (reports[currRound].fourthTO > 0){
            stableCoin.transfer(
                reports[currRound].fourth,
                //((reports[currRound].top4Pool2Distribute * 95) / 1000)
                ((reports[currRound].top4Pool * 475) / 10000));
                reports[currRound].top4Pool2Distribute +=((reports[currRound].top4Pool * 500) / 10000);
                takenTop4Income[reports[currRound].fourth] += ((reports[currRound].top4Pool * 500) / 10000);
            }
            //reports[currRound].top4Pool = reports[currRound].top4Pool - reports[currRound].top4Pool2Distribute;
            reports[currRound + 1].top4Pool = reports[currRound].top4Pool - reports[currRound].top4Pool2Distribute;
            reports[currRound + 1].top4PoolForwarded  = reports[currRound].top4Pool - reports[currRound].top4Pool2Distribute;
            emit top4winners (currRound,users[reports[currRound].first].id, users[reports[currRound].second].id,
                   users[reports[currRound].third].id, users[reports[currRound].fourth].id);
            currRound++;
            currRoundStartTime = block.timestamp;
        
    }
     }

     function withdrawReward(uint _star) public {
        require(users[msg.sender].isExist, "User Not Registered");
        if (_star ==1){
            require(ranks[msg.sender].starOnePaid == false, "already paid for starOne");
            require(users[msg.sender].referredUsers >= 3, "refer 3 users first");
            require(users[msg.sender].levelIncomeReceived >= 10, "team size is less then 10");
            require(userTurnOver[msg.sender] >= 3000e18, "turnover is less then 3000");
            require(leadershipReward >= 150e18, "Low leadershipPool");
            stableCoin.transfer(address(uint160(msg.sender)),(150e18 * 95) / 100);
            leadershipReward -= (150e18 * 95) / 100;
            ranks[msg.sender].starOnePaid = true;
            ranks[userList[users[msg.sender].referrerID]].starOne += 1;

            emit WithdrawReward(msg.sender, 150e18);
        }

        if (_star ==2){
            require(ranks[msg.sender].starTwoPaid == false, "already paid for starTwo");
            require(users[msg.sender].referredUsers >= 5, "refer 5 users first");
            require(users[msg.sender].levelIncomeReceived >= 25, "team size is less then 25");
            require(userTurnOver[msg.sender] >= 10000e18, "turnover is less then 3000");
            require(ranks[msg.sender].starOne >= 2, "create 2 oneStar leader in your direct");
            require(leadershipReward >= 500e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(500e18 * 95) / 100);
        leadershipReward -= (500e18 * 95) / 100;
            ranks[msg.sender].starTwoPaid = true;
            ranks[userList[users[msg.sender].referrerID]].starTwo += 1;

            emit WithdrawReward(msg.sender, 500e18);

        }

        if (_star ==3){
            require(ranks[msg.sender].starThreePaid == false, "already paid for starThree");
            require(users[msg.sender].referredUsers >= 7, "refer 7 users first");
            require(users[msg.sender].levelIncomeReceived >= 50, "team size is less then 10");
            require(userTurnOver[msg.sender] >= 30000e18, "turnover is less then 3000");
            require(ranks[msg.sender].starTwo >= 2, "create 2 twoStar leader in your direct");
            require(leadershipReward >= 1500e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(1500e18 * 95) / 100);
        leadershipReward -= (1500e18 * 95) / 100;
            ranks[msg.sender].starThreePaid = true;
            ranks[userList[users[msg.sender].referrerID]].starThree += 1;

            emit WithdrawReward(msg.sender, 1500e18);

        }

        if (_star ==4){
            require(ranks[msg.sender].starFourPaid == false, "already paid for starTwo");
            require(users[msg.sender].referredUsers >= 9, "refer 9 users first");
            require(users[msg.sender].levelIncomeReceived >= 100, "team size is less then 100");
            require(userTurnOver[msg.sender] >= 100000e18, "turnover is less then 3000");
            require(ranks[msg.sender].starThree >= 2, "create 2 threeStar leader in your direct");
            require(leadershipReward >= 5000e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(5000e18 * 95) / 100);
        leadershipReward -= (5000e18 * 95) / 100;
            ranks[msg.sender].starFourPaid = true;
            ranks[userList[users[msg.sender].referrerID]].starFour += 1;

            emit WithdrawReward(msg.sender, 5000e18);

        }

        if (_star ==5){
            require(ranks[msg.sender].starFivePaid == false, "already paid for starFive");
            require(users[msg.sender].referredUsers >= 11, "refer 11 users first");
            require(users[msg.sender].levelIncomeReceived >= 200, "team size is less then 200");
            require(userTurnOver[msg.sender] >= 1000000e18, "turnover is less then ten lac");
            require(ranks[msg.sender].starFour >= 2, "create 2 fourStar leader in your direct");
            require(leadershipReward >= 50000e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(50000e18 * 95) / 100);
        leadershipReward -= (50000e18 * 95) / 100;
            ranks[msg.sender].starFivePaid = true;
            ranks[userList[users[msg.sender].referrerID]].starFive += 1;

            emit WithdrawReward(msg.sender, 50000e18);

        }

        if (_star ==6){
            require(ranks[msg.sender].starSixPaid == false, "already paid for starSix");
            require(users[msg.sender].referredUsers >= 13, "refer 13 users first");
            require(users[msg.sender].levelIncomeReceived >= 500, "team size is less then 500");
            require(userTurnOver[msg.sender] >= 4000000e18, "turnover is less then fourty lac");
            require(ranks[msg.sender].starFive >= 2, "create 2 fiveStar leader in your direct");
            require(leadershipReward >= 200000e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(200000e18 * 95) / 100);
        leadershipReward -= (200000e18 * 95) / 100;
            ranks[msg.sender].starSixPaid = true;
            ranks[userList[users[msg.sender].referrerID]].starSix += 1;

            emit WithdrawReward(msg.sender, 200000e18);

        }
        if (_star ==7){
            require(ranks[msg.sender].starSevenPaid == false, "already paid for starSeven");
            require(users[msg.sender].referredUsers >= 15, "refer 15 users first");
            require(users[msg.sender].levelIncomeReceived >= 1000, "team size is less then 1000");
            require(userTurnOver[msg.sender] >= 10000000e18, "turnover is less then one Cr");
            require(ranks[msg.sender].starSix >= 2, "create 2 sixStar leader in your direct");
            require(leadershipReward >= 500000e18, "Low leadershipPool");
        stableCoin.transfer(address(uint160(msg.sender)),(500000e18 * 95) / 100);
        leadershipReward -= (500000e18 * 95) / 100;
            ranks[msg.sender].starSevenPaid = true;
            ranks[userList[users[msg.sender].referrerID]].starSeven += 1;

            emit WithdrawReward(msg.sender, 500000e18);

        }
           }

    function withdrawableReward(address _address) public view returns (uint256 _star) {
        
        if (users[_address].referredUsers >= 15 &&
            users[_address].levelIncomeReceived >= 1000 &&
            userTurnOver[_address] >= 10000000e18 &&
            ranks[_address].starSix >= 2) {
            return _star = 7;
        }
        
        if (users[_address].referredUsers >= 13 &&
            users[_address].levelIncomeReceived >= 500 &&
            userTurnOver[_address] >= 4000000e18 &&
            ranks[_address].starFive >= 2) {
            return _star = 6;
        }

        if (users[_address].referredUsers >= 11 &&
            users[_address].levelIncomeReceived >= 200 &&
            userTurnOver[_address] >= 1000000e18 &&
            ranks[_address].starFour >= 2) {
            return _star = 5;
        }
        if (users[_address].referredUsers >= 9 &&
            users[_address].levelIncomeReceived >= 100 &&
            userTurnOver[_address] >= 100000e18 &&
            ranks[_address].starThree >= 2) {
            return _star = 4;
        }
        
        if (users[_address].referredUsers >= 7 &&
            users[_address].levelIncomeReceived >= 50 &&
            userTurnOver[_address] >= 30000e18 &&
            ranks[_address].starTwo >= 2) {
            return _star = 3;
        }
        
        if (users[_address].referredUsers >= 5 &&
            users[_address].levelIncomeReceived >= 25 &&
            userTurnOver[_address] >= 10000e18 &&
            ranks[_address].starOne >= 2) {
            return _star = 2;
        }
        if (users[_address].referredUsers >= 3 &&
            users[_address].levelIncomeReceived >= 10 &&
            userTurnOver[_address] >= 3000e18) {
            return _star = 1;
        }
        
        
        
        
        
        
        }
        function fundLeadershipReward(uint _amount) public {
              require(stableCoin.allowance(msg.sender, address(this)) >= _amount,"APPROVE_TOKEN_FIRST");
              stableCoin.transferFrom(msg.sender, address(this), _amount);
              leadershipReward += _amount;
        } 

}