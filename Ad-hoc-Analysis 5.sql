WITH cte1 AS (
    SELECT product_name, category,
        SUM((base_price * quantity_sold_before_promo)) AS revenue_before_promo,
        SUM(
            CASE
                WHEN promo_type = '50% OFF' THEN (base_price - (base_price / 100) * 50) * quantity_sold_after_promo
                WHEN promo_type = '25% OFF' THEN (base_price - (base_price / 100) * 25) * quantity_sold_after_promo
                WHEN promo_type = '33% OFF' THEN (base_price - (base_price / 100) * 33) * quantity_sold_after_promo
                WHEN promo_type = '500 cashback' THEN (base_price - 500) * quantity_sold_after_promo
                WHEN promo_type = 'BOGOF' THEN (base_price / 2) * (2 * quantity_sold_after_promo)
            END
        ) AS revenue_after_promo
    FROM fact_events
    JOIN dim_products USING (product_code)
    JOIN dim_campaigns USING (campaign_id)
    GROUP BY product_name, category
),
cte2 AS (
    SELECT *,
        (revenue_after_promo - revenue_before_promo) AS IR,
        ROUND((revenue_after_promo - revenue_before_promo) / revenue_before_promo * 100, 2) AS `IR%`
    FROM cte1
)
SELECT product_name, category, `IR%`,
    RANK() OVER(ORDER BY `IR%` DESC) AS `Rank`
FROM cte2
LIMIT 5;
