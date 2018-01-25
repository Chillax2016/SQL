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

--给表stuinfo加一列入学日期，默认值为sysdate
ALTER TABLE Stuinfo 
ADD in_date date ;

--查询入学年龄在18-20的女生或者未输入性别的学生信息，且年龄小的排在后面
select * from Stuinfo
where (Age between 18 and 20 and Sex like "F") OR (Sex IS NULL)
order by age DESC;

--查询班级名称、学生姓名的信息，相同班级放在一起，按姓名升序排列
select Sid,ClassInfo.cname , Stuinfo.Sname , Stuinfo.Sex , Stuinfo.smoney 
from Stuinfo inner join ClassInfo 
on Stuinfo.cid = ClassInfo.cid
order by ClassInfo.cname, Stuinfo.Sname;

--查询各班名称和人数，但人数必须不少于2，且人数多的放在前面
select classinfo.cname AS 班级名称,count(stuinfo.sid) as 人数
from stuinfo left join classinfo
on stuinfo.cid = classinfo.cid
group by cname
having count(stuinfo.sid) >=2
order by count(stuinfo.sid) desc
;

--查询1980年出生的有哪些学生
select * 
from stuinfo
left join classinfo
on stuinfo.cid = classinfo.cid
where Birthday like "1980%"
;

--show variables like 'sql_safe%';
--set sql_safe_updates=off;

--查询男生和女生人数，没有输入性别的当做男生计算
update stuinfo 
set stuinfo.sex = "M" 
where stuinfo.sex is null
;
select sex as 性别, count(stuinfo.Sex) as 人数
from stuinfo
group by sex
having count(sex) > 0
;

--查询入学日期较早的前3名同学
update stuinfo
set in_date = Birthday + 1
;
select sname, in_date from stuinfo
order by in_date desc
limit 3
;

--查询入学年龄在20以上且学生名称包含a的学生信息
select * 
from stuinfo
where age >= 20 and Sname like "a%"
;

--查询班级平均入学年龄在20及以上的班级名称和平均年龄
select classinfo.cname, avg(stuinfo.age) as 平均年龄 from stuinfo
left join classinfo
on stuinfo.cid = classinfo.cid
group by classinfo.cname
having avg(stuinfo.age) >= 20
;


select distinct Sname from stuinfo
;

select avg(age) from stuinfo;

















