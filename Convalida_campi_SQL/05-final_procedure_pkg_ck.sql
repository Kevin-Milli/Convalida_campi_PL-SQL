create or replace PACKAGE pkg_ck IS
    -- Funzioni
    FUNCTION check_codfisc(cod_fisc CHAR) RETURN NUMBER;
    FUNCTION check_nome_cogn(nomecogn VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_email(p_email VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_dob(p_dob VARCHAR2) RETURN NUMBER;
    FUNCTION is_valid_cell(phone_number VARCHAR2) RETURN NUMBER;  

    -- Procedure
    PROCEDURE p_check;

END;
/

-- body
CREATE OR REPLACE PACKAGE BODY pkg_ck IS
    
    -- Funzione per validare il codice fiscale
    FUNCTION check_codfisc(cod_fisc CHAR) RETURN NUMBER IS
        length_cod NUMBER := 3;   -- lunghezza di codice fiscale consentita.

    BEGIN
        IF LENGTH(cod_fisc) <> length_cod THEN
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Lunghezza del codice fiscale non rispettata.');
            RETURN 0;
        ELSIF REGEXP_LIKE(cod_fisc, '^[A-Za-z]+$') THEN
            RETURN 1;
        ELSE
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Errore in codice fiscale');
            RETURN 0;
        END IF;

    END;

    -- Funzione per validare nome e cognome
    FUNCTION check_nome_cogn(nomecogn VARCHAR2) RETURN NUMBER IS
        min_length NUMBER := 3;
        max_length NUMBER := 20;

    BEGIN
        IF LENGTH(nomecogn) < min_length OR LENGTH(nomecogn) > max_length THEN
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Nome/Cognome troppo Lungo/Corto');
            RETURN 0;
        ELSIF REGEXP_LIKE(nomecogn, '^[A-Za-zÀ-ÿ''-]+$') THEN -- Consente lettere, apostrofi e trattini
            RETURN 1;
        ELSE 
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Nome/Cognome non valido');
            RETURN 0; 
        END IF;
    END;

    -- Funzione per validare la data di nascita
    FUNCTION is_valid_dob(p_dob VARCHAR2) RETURN NUMBER IS
        v_date DATE;
    BEGIN
        -- Verifico che la stringa rispetti uno dei formati ( DD/MM/YYYY OPPURE YYYY/MM/DD ) usando due regex
        IF NOT REGEXP_LIKE(p_dob, '^\d{2}/\d{2}/\d{4}$') OR 	-- formato Europeo
        REGEXP_LIKE(p_dob, '^\d{4}/\d{2}/\d{2}$') THEN  		-- formato Americano
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Bad Format Date');
            RETURN 0; 
        END IF;

        -- Provo a convertire la stringa in data
        BEGIN
            v_date := TO_DATE(p_dob, 'DD/MM/YYYY');
        EXCEPTION
            WHEN VALUE_ERROR THEN
                PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Value Error');
                RETURN 0; -- Se la conversione fallisce, restituisco 0
        END;

        -- Controllo se la data è nel futuro
        IF v_date > SYSDATE THEN
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Future Date');
            RETURN 0; 
        END IF;

        -- Controllo che la data non sia a più di 120 anni nel passato
        IF v_date < ADD_MONTHS(SYSDATE, -120 * 12) THEN
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Old Date');
            RETURN 0;
        END IF;

        RETURN 1; -- Data valida
    END;

    -- Funzione per validare l'email
    FUNCTION is_valid_email(p_email VARCHAR2) RETURN NUMBER IS
    BEGIN
        -- Controllo se l'email è valida
        IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
            RETURN 1; -- Email valida
        ELSE
            PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || 'SQLERRM' || sqlerrm, 'Email non valida');
            RETURN 0; -- Email non valida
        END IF;
    END;

    -- Funzione per validare il numero di telefono
    FUNCTION is_valid_cell(phone_number VARCHAR2) RETURN NUMBER IS
        correct_length NUMBER := 10;
        new_pn NUMBER;
    BEGIN
        -- controllo che la lunghezza del numero sia corretta
        IF LENGTH(phone_number) <> correct_length THEN
            RETURN 0;
        END IF;

        BEGIN
            -- provo a trasformare il dato in numero
            new_pn := TO_NUMBER(phone_number);
        EXCEPTION 
            WHEN INVALID_NUMBER THEN
                PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || ' SQLERRM' || sqlerrm, 'Invalid Number');
                RETURN 0;

            WHEN VALUE_ERROR THEN
                PKG_UTILS.PLOG('SQLCODE: ' || SQLCODE || ' SQLERRM' || sqlerrm, 'Value Error');
                RETURN 0;
        END;

        RETURN 1;
    END;

    -- Procedura principale per controllare i dati
    PROCEDURE p_check IS

        -- cursore 
        CURSOR c_t1 IS
            SELECT codFisc,
                       nome,
                       cogn,
                       mail,
                       dataN,
                       tel
             FROM t1;

        data_t1 c_t1%rowtype;
		
		-- variabili di convalida
        valid_codFisc NUMBER := 0;
        valid_name NUMBER := 0;
        valid_surname NUMBER := 0;
        valid_Mail NUMBER := 0;
        valid_dataN NUMBER := 0;
        valid_tel NUMBER := 0;
        v_summary VARCHAR2(500);

        new_valid_dataN DATE;
        new_valid_tel NUMBER;

    BEGIN

        OPEN c_t1;
        LOOP
            FETCH c_t1 INTO data_t1;
            EXIT WHEN c_t1%notfound;

            -- resetto le variabili a 0 all'inizio di ogni ciclo
            valid_codFisc := 0;
            valid_name := 0;
            valid_surname  := 0;
            valid_Mail  := 0;
            valid_dataN  := 0;
            valid_tel  := 0;
            v_summary := '';

            valid_codFisc := check_codfisc(data_t1.codFisc);
            valid_name := check_nome_cogn(data_t1.nome);
            valid_surname := check_nome_cogn(data_t1.cogn);
            valid_Mail := is_valid_email(data_t1.mail);
            valid_dataN := is_valid_dob(data_t1.dataN);
            valid_tel := is_valid_cell(data_t1.tel);

            IF valid_codFisc = 0 OR valid_name = 0 OR valid_surname = 0 OR valid_Mail = 0 OR valid_dataN = 0 OR valid_tel = 0 THEN
            BEGIN
               -- Aggiungo una descrizione se il codice fiscale non è valido
               IF valid_codFisc = 0 THEN
                   v_summary := v_summary || 'Codice Fiscale non valido. ';
               END IF;

                -- Aggiungo una descrizione se il nome non è valido
                IF valid_name = 0 THEN
                    v_summary := v_summary || 'Nome non valido. ';
                END IF;

                -- Aggiungo una descrizione se il cognome non è valido
                IF valid_surname = 0 THEN
                    v_summary := v_summary || 'Cognome non valido. ';
                END IF;

                -- Aggiungo una descrizione se l'email non è valida
                IF valid_Mail = 0 THEN
                    v_summary := v_summary || 'Email non valida. ';
                END IF;

                -- Aggiungo una descrizione se la data di nascita non è valida
                IF valid_dataN = 0 THEN
                    v_summary := v_summary || 'Data di nascita non valida. ';
                END IF;

                -- Aggiungo una descrizione se il numero di telefono non è valido
                IF valid_tel = 0 THEN
                    v_summary := v_summary || 'Numero di telefono non valido. ';
                END IF;

                -- Inserisco i dati nella tabella t1Bad insieme al summary degli errori
                INSERT INTO t1Bad (codFisc, nome, cogn, mail, dataN, tel, asummary, dins)
                VALUES (data_t1.codFisc, data_t1.nome, data_t1.cogn, data_t1.mail, data_t1.dataN, data_t1.tel, v_summary, sysdate);
                COMMIT;
                -- Rimuovo l'elemento da t1
                DELETE FROM t1 WHERE codFisc = data_t1.codFisc;

            END;
            ELSE
                -- converto i valori
                new_valid_dataN := TO_DATE(data_t1.dataN, 'dd/mm/yyyy');
                new_valid_tel := to_number(data_t1.tel);

                -- inserisco nei dati buoni
                INSERT INTO t1ok (codFisc, nome, cogn, mail, dataN, tel, dins)
                VALUES (data_t1.codFisc, data_t1.nome, data_t1.cogn, data_t1.mail, new_valid_dataN, new_valid_tel, sysdate);
                COMMIT;
        END IF;
        END LOOP;
        CLOSE c_t1;

    EXCEPTION
        WHEN OTHERS THEN
            pkg_utils.plog('SQLCODE: ' || SQLCODE || ' SQLERRM: ' || sqlerrm, 'OTHERS EXC');
            ROLLBACK;
            RAISE;

    END;

END pkg_ck;