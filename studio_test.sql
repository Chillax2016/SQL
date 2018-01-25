drop table Stuinfo;

CREATE table Stuinfo 
(
Sid INT NOT null PRIMARY KEY,
Sname char(9),
Sex char(2) check(sex='M' or sex='F'),
Birthday date,
Age int(20) check(age>=3 or age<=150), 
smoney int(255),
cid char(2)
);


drop table ClassInfo;
create table ClassInfo
(
cid char(4) not null primary key,
cname char(255)
);

INSERT INTO Stuinfo
VALUES('1','abc','F','2000-01-01','5','500','a1'),
	  ('2','def',null,'2000-01-01','4','500','a2'),
      ('3','ghi','M','2000-01-01','5','500','a1'),
      ('4','JKL','F','2000-01-01','6','500','a2'),
      ('5','MNO','F','1980-01-01',null,'500','a1');
              
INSERT INTO ClassInfo
VALUES('a1','学前一班'),('a2','学前二班');

select * from Stuinfo;
select * from ClassInfo;

ALTER TABLE Stuinfo 
ADD in_date date ;


select * from Stuinfo
where (Age between 18 and 20 and Sex like "F") OR (Sex IS NULL)
order by age DESC;


select Sid,ClassInfo.cname , Stuinfo.Sname , Stuinfo.Sex , Stuinfo.smoney 
from Stuinfo inner join ClassInfo 
on Stuinfo.cid = ClassInfo.cid
order by ClassInfo.cname, Stuinfo.Sname;

select classinfo.cname AS 班级名称,count(stuinfo.sid) as 人数
from stuinfo left join classinfo
on stuinfo.cid = classinfo.cid
group by cname
having count(stuinfo.sid) >=2
order by count(stuinfo.sid) desc
;

select * 
from stuinfo
left join classinfo
on stuinfo.cid = classinfo.cid
where Birthday like "1980%"
;

#show variables like 'sql_safe%';
#set sql_safe_updates=off;

update stuinfo 
set stuinfo.sex = "M" 
where stuinfo.sex is null
;
select sex as 性别, count(stuinfo.Sex) as 人数
from stuinfo
group by sex
having count(sex) > 0
;

update stuinfo
set in_date = Birthday + 1
;


select sname, in_date from stuinfo
order by in_date desc
limit 3
;


select * 
from stuinfo
where age >= 20 and Sname like "a%"
;

########################################
select classinfo.cname, avg(stuinfo.age) as 平均年龄 from stuinfo
left join classinfo
on stuinfo.cid = classinfo.cid
group by classinfo.cname
;

########################################

select distinct Sname from stuinfo
;

select avg(age) from stuinfo;

















