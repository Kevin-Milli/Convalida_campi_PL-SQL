create or replace package pkg_utils is
    procedure plog(v_event_description varchar2, v_event_type varchar2);
end;
/

create or replace package body pkg_utils is

    procedure plog(v_event_description varchar2, v_event_type varchar2) is
        log_time timestamp := sysdate;
    begin 
        insert into t_log_event(
            event_description,
            event_time,
            event_type
        )
        values(
            v_event_description,
            log_time,
            v_event_type
        );
    end;

end;
/