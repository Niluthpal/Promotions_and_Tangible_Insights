with ctel as (
    select *,
        (base_price * quantity_sold_before_promo) as revenue_before_promo,
        case
            when promo_type = "50% OFF" then (base_price - (base_price / 100) * 50) * quantity_sold_after_promo
            when promo_type = "25% OFF" then (base_price - (base_price / 100) * 25) * quantity_sold_after_promo
            when promo_type = "33% OFF" then (base_price - (base_price / 100) * 33) * quantity_sold_after_promo
            when promo_type = "500 cashback" then (base_price - 500) * quantity_sold_after_promo
            when promo_type = "BOGOF" then (base_price / 2) * (2 * quantity_sold_after_promo)
        end as revenue_after_promo,
        case
            when promo_type = "50% OFF" then quantity_sold_after_promo
            when promo_type = "25% OFF" then quantity_sold_after_promo
            when promo_type = "33% OFF" then quantity_sold_after_promo
            when promo_type = "500 cashback" then quantity_sold_after_promo
            when promo_type = "BOGOF" then quantity_sold_after_promo * 2
        end as sold_quantity_after_promo
    from fact_events
)
select promo_type,
    concat(round((sum(revenue_after_promo - revenue_before_promo) / 1000000), 2), "M") as Incremental_Revenue,
    round(sum(sold_quantity_after_promo - quantity_sold_before_promo), 2) as Incremental_Sold_Quantity,
    round(sum(revenue_after_promo - revenue_before_promo) / sum(revenue_before_promo) * 100, 2) as `IR%`,
    round(sum(sold_quantity_after_promo - quantity_sold_before_promo) / sum(quantity_sold_before_promo) * 100, 2) as `ISU%`
from ctel
where promo_type in ("BOGOF", "500 cashback")
group by promo_type;
