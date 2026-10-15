-- stg_users: public.users tablosunun temizlenmiş hali
-- Yapılanlar: boşluk temizleme, isim/şehir düzeltme, e-postayı küçük harf,
-- telefondan sembolleri silme, status'u standartlaştırma, yaş hesaplama

with source as (

    select * from {{ source('raw', 'users') }}

),

cleaned as (

    select
        id                                                      as user_id,
        initcap(trim(first_name))                               as first_name,
        initcap(trim(last_name))                                as last_name,
        initcap(trim(first_name)) || ' ' || initcap(trim(last_name)) as full_name,
        nullif(lower(trim(email)), '')                          as email,
        nullif(regexp_replace(phone, '[^0-9+]', '', 'g'), '')   as phone,
        initcap(trim(city))                                     as city,
        birth_date,
        date_part('year', age(current_date, birth_date))::int   as age,
        lower(trim(status))                                     as status,
        lower(trim(status)) = 'active'                          as is_active,
        created_at

    from source

)

select * from cleaned
