select * from operacao_disponivel;
select * from final_cpgf;
select * from proc_contrato;

insert into  operacao_disponivel 
values
(false, 101,1,    'COMP A/V-SOL DISP C/CLI-R$ ANT VENC', 'CSAV', 2),
(false, 102,1, 'COMPRA A/V - INT$ - APRES', 'CIA', 2),
(false, 103,1, 'COMPRA A/V - R$ - APRES', 'CRA', 2),
(false, 104,1,    'CPP LOJISTA TRF P/FATURA - real', 'CPP', 2),
(true, 105,1,    'SAQUE MANUAL-CARTOES BB NA AGENCIA', 'SMC', 2),
(true, 106,1,    'SAQUE BB B24HORAS-SOL C/CLIENTE', 'SB24', 2),
(true, 107,1,    'SAQUE - INT$ - APRES', 'SIA', 2),
(true, 108,1,    'SAQUE CASH/ATM BB', 'SCB', 2)    ,
(false, 201,2,    'RECEBIMENTO SALARIO', 'RECS', 1)


drop sequence operacao_disponivel_sequence;
create sequence operacao_disponivel_sequence;
			
