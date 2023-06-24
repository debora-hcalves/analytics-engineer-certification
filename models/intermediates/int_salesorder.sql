with salesorder as (
    select *
    from {{ ref('stg_salesorderheader') }}
)

, credicard as (
    select *
    from {{ ref('stg_creditcard') }}
)

, salesordersalesreason as (
    select
        *
    from {{ ref('stg_salesorderheadersalesreason') }}
)

, salesreason as (
    select
        *
    from {{ ref('stg_salesreason') }}
)

, orderdetail as (
    select
        *
    from {{ ref('stg_salesorderdetail') }}
)


select
    so.salesorder_id
    , so.order_date
    , so.status
    , coalesce(cc.card_type, 'not a creditcard purchase') as card_type
    , so.customer_id
    , so.address_id
from salesorder as so
left join credicard as cc on so.creditcard_id = cc.creditcard_id
order by salesorder_id

--select
    --so.salesorder_id
    --, od.orderdetail_id
    --, so.order_date
    --, so.status
    --, so.customer_id
    --, sr.name_reason 
    --, c.card_type
    --, so.address_id
--from salesorder as so
--left join salesordersalesreason as sosr on so.salesorder_id = sosr.salesorder_id
--left join salesreason as sr on sosr.salesreason_id = sr.salesreason_id
--left join credicard as c on so.creditcard_id = c.creditcard_id
--left join order_detail as od on so.salesorder_id = od.salesorder_id
--order by so.salesorder_id