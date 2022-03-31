select * from final_cpgf fc ;

select * from final_pep fp ;

/*1. Identificar 'pessoas' (portador) que movimentaram em espepécie (Saques) mais do que 20 mil reais em espécie.*/

select 
	cpf_portador, 
	nome_portador,
	max(valor) as maior_valor_saque,
	min(valor) as menor_valor_saque,
	count(*) as qtd_movimentacoes,
	ano,
	mes,
	sum(valor) as valor_total
from 
	final_cpgf fc 
where 
	transacao like 'SAQUE%'  
group by 
	cpf_portador,
	nome_portador,
	mes,
	ano
having 
	sum(valor) >= 20000
order by
	mes, ano;

	
/*2. Identificar 'pessoas' (portador) que movimentaram em um único dia em espécie (saques) mais do que 5 mil reais.*/

select 
	cpf_portador,
	nome_portador,
	"data",
	count(*) as qtd_movimentacoes,
	sum(valor) as valor_total
from
	final_cpgf fc
where
	transacao like 'SAQUE%'
group by
	cpf_portador,
	nome_portador,
	"data"
having
	sum(valor) >= 5000
order by
	sum(valor);

/*3. Qual o orgão que fez pelo menos 100 movimentações sigilosas dentro de um mês com valor exatamente igual a 1000 reais.*/

select
	codigo_orgao,
	nome_orgao,
	valor,
	ano,
	mes,
	count(*) as qnt_transacoes_sigilosas
from
	final_cpgf fc 
where 
	transacao like 'Informações protegidas por sigilo'
group by
	codigo_orgao,
	nome_orgao,
	valor,
	ano,
	mes
having
	count(*) >= 100
	and
	valor = 1000
order by 
	codigo_orgao,
	ano,
	mes;

/*4. Qual o orgão que fez pelo menos 100 mil reais em movimentações sigilosas dentro de um mês com valor multiplo de 100 reais.*/
select
	codigo_orgao,
	nome_orgao,
	ano,
	mes,
	sum(valor) as valor_total
from
	final_cpgf fc 
where
	transacao like 'Informações protegidas por sigilo'
	and
	mod(valor,100) = 0
group by
	codigo_orgao,
	nome_orgao,
	ano,
	mes
having
	sum(valor) >= 100000
order by
	mes,
	ano;

/*5. Quantas pessoas usaram o cartão e são PEPs ? e quantas pessoas usaram o cartão e não são PEP?*/

select
	distinct
	fc.nome_portador, fc.cpf_portador 
from
	final_cpgf fc
inner join
	final_pep fp
on
	fc.cpf_portador = fp."CPF" and 
	fc.nome_portador = fp."NOME_PEP";

/*6. identificar pessoas que receberam (remuneracao servidores) mais do que 500 mil em 2021 ? Soma real mais dollar, assuma o valor do dollar como R$ 5,40 e quais os seus orgãos.*/

select * from final_servidores_siape_remuneracao;
select * from final_servidores_siape_cadastro;


select 
	fssr.id_servidor_portal, 
	fssr.cpf, 
	fssr.nome, 
	sum(fssr.remuneracao_basica_bruta_rs + fssr.remuneracao_basica_bruta_us*5.4) as soma_remuneracao_rs_us_2021,
	fssc.cod_org_lotacao, 
	fssc.org_lotacao
from final_servidores_siape_remuneracao fssr
inner join final_servidores_siape_cadastro fssc
on fssr.cpf = fssc.cpf
group by
	fssr.id_servidor_portal, 
	fssr.cpf, 
	fssr.nome,
	fssc.cod_org_lotacao, 
	fssc.org_lotacao
having
	sum(fssr.remuneracao_basica_bruta_rs + fssr.remuneracao_basica_bruta_us*5.4) >= 500000;
	
select 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao,
	sum(fsr.remuneracao_basica_bruta_rs) + sum(fsr.remuneracao_basica_bruta_us)*5.4  as total_reais
from 
	final_servidores_siape_remuneracao fsr 
inner join
	final_servidores_siape_cadastro fs2 
	on fs2.id_servidor_portal = fsr.id_servidor_portal 
group by 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao 
having
	sum(fsr.remuneracao_basica_bruta_rs) + sum(fsr.remuneracao_basica_bruta_us)*5.4 > 500000;
	
/*7. Identificar pessoas que receberam (remuneração servidores) mais do que 500 mil em 2021 apenas em moeda estrangeira.*/

select * from final_servidores_siape_remuneracao;

select 
	fssr.cpf, 
	fssr.nome,
	sum(fssr.remuneracao_basica_bruta_us*5.4) as recebido_em_us
from
	final_servidores_siape_remuneracao fssr
group by
	fssr.cpf, 
	fssr.nome
having
	sum(fssr.remuneracao_basica_bruta_us*5.4) > 500000;

/*8. Há PEPs dentro do conjunto 6 ? Quais?*/

select 
	fp."CPF", 
	fp."NOME_PEP" 
from 
	final_pep fp
where exists(
	select 1
	from 
		final_servidores_siape_remuneracao fsr 
	where
		fp."CPF" = fsr.cpf 
		and
		fp."NOME_PEP" = fsr.nome 
	having
		sum(fsr.remuneracao_basica_bruta_rs) + sum(fsr.remuneracao_basica_bruta_us)*5.4 > 500000
);

select * from final_cpgf fc 
where fc.nome_favorecido like '%MERCADOPAGO%';