CREATE OR REPLACE MODEL
  `summer-project-1.my_first_dataset.kmeans_natality_model`
OPTIONS
  (model_type='kmeans',
    num_clusters=3,
    standardize_features = TRUE) AS  
  SELECT
    weight_pounds,
      is_male,
      gestation_weeks,
      mother_age,
      CAST(mother_race AS STRING) AS mother_race
  FROM
    `bigquery-public-data.samples.natality`
  WHERE RAND() <= 0.001  
