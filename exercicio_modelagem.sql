drop table if exists cartao;
create table cartao(
	codigo_compra integer primary key,
	codigo_portador integer,
	documento_favorecido varchar(20),
	nome_favorecido varchar(100),
	transacao varchar(100),
	valor decimal(20,2),
	"data" date,
	constraint fk_cartao_portador foreign key(codigo_portador)
	references portador(codigo_portador)
);


drop sequence cartao_sequence;
create sequence cartao_sequence start with 1;


drop table if exists portador;
create table portador(
	codigo_portador integer primary key,
	nome_portador varchar(200),
	cpf_portador varchar(20),
	codigo_orgao integer,
	codigo_unidade_gestora integer,
	constraint fk_portador_orgao 
	foreign key(codigo_orgao)
	references orgao(codigo_orgao),
	constraint fk_portador_UNIDADE_GESTORA
	foreign key(codigo_unidade_gestora)
	references UNIDADE_GESTORA(codigo_unidade_gestora)
);

drop sequence portador_sequence;
create sequence portador_sequence start with 1;

drop table if exists orgao;
create table orgao(
	codigo_orgao integer primary key,
	nome_orgao varchar(100),
	codigo_orgao_superior integer,
	constraint fk_orgao_ORGAO_SUPERIOR
	foreign key(codigo_orgao_superior)
	references ORGAO_SUPERIOR(codigo_orgao_superior)
);

drop sequence orgao_sequence;
create sequence orgao_sequence start with 1;

drop table if exists ORGAO_SUPERIOR;
create table ORGAO_SUPERIOR(
	codigo_orgao_superior integer primary key, 
	nome_orgao_superior varchar(100)
);

drop sequence ORGAO_SUPERIOR_sequence;
create sequence ORGAO_SUPERIOR_sequence start with 1;

drop table if exists UNIDADE_GESTORA;
create table UNIDADE_GESTORA(
	codigo_unidade_gestora integer primary key, 
	nome_unidade_gestora  varchar(100) 
);

drop sequence UNIDADE_GESTORA_sequence;
create sequence UNIDADE_GESTORA_sequence start with 1;

select * from final_cpgf;

--INSERT UNIDADE_GESTORA
insert into UNIDADE_GESTORA(
	codigo_unidade_gestora, 
	nome_unidade_gestora
)
select
	distinct on(fc.codigo_unidade_gestora)
	fc.codigo_unidade_gestora,
	fc.nome_unidade_gestora
from final_cpgf fc;

--INSERT ORGAO_SUPERIOR
insert into ORGAO_SUPERIOR(
	codigo_orgao_superior, 
	nome_orgao_superior
)
select
	distinct on(fc.codigo_orgao_superior)
	fc.codigo_orgao_superior,
	fc.nome_orgao_superior
from final_cpgf fc

--INSERT ORGAO
insert into ORGAO(
	codigo_orgao,
	nome_orgao,
	codigo_orgao_superior
)
select
	distinct on(fc.codigo_orgao)
	fc.codigo_orgao,
	fc.nome_orgao,
	codigo_orgao_superior
from final_cpgf fc
order by fc.codigo_orgao, fc."data" desc;


--INSERT PORTADOR
insert into portador(
	codigo_portador,
	nome_portador,
	cpf_portador,
	codigo_orgao,
	codigo_unidade_gestora
)
select
	distinct on(fc.nome_portador)
	nextval('portador_sequence'),
	fc.nome_portador,
	fc.cpf_portador,
	fc.codigo_orgao,
	fc.codigo_unidade_gestora
from final_cpgf fc
where fc.nome_portador not ilike 'sigiloso'
order by fc.nome_portador, fc."data";

truncate table cartao;
truncate table portador cascade;

--INSERT CARTAO
insert into cartao(
	codigo_compra,
	codigo_portador,
	documento_favorecido,
	nome_favorecido,
	transacao,
	valor,
	"data"
)
select
	nextval('cartao_sequence'),
	p.codigo_portador,
	fc.documento_favorecido,
	fc.nome_favorecido,
	fc.transacao,
	fc.valor,
	fc."data"
from portador p
inner join final_cpgf fc 
on p.nome_portador = fc.nome_portador;

truncate table portador cascade;

select * from final_servidores_siape_cadastro;
select * from portador pt;
select * from cartao;
select count(*) from final_cpgf
where nome_portador ilike 'sigiloso';

select  count(*) from final_cpgf fc ;
select * from UNIDADE_GESTORA;
select count(*) from ORGAO_SUPERIOR;
select count(*) from ORGAO;
select * from final_servidores_siape_cadastro fssc ;
select avg(remuneracao_apos_deducoes_obrigatorias_rs + remuneracao_apos_deducoes_obrigatorias_us*5.4) from final_servidores_siape_remuneracao fssr ;

select count(distinct(nome_portador))from final_cpgf;
select * from final_cpgf fc ;

