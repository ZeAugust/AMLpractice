select * from status_analise sa ;
select * from dossie d ;

create table tmp_dossie_qa (
	id_dossie numeric(20,0) primary key
);

-- query básica para a atividade
--retirada de uma amostra contendo 10% da quantidade de registros total para o periodo selecionado
insert into tmp_dossie_qa (id_dossie)
select 
	id_dossie
from 
	dossie d 
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from tmp_dossie_qa)
	and id_status_analise in (3, 5, 7, 8, 25)
	and random() <= 0.1;
	
truncate table tmp_dossie_qa ;	
select * from tmp_dossie_qa ;

create table final_dossie_qa(
	id_dossie integer primary key
);


--2. Visão Impacto: Status 5 (Comunicado ao coaf) tenha 10% de chance de ser coletado.
--inserção de uma quantidade de linhas proporcional a 10% das linhas da amostra anterior,
--atendendo o critério especificado

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and id_status_analise = 5
order by random()
limit(
	select 
		(count(*) * 0.1)
	from 
		tmp_dossie_qa
);
	
--3. Visão de Risco: Score > 100 tenha 10% de chance de ser coletado.

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and score > 100
order by random()
limit(
	select 
		(count(*) * 0.1)
	from 
		tmp_dossie_qa
);

--4. Calda: Do restante 5%.
--inserção na tabela final de uma quantidade de linhas proporcional a 5% das linhas da amostra anterior,
--para cada um dos critérios não abarcados pelas condições anteriores

-- status = 3

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and id_status_analise = 3
order by random()
limit(
	select 
		(count(*) * 0.05)
	from 
		tmp_dossie_qa
);

-- status = 7

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and id_status_analise = 7
order by random()
limit(
	select 
		(count(*) * 0.05)
	from 
		tmp_dossie_qa
);

-- status = 8

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and id_status_analise = 8
order by random()
limit(
	select 
		(count(*) * 0.05)
	from 
		tmp_dossie_qa
);

-- status = 25

insert into final_dossie_qa
select 
	id_dossie
from 
	dossie d
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from final_dossie_qa)
	and id_status_analise = 25
order by random()
limit(
	select 
		(count(*) * 0.05)
	from 
		tmp_dossie_qa
);

--preenchendo o restante da tabela final para que contenha a quantidade referente
--aos 10% dos registros totais no periodo especificado.

insert into final_dossie_qa (id_dossie)
select 
	id_dossie 
from 
	tmp_dossie_qa  
where 	
	id_dossie not in (select id_dossie from final_dossie_qa)
limit(
	(select 
		(count(*))
	from 
		tmp_dossie_qa)
	-
	(select 
		(count(*))
	from 
		final_dossie_qa )
);

-- Visão cobertura
select distinct on(d.cod_user, d.score) d.cod_user, fd.id_dossie, d.score
from 
	final_dossie_qa fd
inner join 
	dossie d
on
	d.id_dossie = fd.id_dossie ;

--Alerta pra score < 50

select fd.id_dossie, d.cod_user, d.score
from 
	final_dossie_qa fd 
inner join 
	dossie d
on 
	fd.id_dossie = d.id_dossie
where
	score <= 50
order by id_dossie;

--Alerta para score entre 51 e 100

select fd.id_dossie, d.cod_user, d.score
from 
	final_dossie_qa fd 
inner join 
	dossie d
on 
	fd.id_dossie = d.id_dossie
where
	score between 51 and 100;

--Alerta pra score maior que 100

select fd.id_dossie, d.cod_user, d.score
from 
	final_dossie_qa fd 
inner join 
	dossie d
on 
	fd.id_dossie = d.id_dossie
where
	score > 100;
