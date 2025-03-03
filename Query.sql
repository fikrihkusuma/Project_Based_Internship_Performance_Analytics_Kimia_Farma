CREATE TABLE `rakamin-kf-analytics-452214.kimia_farma.kf_combined_data` AS
SELECT 
    t.transaction_id,
    t.product_id,
    t.branch_id,
    t.customer_name,
    t.date,
    t.price AS transaction_price,
    t.discount_percentage,
    t.rating AS transaction_rating,
    p.product_name,
    p.product_category,
    p.price AS product_price,
    i.opname_stock,
    k.branch_category,
    k.branch_name,
    k.city,
    k.province,
    k.rating AS branch_rating,
    -- Calculate nett_sales
    (t.price * (1 - t.discount_percentage / 100)) AS nett_sales,
    CASE
        WHEN p.price <= 50000 THEN 10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 25
        WHEN p.price > 500000 THEN 30
    END AS percentage_gross_profit,
    (t.price * (1 - t.discount_percentage / 100)) * 
    (CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
    END) AS nett_profit
FROM `rakamin-kf-analytics-452214.kimia_farma.kf_final_transaction` t
LEFT JOIN `rakamin-kf-analytics-452214.kimia_farma.kf_product` p ON t.product_id = p.product_id
LEFT JOIN `rakamin-kf-analytics-452214.kimia_farma.kf_inventory` i ON t.product_id = i.product_id AND t.branch_id = i.branch_id
LEFT JOIN `rakamin-kf-analytics-452214.kimia_farma.kf_kantor_cabang` k ON t.branch_id = k.branch_id;