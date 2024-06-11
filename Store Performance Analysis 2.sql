

With cte1 as (
Select store_id,city,quantity_sold_before_promo,
case
	when promo_type = "50% OFF" then quantity_sold_after_promo
    when promo_type = "25% OFF" then quantity_sold_after_promo
    when promo_type = "33% OFF" then quantity_sold_after_promo
    when promo_type = "500 cashback" then quantity_sold_after_promo
    When promo_type = "BOGOF" then quantity_sold_after_promo*2
end as sold_quantity_after_promo
from fact_events
join dim_stores
using (store_id))

select store_id,city,sum(sold_quantity_after_promo - quantity_sold_before_promo)
as Incremental_Sold_Unit
from cte1
group by store_id,city
order by Incremental_Sold_Unit asc
limit 10;