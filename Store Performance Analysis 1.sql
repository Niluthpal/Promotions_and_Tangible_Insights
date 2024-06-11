With cte1 as (
Select store_id,city,sum(quantity_sold_before_promo*base_price) 
as revenue_before_promo,
sum(
case
	when promo_type = "50% OFF" then (base_price-(base_price/100)*50) * quantity_sold_after_promo
    when promo_type = "25% OFF" then (base_price-(base_price/100)*25) * quantity_sold_after_promo
    when promo_type = "33% OFF" then (base_price-(base_price/100)*33) * quantity_sold_after_promo
    when promo_type = "500 cashback" then (base_price-500) * quantity_sold_after_promo
    When promo_type = "BOGOF" then (base_price/2) * (2*quantity_sold_after_promo)
end) as revenue_after_promo
from fact_events
join dim_stores
using (store_id)
group by store_id,city)

select 
store_id,city,concat(round((revenue_after_promo - revenue_before_promo)/1000000,2), " " , "M")
as Incremental_Revenue
from cte1
order by Incremental_Revenue desc
limit 10;
