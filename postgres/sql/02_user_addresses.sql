-- Kaynak (raw) tablo: public.user_addresses
-- Bir kullanıcının birden fazla adresi olabilir (ev, iş...).
-- Test verisi bilerek "kirli": boşluklar, büyük/küçük harf, farklı ülke yazımları,
-- boşluklu posta kodları, tutarsız adres tipleri.

DROP TABLE IF EXISTS public.user_addresses;

CREATE TABLE public.user_addresses (
    id            SERIAL PRIMARY KEY,
    user_id       INT REFERENCES public.users(id),
    address_type  VARCHAR(20),
    street        VARCHAR(150),
    district      VARCHAR(50),
    city          VARCHAR(50),
    postal_code   VARCHAR(20),
    country       VARCHAR(50),
    is_primary    BOOLEAN DEFAULT false,
    created_at    TIMESTAMP DEFAULT now()
);

INSERT INTO public.user_addresses (user_id, address_type, street, district, city, postal_code, country, is_primary, created_at) VALUES
(1,  'HOME',   '  Nizami kuc. 25, menzil 12', 'Sabail',     'baku',     'AZ 1000',  'Azerbaijan',  true,  '2026-01-05 10:20:00'),
(1,  'work ',  'Neftchilar pr. 153',          'Nasimi',     'Baku',     'AZ1010',   'AZ',          false, '2026-01-06 09:00:00'),
(2,  'Home',   'Bagdat Cad. No:45 D:7',       'kadikoy',    'ISTANBUL', '34710',    'Turkey',      true,  '2026-01-10 09:05:00'),
(3,  'home',   'Ataturk pr. 18',              NULL,         'Ganja',    'az2000',   'azerbaycan',  true,  '2026-02-02 14:35:00'),
(4,  'HOME',   'Hasan bey Zardabi 78  ',      'Yasamal',    'Baku',     ' AZ 1122 ','AZE',         true,  '2026-02-15 11:50:00'),
(4,  'Billing','28 May kuc. 3',               'Nasimi',     'baku',     'AZ1000',   'Azerbaijan',  false, '2026-02-16 10:00:00'),
(5,  'home',   'Kizilay Mah. 12. Sok. No:3',  'Cankaya',    'ankara',   '06420',    'TR',          true,  '2026-03-01 08:25:00'),
(6,  'Home',   'Samed Vurgun kuc. 5',         NULL,         'Sumqayit', 'AZ 5000',  'Azerbaijan',  true,  '2026-03-12 16:10:00'),
(7,  'WORK',   'Alsancak Mah. Kibris Sehitleri Cad. 88', 'Konak', 'izmir', '35220', 'Türkiye',    true,  '2026-04-20 13:15:00'),
(9,  'home',   'Istiklal Cad. 101',           'Beyoglu',    'Istanbul', '34430',    'turkiye',     true,  '2026-06-18 08:00:00'),
(10, ' home ', 'Heydar Aliyev pr. 42',        NULL,         'GANJA',    'AZ2001',   'Azerbaijan',  true,  '2026-07-01 12:05:00');
