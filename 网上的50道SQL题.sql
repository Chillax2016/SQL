drop table Student;
drop table Course;
drop table Teacher;
drop table SC;


-- 测试表格http://blog.csdn.net/flycat296/article/details/63681089
-- 
-- 1.学生表
-- Student(S#,Sname,Sage,Ssex) 
-- S# 学生编号,Sname 学生姓名,Sage 出生年月,Ssex 学生性别

-- 
-- 2.课程表 
-- Course(C#,Cname,T#) 
-- C# --课程编号,Cname 课程名称,T# 教师编号
-- 
-- 3.教师表 
-- Teacher(T#,Tname)
-- T# 教师编号,Tname 教师姓名
-- 
-- 4.成绩表 
-- SC(S#,C#,score)
-- S # 学生编号,C# 课程编号,score 分数
 
-- 学生表 Student 
create table Student(S varchar(10),Sname nvarchar(10),Sage datetime,Ssex nvarchar(10));
insert into Student values('01' , N'赵雷' , '1990-01-01' , N'男');
insert into Student values('02' , N'钱电' , '1990-12-21' , N'男');
insert into Student values('03' , N'孙风' , '1990-05-20' , N'男');
insert into Student values('04' , N'李云' , '1990-08-06' , N'男');
insert into Student values('05' , N'周梅' , '1991-12-01' , N'女');
insert into Student values('06' , N'吴兰' , '1992-03-01' , N'女');
insert into Student values('07' , N'郑竹' , '1989-07-01' , N'女');
insert into Student values('08' , N'王菊' , '1990-01-20' , N'女');

-- 科目表 Course
create table Course(C varchar(10),Cname nvarchar(10),T varchar(10));
insert into Course values('01' , N'语文' , '02');
insert into Course values('02' , N'数学' , '01');
insert into Course values('03' , N'英语' , '03');


-- 教师表 Teacher
create table Teacher(T varchar(10),Tname nvarchar(10));
insert into Teacher values('01' , N'张三');
insert into Teacher values('02' , N'李四');
insert into Teacher values('03' , N'王五');


-- 成绩表 SC 
create table SC(S varchar(10),C varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);


-- 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
-- 
select c1.*,c2.c,c2.score from (select * from sc where c='01') as c1
left join (select * from sc where c = "02")as c2
on c1.s =c2.s
where c1.score >c2.score;

-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
-- 
select c1.*,c2.c,c2.score from (select * from sc where c='01') as c1
left join (select * from sc where c = "02")as c2
on c1.s =c2.s
where c2.c is not null;

-- 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
-- 
select c1.*,c2.c,c2.score from (select * from sc where c='01') as c1
left join (select * from sc where c = "02")as c2
on c1.s =c2.s
where c2.c is null;

############################################################
-- 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况

select c1.*,c2.c,c2.score from (select * from sc where c='01') as c1
left join (select * from sc where c = "02")as c2
on c1.s =c2.s
where c1.c is null;

############################################################

-- 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
-- 
select Student.*,convert(avg(sc.score),decimal(10,2))  as avg_score 
from sc
left join Student on student.s = sc.s
group by student.Sname
having avg(sc.score) >= 60;

-- 3. 查询在 SC 表存在成绩的学生信息
-- 
select distinct student.S, sname,sage,ssex from student
left join sc on sc.s = student.s
where sc.score is not null;

-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
-- 
select student.S,student.Sname,count_class,sum_score from 
(select sc.s,count(sc.c) as count_class,sum(sc.score) as sum_score from sc group by sc.s) as sc_4
right join student on sc_4.S = student.S;

-- 4.1 查有成绩的学生信息
-- 
select student.S,student.Sname,count_class,sum_score from 
(select sc.s,count(sc.c) as count_class,sum(sc.score) as sum_score from sc group by sc.s) as sc_4
right join student on sc_4.S = student.S
where count_class is not null;

-- 5. 查询「李」姓老师的数量 
-- 
select count(teacher.Tname)as “李”姓老师的数量 from teacher
where tname like "李%";

-- 6. 查询学过「张三」老师授课的同学的信息 
-- 
select *  from student
INNER  join sc on sc.s = student.s
INNER  join course on course.c = sc.c
INNER  join teacher on course.t = teacher.T
where teacher.Tname = "张三";

-- 7. 查询没有学全所有课程的同学的信息 
-- 
select student.S,student.Sname from 
(select sc.s,sc.c,count(sc.c) as count_class from sc group by sc.s) as sc_4
right join student on sc_4.S = student.S
where count_class < 3;

-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息 
-- 
select distinct student.S,Sname,Sage,Ssex from student
right join sc on sc.s = student.S
where c in(select sc.c from sc where s = '01') and sc.S<> '01'
group by S
having count(sc.c)>= 1;

-- 9. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息 
-- 
select distinct student.S,Sname,Sage,Ssex from student
right join sc on sc.s = student.S
where c in(select sc.c from sc where s = '01') and sc.S<> '01'
group by S
having count(sc.c)>= 3;

-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名 
-- 
-- 这道题差点就搞错了，张三老师是一号老师二号课程，所以课程和老师的代码都要看清楚 
select * from student
where s not in (select sc.s from sc 
where c in (select course.c from course 
where t in (select teacher.t from teacher where tname = '张三')));

-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
-- 
select student.S,student.Sname,avg(score) from student
right join sc on sc.s = student.S
where (sc.score < 60 )
group by sc.S
having count(sc.c) >= 2;

-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
-- 
select * from student
right join sc on sc.s = student.S
where (sc.score < 60 ) and sc.C = '01'
order by score desc;

-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
-- 
-- 此处巩固case when then end 的用法，Case函数只返回第一个符合条件的值，剩下的Case部分将会被自动忽略。但是不明白这里为什么要加max?
select  student.S,student.Sname,
max(case sc.c when '01'  then score else 0 end) as c01,
max(case sc.c when '02'  then score else 0 end) as c02,
max(case sc.c when '03'  then score else 0 end) as c03,
convert(avg(score) ,decimal(10,2))as 平均成绩 from student
right join sc on sc.S = student.S
group by S
order by 平均成绩 desc;

-- 14. 查询各科成绩最高分、最低分和平均分：
-- 
--     以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
--     及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
--     要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
-- 
-- 15. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
-- 
-- 15.1 按各科成绩进行排序，并显示排名， Score 重复时合并名次
-- 
-- 16.  查询学生的总成绩，并进行排名，总分重复时保留名次空缺
-- 
-- 16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
-- 
-- 17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
-- 
-- 18. 查询各科成绩前三名的记录
-- 
-- 19. 查询每门课程被选修的学生数 
-- 
-- 20. 查询出只选修两门课程的学生学号和姓名 
-- 
-- 21. 查询男生、女生人数
-- 
-- 22. 查询名字中含有「风」字的学生信息
-- 
-- 23. 查询同名同性学生名单，并统计同名人数
-- 
-- 24. 查询 1990 年出生的学生名单
-- 
-- 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
-- 
-- 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩 
-- 
-- 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数 
-- 
-- 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
-- 
-- 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
-- 
-- 30. 查询不及格的课程
-- 
-- 31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
-- 
-- 32. 求每门课程的学生人数 
-- 
-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
-- 
-- 36. 查询每门功成绩最好的前两名
-- 
-- 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
-- 
-- 38. 检索至少选修两门课程的学生学号 
-- 
-- 39. 查询选修了全部课程的学生信息
-- 
-- 40. 查询各学生的年龄，只按年份来算 
-- 
-- 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
-- 
-- 42. 查询本周过生日的学生
-- 
-- 43. 查询下周过生日的学生
-- 
-- 44. 查询本月过生日的学生
-- 
-- 45. 查询下月过生日的学生

