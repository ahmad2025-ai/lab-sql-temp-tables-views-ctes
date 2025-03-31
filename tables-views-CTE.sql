CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


CREATE TEMPORARY TABLE customer_payment_summary
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
LEFT JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

WITH customer_summary AS (
    SELECT 
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid,
        ROUND(cps.total_paid / NULLIF(rs.rental_count, 0), 2) AS average_payment_per_rental
    FROM rental_summary rs
    LEFT JOIN customer_payment_summary cps ON rs.customer_id = cps.customer_id
)
SELECT * FROM customer_summary
ORDER BY total_paid DESC;

