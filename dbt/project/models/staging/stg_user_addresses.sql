-- stg_user_addresses: public.user_addresses tablosunun temizlenmiş hali
-- Yapılanlar: boşluk temizleme, adres tipini standartlaştırma, şehir/semt düzeltme,
-- posta kodunu büyük harf + boşluksuz yapma, ülke adlarını ISO koduna çevirme

with source as (

    select * from {{ source('raw', 'user_addresses') }}

),

cleaned as (

    select current_date as load_date,
        id                                                  as address_id,
        user_id,
        lower(trim(address_type))                           as address_type,
        regexp_replace(trim(street), '\s+', ' ', 'g')       as street,
        initcap(trim(district))                             as district,
        initcap(trim(city))                                 as city,
        upper(replace(trim(postal_code), ' ', ''))          as postal_code,
        case
            when lower(trim(country)) in ('az', 'aze', 'azerbaijan', 'azerbaycan') then 'AZ'
            when lower(trim(country)) in ('tr', 'turkey', 'turkiye', 'türkiye')    then 'TR'
            else upper(trim(country))
        end                                                 as country_code,
        coalesce(is_primary, false)                         as is_primary,
        created_at

    from source

)

select * from cleaned
