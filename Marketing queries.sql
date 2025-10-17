CREATE TABLE campaign_data (
    ad_id INTEGER,
    reporting_start DATE,
    reporting_end DATE,
    campaign_id TEXT, 
    fb_campaign_id INTEGER,
    age TEXT,
    gender TEXT,
    interest1 INTEGER,
    interest2 INTEGER,
    interest3 INTEGER,
    impressions INTEGER,
    clicks INTEGER,
    spent NUMERIC, 
    total_conversion INTEGER,
    approved_conversion INTEGER
);

SELECT * FROM campaign_data;


--Top 10 Ads by Impressions:
SELECT age, gender, impressions 
FROM campaign_data
ORDER BY impressions DESC LIMIT 10;


--Total Spent by Gender:
SELECT gender, 
	SUM(spent) AS total_spent 
FROM campaign_data
GROUP BY gender 
ORDER BY total_spent DESC;


--Average Impressions by Age Group:
SELECT age, AVG(impressions) AS avg_impressions, COUNT(*) AS ad_count 
FROM campaign_data
GROUP BY age 
HAVING AVG(impressions) > 10000 
ORDER BY avg_impressions DESC;


--Clicks and CTR by campaign:
SELECT campaign_id, SUM(clicks) AS total_clicks, 
       SUM(impressions) AS total_impressions,
       ROUND((SUM(clicks)::numeric / NULLIF(SUM(impressions), 0)) * 100, 2) AS ctr_percent
FROM campaign_data
GROUP BY campaign_id 
ORDER BY total_clicks DESC;


--Demographic Performance with Conversion Rate:
SELECT 
  age, 
  gender, 
  SUM(approved_conversion) AS total_approved,
  SUM(impressions) AS total_impressions,
  ROUND((SUM(approved_conversion)::numeric / NULLIF(SUM(impressions), 0)) * 100, 2) AS conv_rate_percent
FROM campaign_data
GROUP BY age, gender
HAVING SUM(impressions) > 50000
ORDER BY conv_rate_percent DESC;


--Best Interest Rate with High CTR:
SELECT interest1, interest2, interest3,
       SUM(clicks) AS total_clicks,
       SUM(impressions) AS total_impressions,
       ROUND((SUM(clicks)::numeric / NULLIF(SUM(impressions), 0)) * 100, 2) AS ctr_percent,
       ROW_NUMBER() OVER (PARTITION BY interest1 ORDER BY (SUM(clicks)::numeric / NULLIF(SUM(impressions), 0)) DESC) AS interest_rank
FROM campaign_data
WHERE impressions > 1000
GROUP BY interest1, interest2, interest3
HAVING SUM(impressions) > 10000
ORDER BY ctr_percent DESC
LIMIT 10;


