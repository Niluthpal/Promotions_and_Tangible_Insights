WITH cte1 AS (
    SELECT *,
        CASE
            WHEN promo_type = '50% OFF' THEN quantity_sold_after_promo
            WHEN promo_type = '25% OFF' THEN quantity_sold_after_promo
            WHEN promo_type = '33% OFF' THEN quantity_sold_after_promo
            WHEN promo_type = '500 cashback' THEN quantity_sold_after_promo
            WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo * 2
        END AS sold_quantity_after_promo
    FROM fact_events
    JOIN dim_campaigns USING (campaign_id)
    JOIN dim_products USING (product_code)
    WHERE campaign_name = 'Diwali'
),
cte2 AS (
    SELECT category,
        ROUND(
            SUM((sold_quantity_after_promo - Quantity_sold_before_promo)) /
            SUM(Quantity_sold_before_promo) * 100, 2
        ) AS `ISU%`
    FROM cte1
    GROUP BY category
)
SELECT *,
    ROW_NUMBER() OVER(ORDER BY `ISU%` DESC) AS `Rank`
FROM cte2;
