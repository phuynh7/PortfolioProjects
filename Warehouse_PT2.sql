-- Project Milestone #2
-- Query 10 Questions:
-- #1: List all employees that work under a particular manager, include the employee first name and last name displayed as (Lastname, firstname) sorted by employee last name.
-- #2: List all the old_backorders(part number, back order date, and fulfilled date) for a given date range.
-- #3: List the phones and employee_no for all the managers
-- #4: List all the parts that are assemblies (have subparts). For each part, display the total number of subparts it has.
-- #5: Write a query that will tell you the total capacity in each warehouse. For each warehouse list the # of bins and the total capcity for those bins.
-- #6: For each manager,list all current and old backorders done by the manager. For each backorder you have to list the part_no, backorder date, and fulfilled date.
-- #7: For each warehouse bin, give the remaining capacity of the bin. Call the remaining capacity remaining_capacity.
-- #8: Answer the question, how many items are currently on backorder?
-- #9: Provide a list of batches for each warehouse- list the warehouse name, batch number, size, and date in.
-- #10: List the toatl number of batches for a particular part number.

-- #1
select EMP_LNAME as Lastname, EMP_FNAME as Firstname
from employee 
where supervisor = 104586
order by EMP_LNAME

-- #2
Select PART_NUM as Part_Number,BO_DATE as Backorder_date, FULFILLED_DATE 
from Old_backorder
where BO_DATE BETWEEN TO_DATE ('01/01/2022','DD/MM/YYYY')
AND TO_DATE ('10/01/2022','DD/MM/YYYY')

-- #3 
Select PHONE_NUM, e.EMP_NUM
from emp_phone e, employee r
where e.emp_Num = r.Supervisor

--#4
select p.assembly_id, count(p.part_num) as total_subparts
from assembly a
join part p
on a.assembly_id = p.assembly_id
group by a.assembly_id

--#5
select b.warehouse_id, count(bin_num) as "Number of Bins",
sum(bin_capacity) as "Capacity"
from bin b
join warehouse w on b.warehouse_id = w.warehouse_id
group by b.warehouse_id;

--#6
select e.emp_num, oback_id, o.part_num,
o.bo_date, o.fulfilled_date as "OBACK_FULFILLED_DATE", cback_id, c.part_num, c.bo_date
from current_backorder c join
old_backorder o on c.emp_num = o.emp_num
join employee e on e.emp_num = o.emp_num
order by o.bo_date, c.bo_date


--#7
select n.bin_num, (bat_size - bin_capacity) as "Remaining Capacity" 
from bin n inner join batch b
on n.bin_num = b.bin_num

--#8
select count(*) as "# of items on Backorder" 
from part p inner join item i
on p.part_num = i.part_num
where i.part_num in (select part_num from current_backorder)

--#9
SELECT batch_num, warehouse_id, bat_size, date_in
FROM batch

--#10
SELECT sum(batch_num), part_num
FROM batch
GROUP BY part_num

