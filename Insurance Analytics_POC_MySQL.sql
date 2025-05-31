--  1-No of Invoice by Accnt Exec
SELECT 
    `Account Executive`,
    COUNT(CASE WHEN income_class = 'New' THEN 1 END) AS `New`,
    COUNT(CASE WHEN income_class = 'Renewal' THEN 1 END) AS `Renewal`,
    COUNT(CASE WHEN income_class = 'Cross Sell' THEN 1 END) AS `Cross Sell`,
    COUNT(invoice_number) AS `number_of_invoices`
FROM invoice
GROUP BY `Account Executive`
order by  `number_of_invoices` desc ;

-- 2-Yearly Meeting Count
SELECT year(meeting_date) as Year,count(year(meeting_date)) as MeetingCount from meeting group by year(meeting_date) ;

-- 3.1Cross Sell--Target,Achive,new
SELECT 
    'Cross Sell' AS stage,
    COALESCE(invoice.total_cross, 0) AS Invoice,
    COALESCE(unified.total_cross, 0) AS Achivement,
    COALESCE(budget.cross_sell_budget, 0) AS Target
FROM 
    -- Subquery for Invoice Data
    (SELECT SUM(amount) AS total_cross 
     FROM invoice 
     WHERE income_class = 'Cross sell') AS invoice
     
    CROSS JOIN 
    -- Subquery for Unified Brokerage and Fees Data
    (SELECT SUM(amount) AS total_cross 
     FROM (
        SELECT income_class, SUM(amount) AS amount 
        FROM brokerage 
        GROUP BY income_class
        UNION ALL
        SELECT income_class, SUM(amount) AS amount 
        FROM fees 
        GROUP BY income_class
     ) unified 
     WHERE income_class = 'Cross sell') AS unified
     
    CROSS JOIN 
    -- Subquery for Budget Data
    (SELECT SUM(`Cross sell bugdet`) AS cross_sell_budget 
     FROM `individual budgets`) AS budget;
     
  -- 3.2New-Target,Achive,new 
SELECT 
    'New' AS stage,
    COALESCE(invoice.total_new, 0) AS Invoice,
    COALESCE(unified.total_new, 0) AS Achievement,
    COALESCE(budget.new_budget, 0) AS Target
FROM 
    -- Subquery for Invoice Data
    (SELECT SUM(amount) AS total_new 
     FROM invoice 
     WHERE income_class = 'New') AS invoice
     
    CROSS JOIN 
    -- Subquery for Unified Brokerage and Fees Data
    (SELECT SUM(amount) AS total_new 
     FROM (
        SELECT income_class, SUM(amount) AS amount 
        FROM brokerage 
        GROUP BY income_class
        UNION ALL
        SELECT income_class, SUM(amount) AS amount 
        FROM fees 
        GROUP BY income_class
     ) unified 
     WHERE income_class = 'New') AS unified
     
    CROSS JOIN 
    -- Subquery for Budget Data
    (SELECT SUM(`New Budget`) AS new_budget 
     FROM `individual budgets`) AS budget;
     
     -- 3.3Renewal-Target, Achive,new
SELECT
    'Renewal' AS stage,
    COALESCE(invoice.total_renewal, 0) AS Invoice,
    COALESCE(unified.total_renewal, 0) AS Achievement ,
    COALESCE(budget.renewal_budget, 0) AS Target
FROM 
    -- Subquery for Invoice Data
    (SELECT SUM(amount) AS total_renewal 
     FROM invoice 
     WHERE income_class = 'Renewal') AS invoice
     
    CROSS JOIN 
    -- Subquery for Unified Brokerage and Fees Data
    (SELECT SUM(amount) AS total_renewal 
     FROM (
        SELECT income_class, SUM(amount) AS amount 
        FROM brokerage 
        GROUP BY income_class
        UNION ALL
        SELECT income_class, SUM(amount) AS amount 
        FROM fees 
        GROUP BY income_class
     ) unified 
     WHERE income_class = 'Renewal') AS unified
     
    CROSS JOIN 
    -- Subquery for Budget Data
    (SELECT SUM(`Renewal Budget`) AS renewal_budget 
     FROM `individual budgets`) AS budget;
     --------------------------------------------
     -- Q4. Stage Funnel by Revenue
select stage , sum(revenue_amount) from opportunity group by stage;
-- ------------------------------------------------------------------------------------------------
-- Q5. No of meeting By Account Exe
select  `Account Executive`, count(meeting_date) from meeting group by `Account Executive` ;
-- ----------------------------------------------------------------------------------------------------
-- ..6-Top Open Opportunity
select opportunity_name,max(revenue_amount) as Revenue from opportunity
group by opportunity_name
order by revenue desc
limit 4;
     
     
     
     
