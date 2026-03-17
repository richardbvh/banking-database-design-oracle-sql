CREATE OR REPLACE TRIGGER trigger_block_large_payment 
BEFORE INSERT OR UPDATE ON TRANSACTION_PAY
FOR EACH ROW
BEGIN
    IF :NEW.Amount > 1000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'The payment amount is more than daily limit of this account');
    END IF;
END;
CREATE OR REPLACE TRIGGER trigger_check_scam_payment
BEFORE INSERT OR UPDATE ON TRANSACTION_PAY
FOR EACH ROW
DECLARE
    v_avg_amount NUMBER := 0;
BEGIN
    SELECT NVL(AVG(Amount), 0)
    INTO v_avg_amount
    FROM TRANSACTION_PAY
    WHERE AccountNumber = :NEW.AccountNumber;

    IF :NEW.Amount > v_avg_amount THEN
        RAISE_APPLICATION_ERROR(-20002, 'It may be a scam transaction, please check and contact ANZ customer care');
    END IF;
END;
