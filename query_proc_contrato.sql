insert into proc_contrato (
	categoria,codigo,
	documento_contraparte,
	dt_entrada,
	dt_vencimento,
	id_proc_cliente,
	id_proc_contrato,
	id_produto,
	moeda,
	nome_contraparte,
	outros,
	pais,
	produto,
	relacionado,
	relacionamento,
	status,
	valor,
	valor_entrada,
	valor_mensal
)
select
	null,
	pc.codigo,
	null,
	pc.dt_entrada,
	null,
	nextval('id_proc_cliente_sequence') as id_proc_cliente,
	nextval('proc_contrato_sequence') as id_proc_contrato,
	p.id_produto,
	null,
	null,
	'{}',
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null
from proc_cliente pc
inner join
	produto p 
on
	p.id_sistema = pc.id_sistema;

drop sequence proc_contrato_sequence;
create sequence proc_contrato_sequence start with 1;

drop sequence id_proc_cliente_sequence;
create sequence id_proc_cliente_sequence start with 26041;


select * from proc_contrato pc ;
