with cte1 as (
    select *,
           case 
               when promo_type = "50% OFF" then round(base_price - (base_price / 100) * 50, 2)
               when promo_type = "25% OFF" then round(base_price - (base_price / 100) * 25, 2)
               when promo_type = "33% OFF" then round(base_price - (base_price / 100) * 33, 2)
               when promo_type = "500 cashback" then round(base_price - 500, 2)
               when promo_type = "BOGOF" then base_price
           end as price_after_promotion
    from fact_events
    join dim_campaigns
    using (campaign_id)
)
select campaign_name,
       concat(round(sum((base_price * quantity_sold_before_promo)) / 1000000, 2), ' ' 'M') as revenue_before_promo,
       concat(round(sum((price_after_promotion * quantity_sold_after_promo)) / 1000000, 2), ' ' 'M') as revenue_after_promo
from cte1
group by campaign_name;
