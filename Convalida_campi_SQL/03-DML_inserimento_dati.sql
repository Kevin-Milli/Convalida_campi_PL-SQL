/*
    DML - INSERIMENTO DATI
*/

/* totale elementi: 29 */

TRUNCATE TABLE t1;

/* Dati corretti */
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('ABC', 'Francesco', 'Verdi', 'verdi@example.com', TO_DATE('20/05/1985', 'DD/MM/YYYY'), 1234567890);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('DEF', 'Anna', 'Neri', 'neri@example.com', TO_DATE('15/08/1990', 'DD/MM/YYYY'), 0987654321);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('GHI', 'Marco', 'Rossi', 'rossi@example.com', TO_DATE('10/01/1988', 'DD/MM/YYYY'), 3456789012);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('JKL', 'Elena', 'Bianchi', 'bianchi@example.com', TO_DATE('25/03/1995', 'DD/MM/YYYY'), 4567890123);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('MNO', 'Giuseppe', 'Gallo', 'gallo@example.com', TO_DATE('30/06/1992', 'DD/MM/YYYY'), 5678901234);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('PQR', 'Sofia', 'Conti', 'conti@example.com', TO_DATE('01/12/1987', 'DD/MM/YYYY'), 6789012345);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('STU', 'Lorenzo', 'Ferri', 'ferri@example.com', TO_DATE('12/07/1993', 'DD/MM/YYYY'), 7890123456);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('VWX', 'Giulia', 'Romano', 'romano@example.com', TO_DATE('14/09/1994', 'DD/MM/YYYY'), 8901234567);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('YZA', 'Davide', 'Greco', 'greco@example.com', TO_DATE('20/11/1989', 'DD/MM/YYYY'), 9012345678);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('BCD', 'Martina', 'Rinaldi', 'rinaldi@example.com', TO_DATE('17/02/1996', 'DD/MM/YYYY'), 2345678901);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('EFG', 'Chiara', 'Ruggeri', 'ruggeri@example.com', TO_DATE('24/04/1984', 'DD/MM/YYYY'), 3456789012);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('HIJ', 'Alessandro', 'Fabbri', 'fabbri@example.com', TO_DATE('05/10/1991', 'DD/MM/YYYY'), 4567890123);
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('KLM', 'Federico', 'Esposito', 'esposito@example.com', TO_DATE('30/08/1990', 'DD/MM/YYYY'), 5678901234);

/* Dati errati */
-- 1. codFisc troppo corto
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('AB', 'Simona', 'Verdi', 'verdi@example.com', TO_DATE('20/05/1985', 'DD/MM/YYYY'), 1234567890);

-- 2. nome troppo lungo 
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('DRT', 'Daenerys madre di draghi prima del suo nome', 'Targaryan', 'targaryan@example.com', TO_DATE('15/08/1990', 'DD/MM/YYYY'), 0987654321);

-- 3. dataN non valida (anno incorretto per eccesso: 2034)
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('GGI', 'Marco', 'Rossi', 'rossi@example.com', TO_DATE('28/02/2034', 'DD/MM/YYYY'), 3456789012);

-- 4. tel troppo corto  (9 caratteri)
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('JKL', 'Elena', 'Bianchi', 'bianchi@example.com', TO_DATE('25/03/1995', 'DD/MM/YYYY'), 123456789);

-- 5. codFisc con caratteri non validi (solo "numeri" al posto di: lettere / mix)
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('123', 'Laura', 'Neri', 'neri@example.com', TO_DATE('15/01/1990', 'DD/MM/YYYY'), 2345678901);

-- 6. nome troppo corto
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('XYZ', 'Bu', 'Rossi', 'rossi@example.com', TO_DATE('20/02/1988', 'DD/MM/YYYY'), 3456789012);

-- 7. cogn troppo corto
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('ABC', 'Marco', 'Ru', 'rossi@example.com', TO_DATE('10/03/1992', 'DD/MM/YYYY'), 4567890123);

-- 8. dataN in un formato errato (fmt: americano)
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('LMN', 'Giulia', 'Conti', 'conti@example.com', TO_DATE('2000/01/01', 'YYYY/MM/DD'), 5678901234);

-- 9. dataN non valida (anno incorretto: 1451)
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('CCP', 'Cristoforo', 'Colombo', 'colombo@example.com', TO_DATE('31/10/1451', 'DD/MM/YYYY'), 3456789012);

/* Dati errati con email non valide */
-- 10. email senza '@'
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('XYZ', 'Luca', 'Luca', 'lucaexample.com', TO_DATE('01/01/1990', 'DD/MM/YYYY'), 1234567890);

-- 11. email con caratteri non validi
INSERT INTO t1 (codFisc, nome, cogn, mail, dataN, tel) VALUES ('ABC', 'Sara', 'Sara', 'sara@@example.com', TO_DATE('02/02/1992', 'DD/MM/YYYY'), 4567890123);
