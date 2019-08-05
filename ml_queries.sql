# copy the credit card default dataset
SELECT
  limit_balance,
  sex,
  education_level,
  marital_status,
  age,
  pay_0,
  pay_2,
  pay_3,
  pay_4,
  pay_5,
  pay_6,
  bill_amt_1,
  bill_amt_2,
  bill_amt_3,
  bill_amt_4,
  bill_amt_5,
  bill_amt_6,
  pay_amt_1,
  pay_amt_2,
  pay_amt_3,
  pay_amt_4,
  pay_amt_5,
  pay_amt_6,
  default_payment_next_month AS label
FROM
  `bigquery-public-data.ml_datasets.credit_card_default`
  
# create a logistic regression model to predict if person will default on payment next month
CREATE MODEL
  `my_first_dataset.credit_card_default`
OPTIONS
  ( model_type='logistic_reg',
    auto_class_weights=TRUE,
    l1_reg=1,
    max_iterations=5,
    data_split_method='seq',
    DATA_SPLIT_COL='label',
    data_split_eval_fraction=0.3) AS
SELECT
  limit_balance,
  sex,
  education_level,
  marital_status,
  age,
  pay_0,
  pay_2,
  pay_3,
  pay_4,
  pay_5,
  pay_6,
  bill_amt_1,
  bill_amt_2,
  bill_amt_3,
  bill_amt_4,
  bill_amt_5,
  bill_amt_6,
  pay_amt_1,
  pay_amt_2,
  pay_amt_3,
  pay_amt_4,
  pay_amt_5,
  pay_amt_6,
  default_payment_next_month AS label
FROM
  `bigquery-public-data.ml_datasets.credit_card_default`
  
# create a logistic regression model to predict if card holder would default on next month's payment

CREATE MODEL
  `my_first_dataset.cc_default_mlmodel`
OPTIONS
  ( model_type='logistic_reg',
    auto_class_weights=TRUE,
    l1_reg=1,
    max_iterations=5,
    input_label_cols = ['label']) AS
SELECT
*
FROM
  `my_first_dataset.cc_default`
  WHERE RAND() < 0.05
  
# predictions
SELECT
  *
FROM
  ML.EVALUATE(MODEL `my_first_dataset.cc_default_mlmodel`,
    (
    SELECT
      *
    FROM
      `my_first_dataset.cc_default`))
  
  
