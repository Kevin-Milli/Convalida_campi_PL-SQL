# Oracle SQLDeveloper Validation Project

## Overview
This project demonstrates a data validation process implemented in Oracle SQLDeveloper.
The project is divided into five phases and is designed to validate and categorize data based on a set of business rules. 
The code includes user creation, table setup, data insertion, logging mechanisms, and stored procedures to validate data for errors.

## Project Structure
1. User and Privileges Setup (Phase 01)
The first phase of the project creates a new user and assigns necessary privileges.
```sql
CREATE USER ck IDENTIFIED BY ck;

GRANT dba, resource, connect TO ck;
```

## 2. DDL - Table Creation (Phase 02)
This phase defines the structure of three main tables:

- `t1`: A table to store raw user data.
- `t1Bad`: A table to store invalid data entries from t1.
- `t_log_event`: A table to log validation events.
- `log_seq`: A sequence used for logging event IDs.
```sql
CREATE TABLE t1 (codFisc, nome, cogn, mail, dataN, tel);
CREATE TABLE t1Bad AS (SELECT * FROM t1);
ALTER TABLE t1Bad ADD summary VARCHAR(500);
CREATE TABLE t_log_event (event_id, event_description, event_time, event_type);
CREATE SEQUENCE log_seq START WITH 1 INCREMENT BY 1;
```

## 3. DML - Data Insertion (Phase 03)
This phase inserts both valid and invalid sample data into the t1 table. 
Invalid data entries include issues like incorrect fiscal codes, invalid email formats, and incorrect date formats.
```sql
-- Example of a valid entry:
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) 
VALUES ('ABC', 'Francesco', 'Verdi', 'verdi@example.com', TO_DATE('20/05/1985', 'DD/MM/YYYY'), 1234567890);

-- Example of an invalid entry:
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) 
VALUES ('AB', 'Simona', 'Verdi', 'verdi@example.com', TO_DATE('20/05/1985', 'DD/MM/YYYY'), 1234567890);
```

## 4. Logging Package (Phase 04)
A PL/SQL package (pkg_utils) is created to log events to the t_log_event table. It helps track validation issues or errors during the process.
```sql
CREATE OR REPLACE PACKAGE pkg_utils IS
    PROCEDURE plog(v_event_description VARCHAR2, v_event_type VARCHAR2);
END pkg_utils;
```

## 5. Validation Package (Phase 05)
The core of the project lies in the pkg_ck package. It provides functions to validate:

`check_codfisc`: Validates the Italian fiscal code.
`check_nome_cogn`: Validates names and surnames based on length and allowed characters.
`is_valid_email`: Validates email formats.
`is_valid_dob`: Ensures the date of birth is valid and within realistic limits.
`is_valid_cell`: Validates the phone number format.
The `p_check` procedure orchestrates the validation process, checking each entry in t1. 
Valid entries are moved to a new table (t1ok), while invalid ones are logged and moved to t1Bad with a summary of errors.
```sql
CREATE OR REPLACE PACKAGE pkg_ck IS
    FUNCTION check_codfisc(cod_fisc CHAR) RETURN NUMBER;
    FUNCTION check_nome_cogn(nomecogn VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_email(p_email VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_dob(p_dob VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_cell(phone_number VARCHAR2) RETURN NUMBER;
    PROCEDURE p_check;
END pkg_ck;
```

### How to Run
Clone this repository to your local environment.
Use Oracle SQLDeveloper to run the scripts in sequence from Phase 01 to Phase 05.
Load the sample data into the t1 table.
Execute the p_check procedure to start the validation process.
Check the t1ok table for valid entries and the t1Bad table for invalid entries with error summaries.
Logging
All validation events, including errors, are logged in the t_log_event table using the pkg_utils.plog procedure. Each log includes:

event_description: Description of the error or action.
event_time: Timestamp of the event.
event_type: Type of the event (e.g., validation, error).

## Future Enhancements
- Add more complex validation rules (e.g., cross-field validation).
- Improve logging details and error handling.
- Optimize the procedures to handle larger datasets.

