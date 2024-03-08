/* connect to the postgres database with psql */
/* -U for user, default: system user */
/* -d for databse, default: postgres */
/* -h for host, default: localhost */
/* -p for post, default: 5432 */

psql -U postgres -d isil


/* to see all the databases and their owners */
\l

/* \l+ to see more details */


/* to see connection  info */
\conninfo 
/* to change database connection */
\c  newdatabase   


/* to see all users and their privileges */
\du
/* d for describe, u for users */
/* \du+ to see more details */



/* to describe the talbes in the current database */
\d

/* or \d+ for more details */

/* to describe a table */
\d users

/* or \d+ users for more details */


/* explaining a sql quiery */
explain select * from users;

/* you can add the analyze keyword to see time cost */
explain analyze select * from users;

/* explaining with index */
explain select * from users where id =1;

/* explaining with aggregate function */
explain select count(*) from users;

/* explaining with join */
explain select * from users u INNER JOIN 
products p on u.id=p.id;

/* explaining with join and index */
EXPLAIN SELECT * FROM users u 
INNER JOIN products p ON u.id = p.id 
INNER JOIN session s ON u.id = s.sid 
WHERE u.id = 1 AND s.sid = 1;

/* explaining with complex joins and indexs */
EXPLAIN SELECT * FROM users u 
INNER JOIN products p ON u.id = p.id 
INNER JOIN commands c ON u.id = c.user_id 
WHERE u.id = 1 AND c.user_id = 1;

/* explaining with complex joins and indexs */
EXPLAIN ANALYZE select count(*) from users;


EXPLAIN ANALYZE SELECT * FROM users u INNER JOIN products p ON u.id = p.id 
INNER JOIN commands c ON u.id = c.user_id WHERE u.id = 1 AND c.user_id = 1;

EXPLAIN SELECT u.id, u.name, 
COUNT(c.command_id) AS total FROM users u 
INNER JOIN products p ON u.id = p.id 
INNER JOIN commands c ON u.id = c.user_id 
WHERE u.id = 1 AND c.user_id = 1
GROUP BY u.id, u.name;