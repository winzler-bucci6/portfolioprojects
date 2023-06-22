SELECT count(*)
FROM dataset1;

select *
from dataset1
where state in ('Jharkhand' ,'Bihar');

select avg(Growth) as Average_Growth
from dataset1;

select State,avg(Growth) as Avg_Growth
from dataset1
group by State
order by State ASC;

select avg(Sex_Ratio)
from dataset1;

select State,round(avg(Sex_Ratio),0) as Avg_Sex_Ratio
from dataset1
group by State
order by State Asc;

select State,round(avg(Sex_Ratio),0) as Avg_Sex_Ratio
from dataset1
group by State
order by Avg_Sex_Ratio  Desc;

select state,round(avg(Literacy),0) as Avg_Literacy
from dataset1
group by state
having round(avg(Literacy),0)>90
order by Avg_Literacy desc;

select top 3 state,avg(growth)*100 as Avg_growth
from dataset1
group by state
order by Avg_growth asc;

select top 3 state,round(avg(Sex_Ratio),0) as Avg_Sex_Ratio
from dataset1
group by state
order by Avg_Sex_Ratio desc;


drop table if exists #topstates;
create table #topstates(
State varchar(255),
topstates float);

insert into #topstates
select state,round(avg(Literacy),0) as Avg_Literacy
from dataset1
group by State
order by Avg_Literacy desc;

select top 3*
from #topstates
order by #topstates.topstates desc;

drop table if exists #bottomstates;
create table #bottomstates(
state varchar(255),
bottomstate float);

insert into #bottomstates
select state,round(avg(literacy),0) as Avg_Literacy
from dataset1
group by State
order by Avg_Literacy ASC;

Select top 3*
from #bottomstates
order by #bottomstates.bottomstate;

select *
from(select top 3 *
from #topstates
order by topstates desc) a
union
select *
from(select top 3 *
from #bottomstates
order by bottomstate asc)b;

select distinct State
from dataset1
where State like 'A%';

select distinct State
from dataset1
where State like 'A%' or State like 'B%';

select distinct State
from dataset1
where State like 'A%' or State like '%d';

select distinct State
from dataset1
where State like 'A%' and State like '%m';

select a.District,a.State,a.Sex_Ratio,b.Population
from dataset1 a
inner join dataset2 b on a.District=b.District;

--females/males=sex_ratio
--females+males=population
--females=population-males
--(population-males)=sex_ratio*males
--population=males(sex_ratio+1)
--males=population/(sex_ratio+1)
--females=population-population/(sex_ratio+1)
--population(1-1/(sex_ratio+1))
--(population*(sex_ratio))/(sex_ratio+1)

select *
from dataset1;

select a.District,a.State,a.Sex_Ratio/1000 AS Sex_Ratio,b.Population
from dataset1 a
inner join dataset2 b on a.District=b.District;

select c.District,c.State,round(c.Population/(c.Sex_Ratio+1),0) as Males,round((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) as Females
from(select a.District,a.State,a.Sex_Ratio/1000 AS Sex_Ratio,b.Population
from dataset1 a
inner join dataset2 b on a.District=b.District)c;

Select d.State,sum(d.Males) Total_Males,sum(d.Females) Total_Females
from
(select c.District,c.State,round(c.Population/(c.Sex_Ratio+1),0) as Males,round((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) as Females
from(select a.District,a.State,a.Sex_Ratio/1000 AS Sex_Ratio,b.Population
from dataset1 a
inner join dataset2 b on a.District=b.District)c)d
group by State;

select a.District,a.State,a.Literacy AS Literacy_Rate,b.Population
from dataset1 a
inner join dataset2 b on a.District=b.District




