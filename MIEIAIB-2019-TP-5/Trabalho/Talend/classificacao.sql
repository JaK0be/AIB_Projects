use DW_URG_Talend;

ALTER TABLE dim_data_nascimento
ADD COLUMN classificacao VARCHAR(55);

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
        WHEN idade >= 65 THEN SET classificacao = "Idoso (apartir de 65 anos)";
	END CASE;
    
    RETURN classificacao;
END
$$
DELIMITER ;

DELIMITER $
CREATE TRIGGER classificacao_etaria_trigger BEFORE INSERT ON dim_data_nascimento
FOR EACH ROW
BEGIN
    SET new.classificacao = classificacao_etaria(new.data_nascimento); 
END $
DELIMITER ;