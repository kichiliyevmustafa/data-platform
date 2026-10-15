-- Kaynak (raw) tablo: public.users
-- Test verisi bilerek "kirli": boşluklar, büyük/küçük harf karışık e-postalar,
-- farklı telefon formatları, tutarsız status değerleri.

DROP TABLE IF EXISTS public.users CASCADE;

CREATE TABLE public.users (
    id          SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100),
    phone       VARCHAR(30),
    city        VARCHAR(50),
    birth_date  DATE,
    status      VARCHAR(20),
    created_at  TIMESTAMP DEFAULT now()
);

INSERT INTO public.users (first_name, last_name, email, phone, city, birth_date, status, created_at) VALUES
('  Mustafa', 'Kichiliyev ', 'Mustafa@Example.COM',  '+994 50 123 45 67', 'Baku',     '1995-04-12', 'active',   '2026-01-05 10:15:00'),
('ayse',      'DEMIR',       'ayse.demir@mail.com',  '0501234568',        'istanbul', '1990-08-23', 'ACTIVE',   '2026-01-10 09:00:00'),
('Murad',     'Aliyev',      ' murad@mail.az ',      '+994-55-987-65-43', 'Ganja',    '1988-12-01', 'inactive', '2026-02-02 14:30:00'),
('Leyla',     'Huseynova',   'LEYLA.H@MAIL.AZ',      NULL,                'Baku',     '2000-06-17', 'Active',   '2026-02-15 11:45:00'),
('Ali',       'Yilmaz',      'ali.yilmaz@mail.com',  '(050) 777 88 99',   'Ankara',   '1992-03-30', 'banned',   '2026-03-01 08:20:00'),
('Nigar',     'Mammadova',   NULL,                   '+994701112233',     'Sumqayit', '1998-11-09', 'active',   '2026-03-12 16:05:00'),
('Emre',      'Kaya',        'emre.kaya@mail.com',   '0532 444 55 66',    'Izmir',    NULL,         'pending',  '2026-04-20 13:10:00'),
('Kamran',    'Rzayev',      'kamran@mail.az',       '+994 51 222 33 44', 'baku',     '1985-07-25', 'INACTIVE', '2026-05-03 19:40:00'),
('Zeynep',    'Arslan',      'Zeynep.Arslan@Mail.com','05551239876',      'Istanbul', '1997-01-14', 'active',   '2026-06-18 07:55:00'),
('Rashad',    'Quliyev',     'rashad.q@mail.az',     '+994 77 555 66 77', 'Ganja',    '1993-09-02', ' active ', '2026-07-01 12:00:00');
