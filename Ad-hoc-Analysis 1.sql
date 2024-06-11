select distinct(dp.product_name),
                fe.base_price,
                fe.promo_type
from fact_events fe
join dim_products dp
on dp.product_code = fe.product_code
where base_price > 500 and
      promo_type = "BOGOF";
