select * from proc_operacao_realizada;
select * from operacao_disponivel od ;
select * from final_cpgf;
select * from final_cpgf_serv_sis_cliente;
select * from final_servidores_siape_cadastro fssc ;
select * from proc_contrato pc ;
select * from proc_cliente;
select * from final_servidores_siape_remuneracao fssr ;

ALTER TABLE final_servidores_siape_remuneracao
ALTER COLUMN id_servidor_portal TYPE integer USING id_servidor_portal::integer;

insert into proc_operacao_realizada(
	cep,
	codigo,
	complemento,
	documento_contraparte,
	dt_operacao,
	especie,
	hr_operacao,
	id_operacao_disponivel,
	id_proc_cliente,
	id_proc_contrato,
	id_proc_operacao_realizada,
	id_produto,
	nome_contraparte,
	outros,
	patrimonio,
	renda,
	tipo_operacao,
	valor,
	valor_esperado
)
select
	null,
	concat('CPGF_', nextval('proc_operacao_realizada_sequence')),
	null,
	fc.documento_favorecido,
	fc."data",
	od.especie,
	null,
	od.id_operacao_disponivel,
	pc.id_proc_cliente,
	pcon.id_proc_contrato,
	nextval('proc_operacao_realizada_sequence'),
	pcon.id_produto,
	fc.nome_favorecido,
	'{}',
	0,
	pc.renda ,
	od.tipo_operacao ,
	fc.valor,
	null
from
	final_cpgf fc
inner join
	operacao_disponivel od
on
	od.nome = fc.transacao
inner join
	proc_cliente pc 
on
	pc.documento = fc.cpf_portador and pc.nome = fc.nome_portador 
inner join
	proc_contrato pcon
on
	pc.id_proc_cliente = pcon.id_proc_cliente;

-----------------------------------------------------------------------------------

insert into proc_operacao_realizada(
	cep,
	codigo,
	complemento,
	documento_contraparte,
	dt_operacao,
	especie,
	hr_operacao,
	id_operacao_disponivel,
	id_proc_cliente,
	id_proc_contrato,
	id_proc_operacao_realizada,
	id_produto,
	nome_contraparte,
	outros,
	patrimonio,
	renda,
	tipo_operacao,
	valor,
	valor_esperado
)
select
	null,
	concat('SERV_', nextval('proc_operacao_realizada_sequence')),
	null,
	null,
	to_date(concat('01/', frvj.mes, '/', frvj.ano), 'DD/MM/YYYY'),
	false,
	null,
	201,
	pc.id_proc_cliente,
	pcon.id_proc_contrato,
	nextval('proc_operacao_realizada_sequence'),
	pcon.id_produto,
	null,
	'{}',
	0,
	pc.renda ,
	1,
	frvj.renda_total,
	null
from
	final_rem_valor_junto  frvj
inner join
	proc_cliente pc 
on
	pc.documento = frvj.cpf  and pc.nome = frvj.nome 
inner join
	proc_contrato pcon
on
	pc.id_proc_cliente = pcon.id_proc_cliente

select * from final_rem_valor_junto frvj 
where id_servidor_portal = 79722318;

drop sequence proc_operacao_realizada_sequence;
create sequence proc_operacao_realizada_sequence;

select * from final_rem_valor_junto frvj  ;