with 
    address as (
        select

            -- primary key
            address_id

            -- city name
            , city

            -- foreign key
        , stateprovince_id

        from {{ ref('stg_address') }} 
    )

    , shippedto as (
        select

            -- primary key
            salesorder_id

            -- foreign keys
            , address_id
            , territory_id

        from {{ ref('stg_salesorderheader') }}
    )

    , stateprovince as (
        select

            -- primary key
            stateprovince_id

            --state name
            , name_state

            -- foreign keys
            , territory_id
            , countryregion_code

        from {{ ref('stg_stateprovince') }}
    )

    , countryregion as (
        select

            -- primary key
            countryregion_code

            -- country name
            , name_country

        from {{ ref('stg_countryregion') }}
    )

    , territory as (
        select

            -- primary key
            territory_id

            -- territory name
            , name_territory

            -- foreign key
            , countryregion_code

        from {{ ref('stg_salesterritory') }}
    )

    , join_shipped_address as (
        select

            -- columns from shippedto
            st.address_id
            , st.salesorder_id

            -- partition on address id by salesorder id from shippedto
            , row_number () over (partition by st. address_id order by st.salesorder_id) as row_address_id

            -- columns address 
            , a.city
            , a.stateprovince_id

        from shippedto as st
        left join address as a on st.address_id = a.address_id
    )

    , join_address_state as (
        select

            -- columns from join_shipped_address key
            jsa.address_id
            , jsa.row_address_id
            , jsa.city

            -- columns from state province
            , sp. name_state
            , sp.countryregion_code
            , sp.territory_id
        from join_shipped_address as jsa
        inner join stateprovince as sp on jsa.stateprovince_id = sp.stateprovince_id
        where jsa.row_address_id = 1
    )

    , join_country_territory as (
        select

            -- columns from join_address_state
            jas.address_id
            , jas.city
            , jas.name_state

            -- column from country region
            , cr.name_country

            -- column from territory
            , t.name_territory

        from join_address_state as jas
        inner join countryregion as cr on jas.countryregion_code = cr.countryregion_code
        inner join territory as t on jas.territory_id = t.territory_id
    )

select *
from join_country_territory


