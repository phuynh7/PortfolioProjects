--Project Milestone #3 Use Stored Procedure,Trigger, and View. 

-- Stored Procedure
/*We created a stored procedure that would return the bin number, capacity of each current bin, and what warehouse it’s currently in. In order to do this, 
we joined the bin and batch tables in order to subtract the current batch size in each bin and the capacity of each bin. We then created a cursor to loop 
through the rows and do the calculations depending on the if statements within the loop. We then print out all the values we selected and create a report. 
This application of the stored procedure is useful because it will allow the warehouses to see which bins can fit more items, and which have full capacity. */

CREATE OR REPLACE PROCEDURE Sp_Avalible_Bins IS
SP_BIN_NUM BIN.BIN_NUM%TYPE;
SP_WAREHOUSE_ID WAREHOUSE.WAREHOUSE_ID%TYPE;
SP_REMAINING_CAPA NUMBER;
SP_CAPACITY BIN.BIN_CAPACITY%TYPE;

CURSOR CAPACITY_CURSOR IS

    select n.bin_num, N.WAREHOUSE_ID, (bat_size - bin_capacity), N.BIN_CAPACITY 
    from bin n LEFT OUTER JOIN batch b
    on n.bin_num = b.bin_num;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('CAPACITY OF CURRENT BINS  ');
    DBMS_OUTPUT.PUT_LINE('===========================');
    DBMS_OUTPUT.PUT_LINE('BIN#, WH#,  CAPACITY  ');
    DBMS_OUTPUT.PUT_LINE('===========================');
    
    OPEN CAPACITY_CURSOR;
LOOP
   FETCH CAPACITY_CURSOR INTO SP_BIN_NUM, SP_WAREHOUSE_ID, SP_REMAINING_CAPA,SP_CAPACITY ;
   EXIT WHEN CAPACITY_CURSOR%NOTFOUND;
        IF SP_REMAINING_CAPA IS NULL THEN
            DBMS_OUTPUT.PUT_LINE(SP_BIN_NUM ||', ' || SP_WAREHOUSE_ID || ', ' || SP_CAPACITY );
        ELSIF SP_REMAINING_CAPA <= 0 THEN
            DBMS_OUTPUT.PUT_LINE(SP_BIN_NUM ||', ' || SP_WAREHOUSE_ID || ', ' || 'CAPACITY FULL' );
        ELSE        
            DBMS_OUTPUT.PUT_LINE(SP_BIN_NUM ||', ' || SP_WAREHOUSE_ID || ', ' || SP_REMAINING_CAPA );
        END IF;
END LOOP;
    DBMS_OUTPUT.PUT_LINE('===========================');
    DBMS_OUTPUT.PUT_LINE('      END OF REPORT        ');
    DBMS_OUTPUT.PUT_LINE('===========================');
   
    CLOSE CAPACITY_CURSOR;
END;

BEGIN
Sp_Avalible_Bins;
END;

--Trigger
/*We’ve created a trigger that will update the old_backorder table once there is a change in the current_backorder table. 
If a current_backorder is complete, we are moving it to the old_backorder table. 
We would call this to see if a current_backorder has been completed or not. 
If there is an update on the ‘sysdate’ where cback_id =100, that will tell us that the current_backorder has been completed and we need to delete that row and update the old_bakcorder table. */ 

alter table current_backorder
add fulfilled_date date;
--------------------------------------------------------------------------
create or replace trigger update_oldbackorder
after update on  current_backorder
begin

insert into old_backorder(OBACK_ID,PART_NUM,BO_DATE,FULFILLED_DATE,EMP_NUM, qty_order)
select cback_id,part_num,bo_date,fulfilled_date,emp_num, original_qty
from current_backorder
where fulfilled_date is not null;

delete from current_backorder
where fulfilled_date is not null;

end;
--------------------------------------------------------------------------
update current_backorder
set fulfilled_date = sysdate
where cback_id = 1000
--------------------------------------------------------------------------

select * from old_backorder;
select * from current_backorder;


-- View

/*This view was created to list all the part_num in the current_backorder, making sure the original_qty is 40. 
We would use this view because we need to look at the supply we have and if we’re running low or have too much when ordering more parts. 
For these parts specifically, we usually need more than 40, so we know that we are not running low.
Though we need to keep an eye out on 1001b because that might be the next part we need to replenish.*/

Create view currentBackorderQTY as
    select CBACK_ID, part_num, ORIGINAL_QTY
    from CURRENT_BACKORDER 
    where ORIGINAL_QTY > 40
    order by ORIGINAL_QTY desc;
    
    select * from currentBackorderQTY
 


