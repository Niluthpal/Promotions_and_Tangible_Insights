 with cte1 as (
 select *,
 case
	when promo_type = "50% OFF" then quantity_sold_after_promo
    when promo_type = "25% OFF" then quantity_sold_after_promo
    when promo_type = "33% OFF" then quantity_sold_after_promo
    when promo_type = "500 cashback" then quantity_sold_after_promo
    When promo_type = "BOGOF" then quantity_sold_after_promo*2
end as sold_quantity_after_promo
from fact_events)
select promo_type,
sum(sold_quantity_after_promo-quantity_sold_before_promo) as Incremental_Sold_Unit
from cte1
group by promo_type
order by Incremental_Sold_Unit asc
limit 2;