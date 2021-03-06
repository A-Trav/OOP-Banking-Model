unit BankTest;
interface

uses
  DUnitX.TestFramework, BankModel, System.SysUtils;

type
  [TestFixture]
  BankingTest = class
  private
    TestBank: Bank;
    TestAccount: Account;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure CreateAccountTest;
    [Test]
    procedure DepositTest;
    [Test]
    procedure WithDrawTest;
    [Test]
    procedure MiniStatementTest;
  end;

implementation

// Create the Test Bank and Account objects
procedure BankingTest.Setup;
begin
  TestBank := Bank.Create('Commonwealth Bank');
  TestAccount := Account.Create('Test Name', 20);
end;

// Free the Bank and Account objects, then set to nil
procedure BankingTest.TearDown;
begin
  TestBank.Free;
  TestBank := nil;
  TestAccount.Free;
  TestBank := nil;
end;

// Tests the use of the Banks create account method
procedure BankingTest.CreateAccountTest;
begin
  TestBank.CreateAccount(TestAccount.GetName(), TestAccount.GetBalance());

  Assert.AreEqual(TestAccount.GetName(), TestBank.GetAccount(TestAccount.GetName()).GetName());
  Assert.WillRaise(
    procedure begin TestBank.CreateAccount(TestAccount.GetName(), TestAccount.GetBalance()); end,
    Exception,
    'Active Account'
  );
end;

// Tests the use of the Banks deposit method
procedure BankingTest.DepositTest;
begin
  TestBank.CreateAccount(TestAccount.GetName(), TestAccount.GetBalance());

  TestBank.Deposit(TestAccount.GetName(), 10);
  Assert.AreEqual(30, TestBank.GetAccount(TestAccount.GetName()).GetBalance());

  Assert.WillRaise(
    procedure begin TestBank.Deposit(TestAccount.GetName(), -50); end,
    Exception,
    'Invalid deposit'
  );

  Assert.WillRaise(
    procedure begin TestBank.Deposit('Not an Account', 50); end,
    Exception,
    'No such Account'
  );
end;

// Tests the use of the Banks Withdraw method
procedure BankingTest.WithdrawTest;
begin
  TestBank.CreateAccount(TestAccount.GetName(), TestAccount.GetBalance());

  TestBank.Withdraw(TestAccount.GetName(), 10);
  Assert.AreEqual(10, TestBank.GetAccount(TestAccount.GetName()).GetBalance());

  Assert.WillRaise(
    procedure begin TestBank.Withdraw(TestAccount.GetName(), -50); end,
    Exception,
    'Invalid Withdrawal'
  );

  Assert.WillRaise(
    procedure begin TestBank.Withdraw('Not an Account', 10); end,
    Exception,
    'No such Account'
  );
end;

// Tests the use of the Banks customerstatement method
procedure BankingTest.MiniStatementTest;
begin
  TestBank.CreateAccount(TestAccount.GetName(), TestAccount.GetBalance());
  TestBank.Withdraw(TestAccount.GetName(), 10);
  TestBank.Deposit(TestAccount.GetName(), 10);

  Assert.Contains(TestBank.CustomerStatement(TestAccount.GetName()),'Deposit: 10');
  Assert.Contains(TestBank.CustomerStatement(TestAccount.GetName()),'Withdraw: 10');

  Assert.WillRaise(
    procedure begin TestBank.CustomerStatement('Not an Account'); end,
    Exception,
    'No such Account'
  );

end;

initialization
  TDUnitX.RegisterTestFixture(BankingTest);

end.
