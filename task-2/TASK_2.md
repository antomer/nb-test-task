# Task 2

## Task definition

Perform Code Review for PHP code in [auth.php](https://github.com/antomer/nb-test-task/blob/master/task-2/auth.php)

## Code Review
1. In [L5](https://github.com/antomer/nb-test-task/blob/master/task-2/auth.php#L5) code is vulnerable to SQL injection attacks as it directly concatenates user inputs into SQL queries. It's would be much secure to use [prepared statements](https://www.w3schools.com/php/php_mysql_prepared_statements.asp)
2. Seems like plain text passwords are stored in DB. this is no go and hashing algorithm should be used.
3. The database connection details on [L4](https://github.com/antomer/nb-test-task/blob/master/task-2/auth.php#L4) are hard-coded, which makes it difficult to change them in different environments. It's recommended to use environment variables or configuration files to store application settings and separate them from the code.
4. No logging functionality is implement, it makes it difficult to debug issues and monitor application behavior. 
5. No status code is returened to the client.
6. No proper exception handling is implemented. Any errors that occur during the database connection, query execution, or result processing are not reported
7. From code cleanless perspective it would be nice to separate code to separate functions. currently it combines db access, user input processing adn response generation.