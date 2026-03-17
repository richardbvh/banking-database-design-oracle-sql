CREATE OR REPLACE PROCEDURE calc_monthly_interest IS
    CURSOR acc_cursor IS
        SELECT BANK_ACCOUNT.AccountNumber,
               BANK_ACCOUNT.AccountType,
               BANK_ACCOUNT_TYPE.InterestRate,
               CREDIT_CARD_ACCOUNT.CreditBalance
        FROM BANK_ACCOUNT
        JOIN BANK_ACCOUNT_TYPE
            ON BANK_ACCOUNT.AccountType = BANK_ACCOUNT_TYPE.AccountType
        JOIN CREDIT_CARD_ACCOUNT
            ON CREDIT_CARD_ACCOUNT.CreditAccNumber = BANK_ACCOUNT.AccountNumber
        WHERE BANK_ACCOUNT.Status = 'Active';

    v_account_number BANK_ACCOUNT.AccountNumber%TYPE;
    v_account_type BANK_ACCOUNT.AccountType%TYPE;
    v_interest_rate BANK_ACCOUNT_TYPE.InterestRate%TYPE;
    v_balance CREDIT_CARD_ACCOUNT.CreditBalance%TYPE;
    v_interest NUMBER(10,2);

BEGIN
    DBMS_OUTPUT.PUT_LINE('Account | Type | Balance | Interest Rate | Calculated Interest');
    FOR rec IN acc_cursor LOOP
        v_account_number := rec.AccountNumber;
        v_account_type := rec.AccountType;
        v_interest_rate := rec.InterestRate;
        v_balance := rec.CreditBalance;

        v_interest := (v_balance * v_interest_rate) / 100;

        DBMS_OUTPUT.PUT_LINE(v_account_number || ' | ' || v_account_type || ' | $' || v_balance || ' | ' || v_interest_rate || '% | $' || v_interest);
    END LOOP;
END;


CREATE OR REPLACE FUNCTION get_customer_total_balance(p_crn IN CUSTOMER_ACCOUNT.CRN%TYPE)
RETURN NUMBER IS
    v_total_balance NUMBER := 0;
BEGIN
    SELECT NVL(SUM(CREDIT_CARD_ACCOUNT.CreditBalance), 0)
    INTO v_total_balance
    FROM CREDIT_CARD_ACCOUNT
    JOIN CONNECT_TO
        ON CREDIT_CARD_ACCOUNT.CreditAccNumber = CONNECT_TO.CreditAccNumber
    WHERE CONNECT_TO.CreditCardID IN (
        SELECT CreditCardID
        FROM CREDIT_CARD
        WHERE CRN = p_crn
    );

    RETURN v_total_balance;
END;
/
