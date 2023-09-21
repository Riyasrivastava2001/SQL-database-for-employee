CREATE DATABASE E;

CREATE TABLE E.employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE E.branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE E.employee ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;
ALTER TABLE E.employee ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;

CREATE TABLE E.client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE E.works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE E.branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);
-- Corporate
INSERT INTO E.employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO E.branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO E.employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO E.employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO E.branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE E.employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO E.employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO E.employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO E.employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO E.employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO E.branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE E.employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO E.employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO E.employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO E.branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO E.branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO E.branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO E.branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO E.branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO E.branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO E.branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO E.client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO E.client VALUES(401, 'Lackawana Country', 2);
INSERT INTO E.client VALUES(402, 'FedEx', 3);
INSERT INTO E.client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO E.client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO E.client VALUES(405, 'Times Newspaper', 3);
INSERT INTO E.client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO E.works_with VALUES(105, 400, 55000);
INSERT INTO E.works_with VALUES(102, 401, 267000);
INSERT INTO E.works_with VALUES(108, 402, 22500);
INSERT INTO E.works_with VALUES(107, 403, 5000);
INSERT INTO E.works_with VALUES(108, 403, 12000);
INSERT INTO E.works_with VALUES(105, 404, 33000);
INSERT INTO E.works_with VALUES(107, 405, 26000);
INSERT INTO E.works_with VALUES(102, 406, 15000);
INSERT INTO E.works_with VALUES(105, 406, 130000);


SELECT * FROM E.employee;
SELECT * FROM E.branch;
SELECT * FROM E.client;
SELECT * FROM E.branch_supplier;
SELECT * FROM E.works_with;

SELECT * FROM E.employee LIMIT 5;

SELECT * FROM E.employee ORDER BY sex,first_name,last_name;
SELECT first_name AS forename,last_name AS surname FROM E.employee ;
SELECT DISTINCT sex FROM E.employee;
SELECT COUNT(emp_id) FROM E.employee;
SELECT COUNT(emp_id) FROM E.employee WHERE sex='F' AND birth_day>'1970-01-01';
SELECT AVG(salary) FROM E.employee;
SELECT AVG(salary) FROM E.employee WHERE sex='M';
SELECT SUM(salary) FROM E.employee;
SELECT COUNT(sex),sex FROM E.employee GROUP BY sex ;
SELECT SUM(total_sales),emp_id FROM E.works_with GROUP BY emp_id ;
SELECT SUM(total_sales),emp_id FROM E.works_with GROUP BY emp_id ;
SELECT SUM(total_sales),client_id FROM E.works_with GROUP BY client_id ;

SELECT * FROM E.client WHERE client_name LIKE "%LLC";
SELECT * FROM E.branch_supplier WHERE supplier_name LIKE "%Lables%";
SELECT * FROM E.employee WHERE birth_day LIKE "____-10-__";
SELECT * FROM E.employee WHERE birth_day LIKE "____-10%";
SELECT first_name FROM E.employee UNION SELECT branch_name FROM E.branch;

SELECT client_name ,branch_id FROM E.client 
UNION
SELECT supplier_name ,branch_id FROM E.branch_supplier;

INSERT INTO E.branch VALUES(4,'Buffalo',NULL,NULL);
select * from E.branch;


SELECT employee.emp_id,employee.first_name,branch.branch_name
FROM E.employee
JOIN E.branch
ON employee.emp_id=branch.mgr_id;


SELECT employee.emp_id,employee.first_name,branch.branch_name
FROM E.employee
LEFT JOIN E.branch
ON employee.emp_id=branch.mgr_id;

SELECT employee.emp_id,employee.first_name,branch.branch_name
FROM E.employee
RIGHT JOIN E.branch
ON employee.emp_id=branch.mgr_id;



-- Find names of all employees who have sold over 50,000
SELECT employee.first_name, employee.last_name
FROM E.employee
WHERE employee.emp_id IN (SELECT works_with.emp_id
                          FROM E.works_with
                          WHERE works_with.total_sales > 50000);
                          
 
 
 -- FIND ALL THE CLIENTS WHO ARE HANDLED BY THE BRANCH
 -- THAT MICHAEL SCOTT MANAGES
 -- ASSUME YOU KNOW MICHAEL'S ID
 
 
 SELECT client_name FROM E.client WHERE branch_id=(
	SELECT branch.branch_id FROM E.branch WHERE branch.mgr_id =102 LIMIT 1);
 
 
 
 
 
 CREATE TABLE E.trigger_test(
	message VARCHAR(100)
 );
INSERT INTO E.employee VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);
 SELECT * FROM E.trigger_test;
 
 
 INSERT INTO E.employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);
 
SELECT * FROM E.trigger_test;

INSERT INTO E.employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);














































