 with cte1 as (
 select *,
		(base_price*quantity_sold_before_promo )as revenue_before_promo,
 case
	when promo_type = "50% OFF" then (base_price-(base_price/100)*50) * quantity_sold_after_promo
    when promo_type = "25% OFF" then (base_price-(base_price/100)*25) * quantity_sold_after_promo
    when promo_type = "33% OFF" then (base_price-(base_price/100)*33) * quantity_sold_after_promo
    when promo_type = "500 cashback" then (base_price-500) * quantity_sold_after_promo
    When promo_type = "BOGOF" then (base_price/2) * (2*quantity_sold_after_promo)
 end as revenue_after_promo
 from fact_events)
 
 select promo_type,
 concat(round(sum(revenue_after_promo-revenue_before_promo)/1000000,2)," ","M") as Incremental_Revenue 
 from cte1
 group by promo_type
 order by Incremental_Revenue desc
 limit 2;