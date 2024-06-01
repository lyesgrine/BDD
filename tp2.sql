
-- a

SET SERVEROUTPUT ON;
DECLARE
    name VARCHAR2(100);
    job VARCHAR2(100);
    salary NUMBER;
    salary_formatted VARCHAR2(100);

BEGIN
    FOR emp_rec IN (SELECT e.first_name AS employee_name, 
        j.job_title, e.salary
    FROM hr.employees e
    JOIN hr.jobs j ON e.job_id = j.job_id)
    LOOP
        name := emp_rec.employee_name;
        job := emp_rec.job_title;
        salary := emp_rec.salary;

        salary_formatted := RPAD('*', TRUNC(salary / 1000), 
            '*') || TO_CHAR(salary, 'FM9990');

        DBMS_OUTPUT.PUT_LINE(RPAD(name, 10) || ' est un ' 
            || RPAD(job, 10) || ', il touche un salaire de ' 
            || salary_formatted);
    END LOOP;
END;


-- b

CREATE OR REPLACE FUNCTION New_SAL(old_sal IN 
    NUMBER, pct IN NUMBER DEFAULT NULL)
RETURN NUMBER IS new_salary NUMBER;
BEGIN
    IF pct IS NULL THEN
        RETURN old_sal;
    ELSE
        new_salary := old_sal * (1 + pct);
        RETURN new_salary;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        RETURN old_sal;
END;


-- c

ALTER TABLE employees ADD new_salary NUMBER;


-- d

CREATE OR REPLACE PROCEDURE Update_New_Salary IS
BEGIN
    FOR emp_rec IN (SELECT employee_id, salary, 
        commission_pct FROM employees)
    LOOP
        UPDATE employees
        SET new_salary = New_SAL(emp_rec.salary, 
        emp_rec.commission_pct) WHERE employee_id 
            = emp_rec.employee_id;
    END LOOP;
    COMMIT;
END;


-- e

SELECT first_name || ' ' || last_name AS employee_name,
    salary AS old_salary,new_salary AS new_salary_before
FROM employees;

EXEC Update_New_Salary;

SELECT first_name || ' ' || last_name AS employee_name,
    salary AS old_salary,
    new_salary AS new_salary_after
FROM employees;


-- f
DECLARE
  CURSOR emp_cursor IS
  SELECT ename, job, hiredate
  FROM emp;
  
  v_name emp.ename%TYPE;
  v_job emp.job%TYPE;
  v_hire_date emp.hiredate%TYPE;
  v_months NUMBER;
  v_days NUMBER;
BEGIN
  OPEN emp_cursor;
  LOOP
    FETCH emp_cursor INTO v_name, v_job, v_hire_date;
    EXIT WHEN emp_cursor%NOTFOUND;
    
    v_months := MONTHS_BETWEEN(SYSDATE, v_hire_date);
    v_days := DAYS_BETWEEN(SYSDATE, v_hire_date);
    
    DBMS_OUTPUT.PUT_LINE(v_name || '  ' || v_job || '  ' ||
                         TO_CHAR(v_hire_date, 'DD-MON-YYYY') 
                         || '  ' ||
                         ROUND(v_months / 12) || ' months ' 
                         ||
                         MOD(v_months, 12) || ' days');
  END LOOP;
  CLOSE emp_cursor;
END;



-- g

ALTER TABLE employees ADD prochain_promo DATE;


-- h
UPDATE emp
SET prochain_promo = hiredate + (100/12) 
    * MONTHS_BETWEEN(SYSDATE, hiredate);

