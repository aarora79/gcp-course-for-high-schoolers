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
 
# save the results of the prev query as a new bigquery table called cc_default
# now check if this is an unbalanced dataset
SELECT
  COUNT(*)
FROM
  `summer-project-1.my_first_dataset.cc_default`
GROUP BY
  label
  
# create a logistic regression model to predict if card holder would default on next month's payment
CREATE MODEL
  `my_first_dataset.cc_default_mlmodel`
OPTIONS
  ( model_type='logistic_reg',
    auto_class_weights=TRUE,
    l1_reg=1,
    max_iterations=15,
    input_label_cols = ['label']) AS
SELECT
*
FROM
  `my_first_dataset.cc_default`
  WHERE RAND() <= 0.70

# evaluate the model
SELECT
  *
FROM
  ML.EVALUATE(MODEL `my_first_dataset.cc_default_mlmodel`,
    (
    SELECT
      *
    FROM
      `my_first_dataset.cc_default`))
      
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
  
# create a balanced dataset
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
WHERE default_payment_next_month = "1"

UNION ALL

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
WHERE default_payment_next_month = "0" AND RAND() <= 0.3

  
# create a logistic regression model to predict if card holder would default on next month's payment
CREATE MODEL
  `my_first_dataset.cc_default_mlmodel_from_balanced`
OPTIONS
  ( model_type='logistic_reg',
    auto_class_weights=TRUE,
    l1_reg=1,
    max_iterations=15,
    input_label_cols = ['label']) AS
SELECT
*
FROM
  `my_first_dataset.cc_default_balanced`
  
# evaluate the model
SELECT
  *
FROM
  ML.EVALUATE(MODEL `my_first_dataset.cc_default_mlmodel_from_balanced`,
    (
    SELECT
      *
    FROM
      `my_first_dataset.cc_default`))
