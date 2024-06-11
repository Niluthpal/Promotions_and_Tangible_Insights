with cte1 as (
 select *,
		(base_price*quantity_sold_before_promo )as revenue_before_promo,
 case
	when promo_type = "50% OFF" then (base_price-(base_price/100)*50) * quantity_sold_after_promo
    when promo_type = "25% OFF" then (base_price-(base_price/100)*25) * quantity_sold_after_promo
    when promo_type = "33% OFF" then (base_price-(base_price/100)*33) * quantity_sold_after_promo
    when promo_type = "500 cashback" then (base_price-500) * quantity_sold_after_promo
    When promo_type = "BOGOF" then (base_price/2) * (2*quantity_sold_after_promo)
 end as revenue_after_promo,
 case
	when promo_type = "50% OFF" then quantity_sold_after_promo
    when promo_type = "25% OFF" then quantity_sold_after_promo
    when promo_type = "33% OFF" then quantity_sold_after_promo
    when promo_type = "500 cashback" then quantity_sold_after_promo
    When promo_type = "BOGOF" then quantity_sold_after_promo*2
 end as sold_quantity_after_promo
 from fact_events
 join dim_products
 using (product_code))
select product_name,category,
sum(sold_quantity_after_promo-quantity_sold_before_promo) as Incremental_Sold_Quantity
from cte1
group by product_name,category
order by Incremental_Sold_Quantity desc
limit 5;
