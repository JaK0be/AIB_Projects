use DW_URG;

select * from urg_inform_geral;

-- Povoamento tabela Causa
insert into dim_causa (descricao)
	select distinct DES_CAUSA from urg_inform_geral;

-- Povoamento tabela Local
insert into dim_local (descricao)
	select distinct DES_LOCAL from urg_inform_geral;
 
-- Povoamento tabela Proveniencia 
insert into dim_proveniencia (descricao)
	select distinct DES_PROVENIENCIA from urg_inform_geral;

-- Povoamento tabela Especialidade    
insert into dim_especialidade (descricao)
	select distinct ALTA_DES_ESPECIALIDADE from urg_inform_geral;

-- Povoamento tabela Sexo    
insert into dim_sexo (descricao)
	select distinct SEXO from urg_inform_geral;
    
-- Povoamento tabela Data_Nascimento
insert into dim_data_nascimento (ano,mes,dia, data_nascimento, classificacao)
	select distinct SUBSTRING(DTA_NASCIMENTO,1,4 ), SUBSTRING(DTA_NASCIMENTO,6,2 ), SUBSTRING(DTA_NASCIMENTO,9,2 ), STR_TO_DATE(DTA_NASCIMENTO, '%Y-%m-%d'), classificacao_etaria(STR_TO_DATE(DTA_NASCIMENTO, '%Y-%m-%d')) from urg_inform_geral;

-- Povoamento tabela Data_Hora
-- Datas de Admissão
insert into dim_data_hora (ano, mes, dia, hora, minutos, segundos, data_hora)
	select distinct SUBSTRING(DATAHORA_ADM,1,4 ), SUBSTRING(DATAHORA_ADM,6,2 ), SUBSTRING(DATAHORA_ADM,9,2 ), SUBSTRING(DATAHORA_ADM,12,2 ), SUBSTRING(DATAHORA_ADM,15,2 ), SUBSTRING(DATAHORA_ADM,18,2 ), STR_TO_DATE(DATAHORA_ADM, '%Y-%m-%d %H:%i:%s') from urg_inform_geral;

-- Datas de Alta 
insert into dim_data_hora (ano, mes, dia, hora, minutos, segundos, data_hora)
	select distinct SUBSTRING(DATAHORA_ALTA,1,4 ), SUBSTRING(DATAHORA_ALTA,6,2 ), SUBSTRING(DATAHORA_ALTA,9,2 ), SUBSTRING(DATAHORA_ALTA,12,2 ), SUBSTRING(DATAHORA_ALTA,15,2 ), SUBSTRING(DATAHORA_ALTA,18,2 ), STR_TO_DATE(DATAHORA_ALTA, '%Y-%m-%d %H:%i:%s') from urg_inform_geral
	where STR_TO_DATE(DATAHORA_ALTA, '%Y-%m-%d %H:%i:%s') not in (select data_hora from dim_data_hora);

-- Povoamento tabela de Factos

insert into factos_urgencias (urg_episodio, causa, local, proveniencia, especialidade, sexo, data_nascimento, data_admissao, data_alta)	
    select L.URG_EPISODIO, C.id, Loc.id, P.id, E.id, S.id, DN.id, DH1.id, DH2.id
		from urg_inform_geral as L
		left join dim_causa as C on L.DES_CAUSA = C.descricao
        left join dim_local as Loc on L.DES_LOCAL = Loc.descricao
        left join dim_proveniencia as P on L.DES_PROVENIENCIA = P.descricao
        left join dim_especialidade as E on L.ALTA_DES_ESPECIALIDADE = E.descricao
        left join dim_sexo as S on L.SEXO = S.descricao
        left join dim_data_nascimento as DN on STR_TO_DATE(L.DTA_NASCIMENTO, '%Y-%m-%d') = DN.data_nascimento
        left join dim_data_hora as DH1 on STR_TO_DATE(L.DATAHORA_ADM, '%Y-%m-%d %H:%i:%s') = DH1.data_hora
        left join dim_data_hora as DH2 on STR_TO_DATE(L.DATAHORA_ALTA, '%Y-%m-%d %H:%i:%s') = DH2.data_hora;
       
select * from factos_urgencias;

DROP FUNCTION IF EXISTS classificacao_etaria;
DELIMITER $$
CREATE FUNCTION classificacao_etaria(dn DATE)
RETURNS VARCHAR(55)
READS SQL DATA
BEGIN
	DECLARE classificacao VARCHAR(55);
	DECLARE idade INT DEFAULT 0;

	SET idade = YEAR(NOW())-YEAR(dn);
	IF (MONTH(NOW())=MONTH(dn)) 
		THEN IF (DAY(NOW())<MONTH(dn))
			THEN SET idade = idade-1;
	END IF;
	ELSEIF (MONTH(NOW())<MONTH(dn))
		THEN SET idade = idade-1;
	END IF;
    
    CASE
		WHEN idade >= 0 AND idade <= 14 THEN SET classificacao = "Criança (0 a 14 anos)";
        WHEN idade >= 15 AND idade <= 24 THEN SET classificacao = "Jovem (15 a 24 anos)";
		WHEN idade >= 25 AND idade <= 64 THEN SET classificacao = "Adulto (25 a 64 anos)";
        WHEN idade >= 65 THEN SET classificacao = "Idoso (a partir de 65 anos)";
	END CASE;
    
    RETURN classificacao;
END
$$
DELIMITER ;
