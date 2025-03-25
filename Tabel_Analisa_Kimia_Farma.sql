CREATE TABLE kimia_farma.kf_analysis AS
SELECT 
    ft.transaction_id,
    ft.date,
    ft.branch_id,  
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    ft.rating AS rating_transaksi,  
    ft.customer_name,
    ft.product_id,
    kp.product_name,
    kp.price AS actual_price,  
    ft.discount_percentage,

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
