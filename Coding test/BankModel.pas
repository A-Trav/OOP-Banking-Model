unit BankModel;

interface
  uses
    System.Generics.Collections, System.SysUtils;

  // Account class interface
  type
  Account = Class
  private
    Name: String;
    Balance: Integer;
    Statement: TStack<String>;
  public
    constructor Create(CustomerName: string; StartingBalance: Integer);
    destructor Destroy; override;
    procedure SetName(NewName: String);
    procedure SetBalance(Amount: Integer);
    function GetName(): String;
    function GetBalance(): Integer;
    function GetStatement(): String;
    procedure AddToBalance(Deposit: Integer);
    procedure WithdrawFromBalance(Withdraw: Integer);
    procedure AddToStatement(Transaction: String);
  end;

  // Bank class interface
  Bank = Class
  private
    Name: String;
    Accounts: TDictionary<String, Account>;
  public
    constructor Create(BankName: string);
    destructor Destroy; override;
    procedure CreateAccount(AccountName: String; StartingBalance: Integer);
    procedure Deposit(AccountName: String; Amount: Integer);
    procedure Withdraw(AccountName: String; Amount: Integer);
    function CustomerStatement(AccountName: String): String;
    function GetAccounts(): TDictionary<String, Account>;
    function GetAccount(AccountName: String): Account;
  End;

implementation
// Account implementation
// Constructor for the Account Class
// Param: CustomerName - The name of the customer, StartingBalance - The Balance of the account
constructor Account.Create(CustomerName: string; StartingBalance: Integer);
begin
  Name := CustomerName;
  Balance := StartingBalance;
  Statement := TStack<String>.Create();
end;

// Destructor for the Account Class
destructor Account.Destroy;
begin
  Statement.Clear;
  Statement.Free;
  Statement := nil;
  inherited;
end;

// Sets the Name field of the Account
// Param : NewName - The desired name of the Account
procedure Account.SetName(NewName: string);
begin
  Name := NewName
end;

// Sets the Balance field of the Account
// Param: Amount - The desired balance of the Account
procedure Account.SetBalance(Amount: Integer);
begin
  Balance := Amount;
end;

// Gets the Name field of the Account
// Returns: The Account name
function Account.GetName() : String;
begin
  Result := Name;
end;

// Gets the Balance field of the Account
// Returns: The Account Balance
function Account.GetBalance: Integer;
begin
  Result := Balance;
end;

// Gets the transaction statement of the Account
// Returns: The Accounts transaction statement as a string
function Account.GetStatement: string;
var
  I: Integer;
  Str: String;
  tmp: TArray<String>;
begin
  Str := '';
  tmp := Statement.ToArray;

  for I := 0 to Statement.Count - 1 do
  begin
    str := str + tmp[I] + ' ';
  end;

  Result := Str;
end;

// Adds to the Balance of the Account
// Params: Deposit - The Amount to deposit into the account
procedure Account.AddToBalance(Deposit: Integer);
begin
  Balance := (Balance + Deposit);
end;

// Withdraws from the Balance of the Account
// Params: Withdraw - The Amount to be withdrawn from the account
procedure Account.WithdrawFromBalance(Withdraw: Integer);
begin
  Balance := Balance - Withdraw;
end;

// Adds to the Statement of the account
// Params: Transaction - The transaction as a string to be added to the account
procedure Account.AddToStatement(Transaction: string);
begin
  Statement.Push(Transaction);
end;


// Bank implementation
// Constructor for the Bank Class
// Params: BankName - The Name of the bank
constructor Bank.Create(BankName: string);
begin
  Name := BankName;
  Accounts := TDictionary<String, Account>.Create();
end;

// Destructor for the Bank Class
destructor Bank.Destroy;
var
  Customer : String;
begin
  for Customer in Accounts.Keys do
  begin
    Accounts[Customer].Free
  end;
  Accounts.Clear;
  Accounts.Free;
  Accounts := nil;
  inherited;
end;

// Creates a new Account within the Bank
// Params: AccountName - The name of the Account, StartingBalance: The starting Balance of the account
// Throws an exception when the customer already exist
procedure Bank.CreateAccount(AccountName : String; StartingBalance : Integer);
begin
  if Accounts.ContainsKey(AccountName) then
  begin
    raise Exception.Create('Active Account');
  end
  else
  begin
    Accounts.Add(AccountName, Account.Create(AccountName, StartingBalance));
  end;
end;

// Deposits into a given Account within the Bank
// Params: AccountName - The account to deposit into, Amount - The amount to deposit
// Throws an exception if the account does not exist or the amount is a negative number
procedure Bank.Deposit(AccountName : string; Amount: Integer);
var
  TempAccount : Account;
begin
  if not Accounts.ContainsKey(AccountName) then
  begin
    raise Exception.Create('No such Account');
  end

  else if Amount <= 0 then
  begin
    raise Exception.Create('Invalid deposit');
  end

  else
  begin
    TempAccount := Accounts[AccountName];
    TempAccount.AddToBalance(Amount);
    TempAccount.AddToStatement('Deposit: ' + IntToStr(Amount));
    Accounts[AccountName] := TempAccount;
  end;
end;

// Withdraws from a given Account within the Bank
// Params: AccountName - The account to withdraw from, Amount - The amount to withdraw
// Throws an exception if the account does not exist
procedure Bank.Withdraw(AccountName: string; Amount: Integer);
var
  TempAccount : Account;
begin
  if not Accounts.ContainsKey(AccountName) then
  begin
    raise Exception.Create('No such Account');
  end

  else if Amount <= 0 then
  begin
    raise Exception.Create('Invalid withdrawal');
  end

  else
  begin
    TempAccount := Accounts[AccountName];
    TempAccount.WithdrawFromBalance(Amount);
    TempAccount.AddToStatement('Withdraw: ' + IntToStr(Amount));
    Accounts[AccountName] := TempAccount;
  end;
end;

// Gets the transaction statement for a given customer account
// Params: AccountName - The name of the customer account
// Returns: The customers statement as a string
// Throws an exception if the account does not exist
function Bank.CustomerStatement(AccountName: string): string;
begin
  if not Accounts.ContainsKey(AccountName) then
  begin
    raise Exception.Create('No such Account');
  end
  else
  begin
    Result := Accounts[AccountName].GetStatement();
  end;
end;

// Gets the Dictionary of customer Accounts
// Returns: TDictionary of Account names and associated Accounts
function Bank.GetAccounts(): TDictionary<string, Account>;
begin
  Result := Accounts;
end;

// Gets the desired account from the banks customer Accounts
// Params: AccountName - The name of the desired Account
// Returns: The Account
// Throws an exception if the account does not exist
function Bank.GetAccount(AccountName: string): Account;
begin
  if not Accounts.ContainsKey(AccountName) then
  begin
    raise Exception.Create('No such Account');
  end
  else
  begin
    Result := Accounts[AccountName]
  end
end;
end.
