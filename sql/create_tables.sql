CREATE TABLE BRANCH (
    BSBNumber       VARCHAR2(10) PRIMARY KEY,
    BranchName      VARCHAR2(100),
    Address         VARCHAR2(200),
    City            VARCHAR2(50),
    ManagerName     VARCHAR2(100),
    BM_PhoneNumber  VARCHAR2(20),
    BM_Email        VARCHAR2(100)
);
CREATE TABLE BANK_ACCOUNT_TYPE (
    AccountType         VARCHAR2(20) PRIMARY KEY,
    InterestRate        NUMBER(5,2),
    MonthlyServiceFee   NUMBER(10,2),
    TransactionFee      NUMBER(10,2),
    DebitCard_Enable    CHAR(1) CHECK (DebitCard_Enable IN ('Y', 'N'))
);
CREATE TABLE CUSTOMER_ACCOUNT (
    CRN             VARCHAR2(20) PRIMARY KEY,
    MFA_Enabled     CHAR(1) CHECK (MFA_Enabled IN ('Y', 'N')),
    PasswordHash    VARCHAR2(256)
);
CREATE TABLE SERVICES (
    ServiceID VARCHAR2(20),
    ServiceDescription VARCHAR2(100),
    PRIMARY KEY (ServiceID, ServiceDescription)
);
CREATE TABLE CREDIT_CARD_TYPE (
    CardType             VARCHAR2(20) PRIMARY KEY,
    AnualFee             NUMBER(10,2),
    InterestRate         NUMBER(5,2),
    InterestFreeDays     NUMBER(3),
    MinimumCreditLimit   NUMBER(10,2)
);
CREATE TABLE PROMOTIONAL_OFFER (
    PromotionID      VARCHAR2(20) PRIMARY KEY,
    BenefitDetails   VARCHAR2(200),
    ValidDuration    VARCHAR2(50)
);
CREATE TABLE ID_DOCUMENT (
    UniqueIdentityNumber       VARCHAR2(30) PRIMARY KEY,
    IdentificationDocumentType VARCHAR2(50),
    IssueDate                  DATE,
    ExpiryDate                 DATE,
    IssuingAuthority           VARCHAR2(100)
);
CREATE TABLE CREDIT_CARD_APPLICATION (
    ApplicationID       VARCHAR2(20) PRIMARY KEY,
    Name                VARCHAR2(100),
    Gender              CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    DateOfBirth         DATE,
    ResidentialAddress  VARCHAR2(200),
    MailingAddress      VARCHAR2(200),
    TaxFileNumber       VARCHAR2(20),
    Status              VARCHAR2(20)
);
CREATE TABLE RECEIVER_PAYID (
    ReceiverPayID VARCHAR2(20) PRIMARY KEY,
    CRN           VARCHAR2(20),
    CONSTRAINT fk_receiverpayid_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE ACCOUNT_APPLICATION (
    ApplicationID      VARCHAR2(20) PRIMARY KEY,
    CRN                VARCHAR2(20),
    Name               VARCHAR2(100),
    Gender             VARCHAR2(10),
    DateOfBirth        DATE,
    ResidentialAddress VARCHAR2(200),
    MailingAddress     VARCHAR2(200),
    TaxFileNumber      VARCHAR2(20),
    Status             VARCHAR2(20),
    CONSTRAINT fk_accapp_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE RECEIVER_ACCOUNT (
    ReceiverID       VARCHAR2(20) PRIMARY KEY,
    CRN              VARCHAR2(20),
    ReceiverBSB      VARCHAR2(10),
    ReceiverAccNum   VARCHAR2(20),
    ReceiverName     VARCHAR2(100),
    CONSTRAINT fk_receiveraccount_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE CREDIT_CARD_APPLICATION (
    ApplicationID      VARCHAR2(20) PRIMARY KEY,
    CRN                VARCHAR2(20),
    Name               VARCHAR2(100),
    Gender             VARCHAR2(10),
    DateOfBirth        DATE,
    ResidentialAddress VARCHAR2(200),
    MailingAddress     VARCHAR2(200),
    TaxFileNumber      VARCHAR2(20),
    Status             VARCHAR2(20),
    CONSTRAINT fk_creditapp_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE BANK_ACCOUNT (
    AccountNumber   VARCHAR2(20) PRIMARY KEY,
    BSBNumber       VARCHAR2(10),
    AccountType     VARCHAR2(20),
    ApplicationID   VARCHAR2(20),
    Status          VARCHAR2(20) CHECK (Status IN ('Active', 'Inactive')),
    CONSTRAINT fk_bank_branch FOREIGN KEY (BSBNumber) REFERENCES BRANCH(BSBNumber),
    CONSTRAINT fk_account_type FOREIGN KEY (AccountType) REFERENCES BANK_ACCOUNT_TYPE(AccountType),
    CONSTRAINT fk_account_app FOREIGN KEY (ApplicationID) REFERENCES ACCOUNT_APPLICATION(ApplicationID)
);
CREATE TABLE TRANSACTION_RECEIVE (
    TransactionID     VARCHAR2(20) PRIMARY KEY,
    AccountNumber     VARCHAR2(20),
    TransDate         DATE,
    PayerAccNumber    VARCHAR2(20),
    PayerName         VARCHAR2(100),
    Amount            NUMBER(10,2),
    ReferenceNumber   VARCHAR2(50),
    Message           VARCHAR2(200),
    PaymentMethod     VARCHAR2(50),
    CONSTRAINT fk_trx_recv_account FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber)
);
CREATE TABLE TRANSACTION_PAY (
    TransactionID     VARCHAR2(20) PRIMARY KEY,
    AccountNumber     VARCHAR2(20),
    TransDate         DATE,
    ReceiverAccNumber VARCHAR2(20),
    Amount            NUMBER(10,2),
    ReferenceNumber   VARCHAR2(50),
    Message           VARCHAR2(200),
    PaymentMethod     VARCHAR2(50),
    PayerName         VARCHAR2(100),
    CONSTRAINT fk_trx_pay_account FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber)
);
CREATE TABLE FUTURE_PAYMENT (
    FuturePaymentID   VARCHAR2(20) PRIMARY KEY,
    AccountNumber     VARCHAR2(20),
    ReceiverName      VARCHAR2(100),
    ReceiverAccNumber VARCHAR2(20),
    ReceiverBSBNumber VARCHAR2(10),
    ReceiverAmount    NUMBER(10,2),
    ReferenceNumber   VARCHAR2(50),
    Status            VARCHAR2(20),
    DateScheduled     DATE,
    CONSTRAINT fk_future_payment_account FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber)
);
CREATE TABLE BILLERS (
    BPAYNumber     VARCHAR2(20) PRIMARY KEY,
    CRN            VARCHAR2(20),
    BillerName     VARCHAR2(100),
    ReferenceNumber VARCHAR2(50),
    CONSTRAINT fk_biller_crn FOREIGN KEY (CRN) REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE BILL_PAY (
    BillID        VARCHAR2(20) PRIMARY KEY,
    AccountNumber VARCHAR2(20),
    BPAYNumber    VARCHAR2(20),
    RefNum        VARCHAR2(50),
    Amount        NUMBER(10,2),
    CRN           VARCHAR2(20),
    CONSTRAINT fk_billpay_account FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber),
    CONSTRAINT fk_billpay_bpay FOREIGN KEY (BPAYNumber) REFERENCES BILLERS(BPAYNumber)
);
CREATE TABLE DEBIT_CARD (
    DebitCardID     VARCHAR2(20) PRIMARY KEY,
    CRN             VARCHAR2(20),
    AccountNumber   VARCHAR2(20),
    DebitCardNumber VARCHAR2(20),
    IssueDate       DATE,
    ExpiryDate      DATE,
    PinCode         VARCHAR2(10),
    WithdrawalLimit NUMBER(10,2),
    CONSTRAINT fk_debit_card_crn FOREIGN KEY (CRN) REFERENCES CUSTOMER_ACCOUNT(CRN),
    CONSTRAINT fk_debit_card_acc FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber)
);
CREATE TABLE PAYID (
    PayID         VARCHAR2(20) PRIMARY KEY,
    PayIDType     VARCHAR2(20),
    CRN           VARCHAR2(20),
    AccountNumber VARCHAR2(20),
    CONSTRAINT fk_payid_crn FOREIGN KEY (CRN) REFERENCES CUSTOMER_ACCOUNT(CRN),
    CONSTRAINT fk_payid_acc FOREIGN KEY (AccountNumber) REFERENCES BANK_ACCOUNT(AccountNumber)
);
CREATE TABLE CREDIT_CARD_ACCOUNT (
    CreditAccNumber     VARCHAR2(20) PRIMARY KEY,
    Status              VARCHAR2(20) CHECK (Status IN ('Active', 'Inactive')),
    CreditBalance       NUMBER(12, 2)
);
CREATE TABLE CREDIT_CARD_PAYMENTS (
    PaymentID         VARCHAR2(20) PRIMARY KEY,
    Trans_Details     VARCHAR2(200),
    Amount            NUMBER(12, 2),
    Type              VARCHAR2(50),
    Method            VARCHAR2(50),
    CreditAccNumber   VARCHAR2(20),
    CONSTRAINT fk_creditpay_creditacc FOREIGN KEY (CreditAccNumber)
        REFERENCES CREDIT_CARD_ACCOUNT(CreditAccNumber)
);
CREATE TABLE CREDIT_CARD (
    CreditCardID       VARCHAR2(20) PRIMARY KEY,
    CRN                VARCHAR2(20),
    CardType           VARCHAR2(20),
    ApplicationID      VARCHAR2(20),
    CreditCardNum      VARCHAR2(20),
    IssueDate          DATE,
    ExpiryDate         DATE,
    PinCode            VARCHAR2(10),
    ApprovedCreditLimit NUMBER(12, 2),

    CONSTRAINT fk_creditcard_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN),
    CONSTRAINT fk_creditcard_type FOREIGN KEY (CardType)
        REFERENCES CREDIT_CARD_TYPE(CardType),
    CONSTRAINT fk_creditcard_app FOREIGN KEY (ApplicationID)
        REFERENCES CREDIT_CARD_APPLICATION(ApplicationID)
);
CREATE TABLE CREATES (
    AccountNumber VARCHAR2(20),
    CRN           VARCHAR2(20),
    PRIMARY KEY (AccountNumber, CRN),
    CONSTRAINT fk_creates_account FOREIGN KEY (AccountNumber)
        REFERENCES BANK_ACCOUNT(AccountNumber),
    CONSTRAINT fk_creates_crn FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN)
);
CREATE TABLE GIVEN (
    PromotionID VARCHAR2(20),
    CardType    VARCHAR2(20),
    PRIMARY KEY (PromotionID, CardType),
    CONSTRAINT fk_given_promo FOREIGN KEY (PromotionID)
        REFERENCES PROMOTIONAL_OFFER(PromotionID),
    CONSTRAINT fk_given_cardtype FOREIGN KEY (CardType)
        REFERENCES CREDIT_CARD_TYPE(CardType)
);
CREATE TABLE OFFERS (
    BSBNumber           VARCHAR2(10),
    ServiceID           VARCHAR2(20),
    ServiceDescription  VARCHAR2(100),
    PRIMARY KEY (BSBNumber, ServiceID, ServiceDescription),

    CONSTRAINT fk_offers_branch FOREIGN KEY (BSBNumber)
        REFERENCES BRANCH(BSBNumber),

    CONSTRAINT fk_offers_service FOREIGN KEY (ServiceID, ServiceDescription)
        REFERENCES SERVICES(ServiceID, ServiceDescription)
);
CREATE TABLE SUBMIT (
    UniqueIdentityNumber VARCHAR2(30),
    ApplicationID        VARCHAR2(20),
    PRIMARY KEY (UniqueIdentityNumber, ApplicationID),
    CONSTRAINT fk_submit_doc FOREIGN KEY (UniqueIdentityNumber)
        REFERENCES ID_DOCUMENT(UniqueIdentityNumber),
    CONSTRAINT fk_submit_app FOREIGN KEY (ApplicationID)
        REFERENCES ACCOUNT_APPLICATION(ApplicationID)
);
CREATE TABLE CONNECT_TO (
    CreditCardID     VARCHAR2(20),
    CreditAccNumber  VARCHAR2(20),
    PRIMARY KEY (CreditCardID, CreditAccNumber),
    CONSTRAINT fk_connect_card FOREIGN KEY (CreditCardID)
        REFERENCES CREDIT_CARD(CreditCardID),
    CONSTRAINT fk_connect_account FOREIGN KEY (CreditAccNumber)
        REFERENCES CREDIT_CARD_ACCOUNT(CreditAccNumber)
);
CREATE TABLE RELATE_TO (
    CRN             VARCHAR2(20),
    Relating_CRN    VARCHAR2(20),
    BankAccNum      VARCHAR2(20),
    Relationship    VARCHAR2(50),
    PRIMARY KEY (CRN, Relating_CRN),
    
    CONSTRAINT fk_relate_crn1 FOREIGN KEY (CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN),

    CONSTRAINT fk_relate_crn2 FOREIGN KEY (Relating_CRN)
        REFERENCES CUSTOMER_ACCOUNT(CRN),

    CONSTRAINT fk_relate_account FOREIGN KEY (BankAccNum)
        REFERENCES BANK_ACCOUNT(AccountNumber)
);





