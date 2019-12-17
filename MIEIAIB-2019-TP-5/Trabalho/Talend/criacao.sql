-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DW_URG_Talend
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DW_URG_Talend
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DW_URG_Talend` DEFAULT CHARACTER SET utf8 ;
USE `DW_URG_Talend` ;

-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_data_hora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_data_hora` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dia` INT NOT NULL,
  `mes` INT NOT NULL,
  `ano` INT NOT NULL,
  `hora` INT NOT NULL,
  `minutos` INT NOT NULL,
  `segundos` INT NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_especialidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_especialidade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(55) NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_local`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_local` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(55) NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_proveniencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_proveniencia` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(55) NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_causa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_causa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(55) NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_sexo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_sexo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(3) NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`dim_data_nascimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`dim_data_nascimento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dia` INT NOT NULL,
  `mes` INT NOT NULL,
  `ano` INT NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `data_alteracao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DW_URG_Talend`.`factos_urgencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DW_URG_Talend`.`factos_urgencias` (
  `urg_episodio` INT NOT NULL,
  `data_admissao` INT NOT NULL,
  `data_alta` INT NOT NULL,
  `especialidade` INT NOT NULL,
  `local` INT NOT NULL,
  `proveniencia` INT NOT NULL,
  `causa` INT NOT NULL,
  `sexo` INT NOT NULL,
  `data_nascimento` INT NOT NULL,
  PRIMARY KEY (`urg_episodio`),
  INDEX `fk_factos_urgencias_dim_data_hora_idx` (`data_admissao` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_data_hora1_idx` (`data_alta` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_especialidade1_idx` (`especialidade` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_local1_idx` (`local` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_proveniencia1_idx` (`proveniencia` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_causa1_idx` (`causa` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_sexo1_idx` (`sexo` ASC) VISIBLE,
  INDEX `fk_factos_urgencias_dim_data_nascimento1_idx` (`data_nascimento` ASC) VISIBLE,
  CONSTRAINT `fk_factos_urgencias_dim_data_hora`
    FOREIGN KEY (`data_admissao`)
    REFERENCES `DW_URG_Talend`.`dim_data_hora` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_data_hora1`
    FOREIGN KEY (`data_alta`)
    REFERENCES `DW_URG_Talend`.`dim_data_hora` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_especialidade1`
    FOREIGN KEY (`especialidade`)
    REFERENCES `DW_URG_Talend`.`dim_especialidade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_local1`
    FOREIGN KEY (`local`)
    REFERENCES `DW_URG_Talend`.`dim_local` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_proveniencia1`
    FOREIGN KEY (`proveniencia`)
    REFERENCES `DW_URG_Talend`.`dim_proveniencia` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_causa1`
    FOREIGN KEY (`causa`)
    REFERENCES `DW_URG_Talend`.`dim_causa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_sexo1`
    FOREIGN KEY (`sexo`)
    REFERENCES `DW_URG_Talend`.`dim_sexo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factos_urgencias_dim_data_nascimento1`
    FOREIGN KEY (`data_nascimento`)
    REFERENCES `DW_URG_Talend`.`dim_data_nascimento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
