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

WITH
  T AS (
  SELECT
    centroid_id,
    ARRAY_AGG(STRUCT(feature AS name,
        ROUND(numerical_value,1) AS value)
    ORDER BY
      centroid_id) AS cluster
  FROM
    ML.CENTROIDS(MODEL `summer-project-1.my_first_dataset.kmeans_natality_model`)
  GROUP BY
    centroid_id )
SELECT
  CONCAT('Cluster#', CAST(centroid_id AS STRING)) AS centroid,
  (
  SELECT
    value
  FROM
    UNNEST(cluster)
  WHERE
    name = 'weight_pounds') AS weight_pounds,
  (
  SELECT
    value
  FROM
    UNNEST(cluster)
  WHERE
    name = 'is_male') AS is_male,
  (
  SELECT
    value
  FROM
    UNNEST(cluster)
  WHERE
    name = 'gestation_weeks') AS gestation_weeks,
  (
  SELECT
    value
  FROM
    UNNEST(cluster)
  WHERE
    name = 'mother_race') AS mother_race
FROM
  T
ORDER BY
  centroid_id ASC
