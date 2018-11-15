pragma solidity ^0.4.20;

contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    function WorkbenchBase(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract MarineLogisticLifeCycle is WorkbenchBase('MarineLogisticLifeCycle', 'MarineLogisticLifeCycle') {

     //Set of States
    enum StateType { Initiate,Nominate,Load,Accounting,Close}

    //List of properties
    StateType public  State;
    address public  Marketer;
    address public  OperationScheduler;
	address public  BargeCompany;
	address public  Accounting;

    string public InitiateBunkerDeal;
    string public BardgeName;
	string public BardgeMethod;
	string public Vessel;
	string public FuelType;
	uint   public Price;
	uint   public Quantity;
	uint   public TotalAmount;

    // constructor function
	//This will create the contract 
	//Marketer is going to initiate this process and sent 
	//Message to OperationScheduler to initiate the 
	//Bunker loading
    function MarineLogisticLifeCycle(string Initiation) public
    {
        Marketer = msg.sender;
        InitiateBunkerDeal = Initiation;
        State = StateType.Initiate;

        // call ContractCreated() to create an instance of this workflow. 
		// THis will create the contract
		//which is currently reflected as a deal in RightAngle
        ContractCreated();
    }
	
	function InitiateDeal(string Initiation) public
    {
        if (Marketer != msg.sender)
        {
            revert();
        }
        InitiateBunkerDeal = Initiation;
        State = StateType.Initiate;

        // call ContractCreated() to create an instance of this workflow. 
		// THis will create the contract
		//which is currently reflected as a deal in RightAngle
        ContractUpdated('InitiateDeal');
    }


    // call this function to Nominate a Bardge Company to
	//supply the fuel oil to the vessel
	//this function should only be called by the OperationScheduler
    function NominateBardgeCompany(string SelectBardgeName) public
    {
		//
        OperationScheduler = msg.sender;
        //
		//

        BardgeName = SelectBardgeName;
        State = StateType.Nominate;

        // call ContractUpdated() to record this action
        ContractUpdated('NominateBardgeCompany');
    }

    // call this function to send a response
    function LoadCompleted(string _BardgeMethod,string _Vessel,string _FuelType,uint _Price,uint _Quantity,uint _TotalAmount) public
    {
        BargeCompany = msg.sender;

        
        //Set the variables
		BardgeMethod    = _BardgeMethod;
	    Vessel          = _Vessel;
	    FuelType=_FuelType;
	    Price=_Price;
	    Quantity= _Quantity;
	    TotalAmount = _TotalAmount;
		//
		//update the state of the contract
		//
        State = StateType.Load;
		// call ContractUpdated() to record this action
        ContractUpdated('LoadCompleted');
    }
	
	// call this function to assign the details to accounting
    function SendForAccounting() public
    {
        if (BargeCompany != msg.sender)
        {
            revert();
        }

		//
		//update the state of the contract
		//
        State = StateType.Accounting;
		// call ContractUpdated() to record this action
        ContractUpdated('SendForAccounting');
    }
}