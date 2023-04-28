CREATE SCHEMA trading;

CREATE TABLE trading.members (
  "member_id" VARCHAR(10),
  "first_name" VARCHAR(10),
  "region" VARCHAR(20)
);

CREATE TABLE trading.prices (
  "ticker" VARCHAR(10),
  "market_date" DATE,
  "price" numeric,
  "open" numeric,
  "high" numeric,
  "low" numeric,
  "volume" VARCHAR(10),
  "change" VARCHAR(10)
);

CREATE TABLE trading.transactions (
  "txn_id" INTEGER,
  "member_id" VARCHAR(10),
  "ticker" VARCHAR(10),
  "txn_date" DATE,
  "txn_type" VARCHAR(5),
  "quantity" numeric,
  "percentage_fee" numeric,
  "txn_time" TIMESTAMP
);

/*
-- Creating these indexes after loading data
-- will make things run much faster!!!

CREATE INDEX ON trading.prices (ticker, market_date);
CREATE INDEX ON trading.transactions (txn_date, ticker);
CREATE INDEX ON trading.transactions (txn_date, member_id);
CREATE INDEX ON trading.transactions (member_id);
CREATE INDEX ON trading.transactions (ticker);

*/
