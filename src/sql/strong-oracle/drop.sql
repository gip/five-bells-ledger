DROP PUBLIC SYNONYM L_ACCOUNTS FORCE;
DROP PUBLIC SYNONYM L_ENTRIES FORCE;
DROP PUBLIC SYNONYM L_FULFILLMENTS FORCE;
DROP PUBLIC SYNONYM L_LU_REJECTION_REASON FORCE;
DROP PUBLIC SYNONYM L_LU_TRANSFER_STATUS FORCE;
DROP PUBLIC SYNONYM L_TRANSFER_ADJUSTMENTS FORCE;
DROP PUBLIC SYNONYM L_TRANSFERS FORCE;


DROP TRIGGER L_TRG_ACCOUNTS_SEQ;
DROP TRIGGER L_TRG_TRANSFERS_SEQ;
DROP TRIGGER L_TRG_ENTRIES_SEQ;
DROP TRIGGER L_TRG_FULFILLMENTS_SEQ;
DROP TRIGGER L_TRG_TRANSFER_ADJUSTMENTS_SEQ;

DROP TRIGGER L_TRG_ACCOUNTS_UPDATE;
DROP TRIGGER L_TRG_ACCOUNTS_INSERT;
DROP TRIGGER L_TRG_TRANSFERS_UPDATE;
DROP TRIGGER L_TRG_TRANSFERS_INSERT;
DROP TRIGGER L_TRG_ENTRIES_UPDATE;
DROP TRIGGER L_TRG_ENTRIES_INSERT;
DROP TRIGGER L_TRG_FULFILLMENTS_UPDATE;
DROP TRIGGER L_TRG_FULFILLMENTS_INSERT;
DROP TRIGGER L_TRG_TRANSFER_ADJUSTMENTS_UPD;
DROP TRIGGER L_TRG_TRANSFER_ADJUSTMENTS_INS;

DROP SEQUENCE L_SEQ_ACCOUNT_PK;
DROP SEQUENCE L_SEQ_ENTRIES_PK;
DROP SEQUENCE L_SEQ_FULFILLMENTS_PK;
DROP SEQUENCE L_SEQ_TRANSFERS_PK;
DROP SEQUENCE L_SEQ_TRANSFER_ADJUSTMENTS_PK;


ALTER TABLE L_ENTRIES
DROP CONSTRAINT FK_ACCOUNT_ID__ENTRIES;

ALTER TABLE L_ENTRIES
DROP CONSTRAINT FK_TRANSFER_ID__ENTRIES;

ALTER TABLE L_FULFILLMENTS
DROP CONSTRAINT FK_TRANSFER_ID__TRANSFERS;

ALTER TABLE L_TRANSFER_ADJUSTMENTS
DROP CONSTRAINT FK_TRANSFER_ID__TRANSFER_DETAI;

ALTER TABLE L_TRANSFER_ADJUSTMENTS
DROP CONSTRAINT FK_ACCOUNTS_ID__TRANSFER_DETAI;

ALTER TABLE L_TRANSFERS
DROP CONSTRAINT FK_STATUS_ID__TRANSFERS;

ALTER TABLE L_TRANSFERS
DROP CONSTRAINT FK_REJECTION_REASON_ID__TRANSF;

ALTER TABLE L_ENTRIES
DROP PRIMARY KEY CASCADE DROP INDEX;

DROP TABLE L_ENTRIES CASCADE CONSTRAINTS PURGE;
DROP TABLE L_FULFILLMENTS CASCADE CONSTRAINTS PURGE;
DROP TABLE L_TRANSFER_ADJUSTMENTS CASCADE CONSTRAINTS PURGE;
DROP TABLE L_ACCOUNTS CASCADE CONSTRAINTS PURGE;
DROP TABLE L_TRANSFERS CASCADE CONSTRAINTS PURGE;
DROP TABLE L_LU_REJECTION_REASON CASCADE CONSTRAINTS PURGE;
DROP TABLE L_LU_TRANSFER_STATUS CASCADE CONSTRAINTS PURGE;

exit
