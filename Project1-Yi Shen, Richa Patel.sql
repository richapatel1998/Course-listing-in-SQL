										/*Yi Shen (S)*/
										/*Richa Patel (P)*/
use db363rpatel;
/*Section A*/
create table Person(
Name char(20),
ID char(9) not null,
Address char(30),
DOB date,
primary key(ID));

create table Instructor(
InstructorID char(9) not null,
Rank char(12),
Salary int,
primary key(InstructorID),
foreign key(InstructorID) references Person(ID));

create table Student(
StudentID char(9) not null,
Classification char(10),
GPA double,
MentorID char(9),
CreditHours int,
primary key(StudentID),
foreign key(StudentID) references Person(ID),
foreign key(MentorID) references Instructor(InstructorID));

create table Course(
CourseCode char(6) not null,
CourseName char(50),
PreReq char(6));

create table Offering(
CourseCode char(6) not null,
SectionNo int not null,
InstructorID char(9) not null references Instructor,
primary key(CourseCode, SectionNo));

create table Enrollment(
CourseCode char(6) not null,
SectionNo int not null,
StudentID char(9) not null references Student,
Grade char(4) not null,
primary key(CourseCode, StudentID),
foreign key(CourseCode, SectionNo) references Offering(CourseCode, SectionNo));

/*Section B*/
load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Person.xml' 
	into table Person 
	rows identified by '<Person>';

load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Instructor.xml' 
	into table Instructor 
	rows identified by '<Instructor>';
    
load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Student.xml' 
	into table Student 
	rows identified by '<Student>';
    
load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Course.xml' 
	into table Course 
	rows identified by '<Course>';
    
load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Offering.xml' 
	into table Offering
	rows identified by '<Offering>';
    
load xml local infile 'C:/Users/rpatel/Desktop/Coms363/UniversityXML/Enrollment.xml' 
	into table Enrollment 
	rows identified by '<Enrollment>';
    
/*Section C*/
/*Item13*/
select e.StudentID, e.MentorID
from Student e
where (e.Classification = "Junior" or e.Classification = "Senior")
	and e.GPA > 3.8;
    
/*Item14*/
select distinct e.CourseCode, e.SectionNo
from Enrollment e
where e.StudentID in (select d.StudentID
						from Student d
                        where d.Classification = "Sophomore");
                        
/*Item15*/
select e.Name, d.Salary
from Person e, Instructor d
where e.ID = d.InstructorID
	and d.InstructorID in (select t.MentorID
							from Student t
                            where t.Classification = "Freshman");

/*Item16*/
select sum(all e.Salary)
from Instructor e
where e.InstructorID not in (select d.InstructorID
							from Offering d);
                            
/*Item17*/
select e.Name, e.DOB
from Person e
where Year(e.DOB) = 1976;

/*Item18*/
select e.Name, d.Rank
from Person e, Instructor d
where d.InstructorID not in (select t.InstructorID
							from Offering t)
	and d.InstructorID not in (select p.MentorID
							from Student p);
                            
/*Item19*/
select e.ID, e.Name, e.DOB
from Person e
where e.DOB = (select min(d.DOB) from Person d); 

/*Item20*/
select e.ID, e.DOB, e.Name
from Person e
where e.ID not in (select d.StudentID from Student d)
	and e.ID not in (select t.InstructorID from Instructor t);

/*Item21*/
select e.Name, count(d.StudentID)
from Person e, Student d, Instructor t
where e.ID = t.InstructorID and t.InstructorID = d.MentorID
group by d.MentorID;

/*Item22*/
select e.Classification, count(e.StudentID), avg(e.GPA)
from Student e
group by e.Classification;

/*Item23*/
select e.CourseCode, count(*)
from Enrollment e
group by e.CourseCode
order by count(*)
limit 1;

/*Item24*/
select e.StudentID, t.MentorID
from Enrollment e, Offering d, Student t
where d.CourseCode = e.CourseCode
	and d.SectionNo = e.SectionNo
    and d.InstructorID = t.MentorID
    and e.StudentID = t.StudentID;
                
/*Item25*/
select d.StudentID, e.Name, d.CreditHours
from Person e, Student d
where e.ID = d.StudentID
	and d.Classification = "Freshman"
	and Year(e.DOB) >= 1976;

/*Item26*/
select e.Name, d.InstructorID
from Person e, Instructor d
where e.ID = d.InstructorID
	and d.InstructorID = "201586985";
    
insert into Person(Name, ID, Address, DOB)
values ("Briggs Jason", "480293439", 
	"215 North Hyland Avenue", 
    date '1975-01-15');
    
insert into Student(StudentID, Classification, GPA, MentorID, CreditHours)
values ("480293439", "Junior", 3.48, "201586985", 75);

insert into Enrollment(CourseCode, SectionNo, StudentID, Grade)
values ("CS311", 2, "480293439", "A");

insert into Enrollment(CourseCode, SectionNo, StudentID, Grade)
values ("CS330", 1, "480293439", "A-");

Select *
From Person P
Where P.Name= "Briggs Jason";

Select *
From Student S
Where S.StudentID= "480293439";

Select *
From Enrollment E
Where E.StudentID = "480293439";

/*Item27*/
delete from Enrollment
where StudentID in (select e.StudentID 
					from Student e
                    where e.GPA < 0.5);

delete from Student
where GPA < 0.5;

Select *
From Student S
Where S.GPA < 0.5;

/*Item28*/
select d.Name, e.Salary
from Instructor e, Person d
where e.InstructorID = d.ID
	and d.Name = "Ricky Ponting";

update Instructor
set Salary = Salary * 1.1
where InstructorID = (select e.ID
						from Person e
						where e.Name = "Ricky Ponting")
	and (select count(distinct StudentID)
            from Enrollment d
            inner join Offering s
            on d.CourseCode = s.CourseCode and d.SectionNo = s.SectionNo
			where InstructorID = (select e.ID
						from Person e
						where e.Name = "Ricky Ponting")
			and Grade = "A") >= 5;

select d.Name, e.Salary
from Instructor e, Person d
where e.InstructorID = d.ID
	and d.Name = "Ricky Ponting";

/*Item29*/
insert into Person(Name, ID, Address, DOB)
values ("Trevor Horns", "000957303", 
		"23 Canberra Street", 
        date '1964-11-23');
        
select *
from Person e
where e.Name = "Trevor Horns";

/*Item30*/
delete from Enrollment
where StudentID in (select e.StudentID
					from Student e, Person d
                    where e.StudentID = d.ID
						and d.Name = "Jan Austin");
                        
delete from Student
where StudentID in (select d.ID
					from Person d
                    where d.Name = "Jan Austin");

/*Drop tables*/
drop table Enrollment;
drop table Offering;
drop table Course;
drop table Student;
drop table Instructor;
drop table Person;
