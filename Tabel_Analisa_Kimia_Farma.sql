CREATE TABLE kimia_farma.kf_analysis AS
SELECT 
    ft.transaction_id,                      -- ID transaksi
    ft.date,                                -- Tanggal transaksi
    ft.branch_id,                           -- ID cabang
    kc.branch_name,                         -- Nama cabang
    kc.kota,                                -- Kota cabang
    kc.provinsi,                            -- Provinsi cabang
    kc.rating AS rating_cabang,             -- Penilaian cabang
    ft.customer_name,                       -- Nama customer
    ft.product_id,                          -- ID produk obat
    kp.product_name,                        -- Nama produk obat
    kp.price AS actual_price,               -- Harga produk obat
    ft.discount_percentage,                 -- Persentase diskon
    
    -- Menghitung persentase gross laba berdasarkan harga obat
    CASE 
        WHEN kp.price <= 50000 THEN 0.10
        WHEN kp.price > 50000 AND kp.price <= 100000 THEN 0.15
        WHEN kp.price > 100000 AND kp.price <= 300000 THEN 0.20
        WHEN kp.price > 300000 AND kp.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- Menghitung nett_sales (harga setelah diskon)
    kp.price * (1 - ft.discount_percentage / 100) AS nett_sales,

    -- Menghitung nett_profit (keuntungan yang diperoleh)
    (kp.price * (1 - ft.discount_percentage / 100)) * 
    CASE 
        WHEN kp.price <= 50000 THEN 0.10
        WHEN kp.price > 50000 AND kp.price <= 100000 THEN 0.15
        WHEN kp.price > 100000 AND kp.price <= 300000 THEN 0.20
        WHEN kp.price > 300000 AND kp.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit

FROM kimia_farma.kf_final_transaction ft
JOIN kimia_farma.kf_kantor_cabang kc ON ft.branch_id = kc.branch_id
JOIN kimia_farma.kf_product kp ON ft.product_id = kp.product_id;
