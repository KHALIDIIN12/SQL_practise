             --question 
  /* 
  Calculate each user's average session time, 
  where a session is defined as the time difference between a page_load and a page_exit. 
  Assume each user has only one session per day. 
  If there are multiple page_load or page_exit events on the same day, use only the latest page_load 
  and the earliest page_exit. Only consider sessions where the page_load occurs 
  before the page_exit on the same day. Output the user_id and their average session time.
  */

      --Table: facebook_web_log
CREATE TABLE facebook_web_log (
    user_id INT,
    timestamp DATETIME,
    action VARCHAR(50)
);

INSERT INTO facebook_web_log (user_id, timestamp, action)
VALUES
(0, '2019-04-25 13:30:15', 'page_load'),
(0, '2019-04-25 13:30:18', 'page_load'),
(0, '2019-04-25 13:30:40', 'scroll_down'),
(0, '2019-04-25 13:30:45', 'scroll_up'),
(0, '2019-04-25 13:31:10', 'scroll_down'),
(0, '2019-04-25 13:31:25', 'scroll_down'),
(0, '2019-04-25 13:31:40', 'page_exit'),
(1, '2019-04-25 13:40:00', 'page_load'),
(1, '2019-04-25 13:40:10', 'scroll_down'),
(1, '2019-04-25 13:40:15', 'scroll_down'),
(1, '2019-04-25 13:40:20', 'scroll_down'),
(1, '2019-04-25 13:40:25', 'scroll_down'),
(1, '2019-04-25 13:40:30', 'scroll_down'),
(1, '2019-04-25 13:40:35', 'page_exit'),
(2, '2019-04-25 13:41:21', 'page_load'),
(2, '2019-04-25 13:41:30', 'scroll_down'),
(2, '2019-04-25 13:41:35', 'scroll_down'),
(2, '2019-04-25 13:41:40', 'scroll_up'),
(1, '2019-04-26 11:15:00', 'page_load'),
(1, '2019-04-26 11:15:10', 'scroll_down'),
(1, '2019-04-26 11:15:20', 'scroll_down'),
(1, '2019-04-26 11:15:25', 'scroll_up'),
(1, '2019-04-26 11:15:35', 'page_exit'),
(0, '2019-04-28 14:30:15', 'page_load'),
(0, '2019-04-28 14:30:10', 'page_load'),
(0, '2019-04-28 13:30:40', 'scroll_down'),
(0, '2019-04-28 15:31:40', 'page_exit'),
(0, '2019-04-25 13:30:00', 'page_load'),
(0, '2019-04-25 13:30:20', 'page_load'),
(0, '2019-04-25 13:30:40', 'page_exit');

      -- solution
SELECT
    user_id,
    AVG(session_time) AS avg_session_time
FROM (
    SELECT
        user_id,
        TIMESTAMPDIFF(
            SECOND,
            MAX(CASE
                WHEN action = 'page_load'
                THEN timestamp
            END),
            MIN(CASE
                WHEN action = 'page_exit'
                THEN timestamp
            END)
        ) AS session_time
    FROM facebook_web_log
    WHERE action IN ('page_load', 'page_exit')
    GROUP BY user_id, DATE(timestamp)
    HAVING
        MAX(CASE WHEN action = 'page_load' THEN timestamp END)
        <
        MIN(CASE WHEN action = 'page_exit' THEN timestamp END)
) AS sessions
GROUP BY user_id;


  -- what i learned
  /*
- CASE WHEN
- MAX() and MIN()
- TIMESTAMPDIFF()
- AVG()
- GROUP BY
- HAVING
- Subqueries
*/