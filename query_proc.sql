select * from proc_cliente;

insert into proc_cliente(
	aposentado,
	ativo,
	cep,
	cnae,
	codigo,
	codigo_localizador,
	documento,
	dt_atualizacao,
	dt_entrada,
	empresa,
	id_proc_cliente,
	id_sistema,
	nome,
	outros,
	patrimonio,
	profissao,
	renda,
	score,
	tipo_cadastro,
	validado
)
select 
	false,
	true,
	'',
	'',
	concat(fcssc.prefixo,'_', fcssc.id_concat) as codigo,
	'',
	fcssc.cpf,
	min(fcssc."data"),
	min(fcssc."data"),
	fcssc.nome_unidade_gestora,
	nextval('proc_cliente_sequence'),
	fcssc.id_sistema_cliente,
	fcssc.nome,
	'{}',
	0,
	'',
	fcssc.renda_total,
	0,
	1,
	true	
from
	final_cpgf_serv_sis_cliente fcssc
group by 
	fcssc.prefixo,
	fcssc.cpf,
	fcssc.nome_unidade_gestora,
	fcssc.id_sistema_cliente,
	fcssc.nome,
	fcssc.id_concat,
	fcssc.renda_total;

truncate table proc_cliente;

select count(*) from(
select distinct nome, cpf from final_cpgf_serv_sis_cliente fcssc) as hu;

select * from proc_cliente
where codigo ilike 'SERV%'
order by nome;

select count(*) from proc_cliente;

drop sequence proc_cliente_sequence;
create sequence proc_cliente_sequence start with 1;

create table final_cpgf_serv_sis_cliente(
	id_sistema_cliente numeric(20) null,
	prefixo varchar(1024) null,
	id_concat integer unique not null,
	nome_unidade_gestora varchar(1024) NULL,
	cpf varchar(1024) NULL,
	nome varchar(1024) NULL,
	"data" date NULL,
	profissao varchar(1024),
	renda_total decimal (20,2) null
)

drop table final_cpgf_serv_sis_cliente;

insert into final_cpgf_serv_sis_cliente(
	id_sistema_cliente,
	prefixo,
	id_concat,
	nome_unidade_gestora,
	cpf,
	nome,
	"data",
	renda_total
)
select 
distinct on(fc.cpf_portador, fc.nome_portador)
	1 as id_sistema_cliente,
	'CPGF' as prefixo,
	nextval('id_concat_sequence'),
	fc.nome_unidade_gestora,
	fc.cpf_portador,
	fc.nome_portador,
	min(fc."data"),
	avg(frvj.renda_total)
from final_cpgf fc
inner join
	final_rem_valor_junto frvj 
on frvj.cpf = fc.cpf_portador
group by
	fc.nome_unidade_gestora,
	fc.cpf_portador,
	fc.nome_portador;

drop sequence id_concat_sequence;
create sequence id_concat_sequence start with 1;

insert into final_cpgf_serv_sis_cliente(
	id_sistema_cliente,
	prefixo,
	id_concat,
	nome_unidade_gestora,
	cpf,
	nome,
	"data",
	profissao,
	renda_total
)
select 
distinct on(su.id_servidor_portal)
	2 as id_sistema_cliente,
	'SERV' as prefixo,
	cast(su.id_servidor_portal as integer),
	su.uorg_exercicio,
	su.cpf,
	su.nome,
	su.data_ingresso_cargofuncao,
	su.descricao_cargo,
	avg(frvj.renda_total)
from servidores_unico su
inner join
	final_rem_valor_junto frvj 
on frvj.cpf = su.cpf
group by 
	su.id_servidor_portal,
	su.uorg_exercicio,
	su.cpf,
	su.nome,
	su.data_ingresso_cargofuncao,
	su.descricao_cargo;

select * from final_cpgf_serv_sis_cliente fcssc  ;


select * from proc_cliente
order by id_proc_cliente ;
select * from sistema_cliente;
select * from operacao_disponivel;
select * from produto;
select * from final_cpgf;
select * from final_cpgf_sis_cliente;
select * from final_rem_valor_junto;
select * from final_servidores_siape_cadastro;
	