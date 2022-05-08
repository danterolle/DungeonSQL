-- phpMyAdmin SQL Dump
-- version 4.9.4deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Creato il: Mar 31, 2020 alle 21:00
-- Versione del server: 10.3.22-MariaDB-1
-- Versione PHP: 7.3.15-3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `provadungeon`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP1` (IN `id_pg` INT(11), IN `personaggio_pg` INT(11), IN `abilita_pg` INT(11), IN `nome` VARCHAR(50), IN `descrizione` VARCHAR(50), IN `materiale` VARCHAR(50), IN `livello` INT(11), IN `danno` INT(11), IN `tipo` VARCHAR(50), IN `personaggio_equip` INT(11), IN `abilita_equip` INT(11))  NO SQL
BEGIN
INSERT INTO equipaggiamento (id_pg, personaggio, abilita, nome, descrizione, materiale, livello, danno, tipo) VALUES (id_pg, personaggio_pg, abilita_pg, nome, descrizione, materiale, livello, danno, tipo);
SET @a = (SELECT MAX(id_pg) FROM equipaggiamento);
INSERT INTO possiede_caratteristica (personaggio, equipaggiamento, abilita) VALUES (personaggio_equip, @a, abilita_equip);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OP2` (IN `id_pg` INT(11), IN `vestiario` VARCHAR(50), IN `livello` INT(11), IN `nome_personaggio` VARCHAR(50), IN `classe` VARCHAR(50), IN `razza` VARCHAR(50), IN `allineamento_morale` VARCHAR(50), IN `pe_totali` INT(11), IN `nome_giocatore` VARCHAR(50), IN `tot_ricompense` INT(11))  NO SQL
BEGIN 
INSERT INTO personaggio (id_pg, vestiario, livello, nome_personaggio, classe, razza, allineamento_morale, pe_totali, nome_giocatore, tot_ricompense) VALUES (id_pg, vestiario, livello, nome_personaggio, classe, razza, allineamento_morale, pe_totali, nome_giocatore, tot_ricompense);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OP3` (IN `id_pg` INT(11))  NO SQL
BEGIN
SELECT * FROM partecipazione JOIN missione WHERE partecipazione.personaggio = id_pg AND partecipazione.missione = missione.id_mis;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OP4` (IN `id_pg` INT(11), IN `n_mis` INT(11), IN `n_ric` INT(11), IN `id_ab` INT(11), IN `nome_ab` VARCHAR(50), IN `grado_ab` INT(11), IN `azione_ab` VARCHAR(50), IN `tempo_ab` INT(11), IN `n_utilizzi_ab` INT(11), IN `descrizione_ab` VARCHAR(50), IN `equipaggiamento_abl` INT(11))  NO SQL
BEGIN

SET @numero_missioni = (SELECT COUNT(partecipazione.missione) FROM partecipazione, personaggio WHERE partecipazione.personaggio = personaggio.id_pg AND personaggio.id_pg = id_pg);

SET @numero_ricompense = (SELECT personaggio.tot_ricompense FROM personaggio WHERE personaggio.id_pg = id_pg);


IF ((@numero_missioni >= n_mis) AND (@numero_ricompense >= n_ric)) THEN

INSERT INTO abilita (id_abl, nome, grado, azione, tempo_di_ricarica, n_utilizzi, descrizione) VALUES (id_ab, nome_ab, grado_ab, azione_ab, tempo_ab, n_utilizzi_ab, descrizione_ab);
SET @a = (SELECT MAX(id_abl) FROM abilita);
INSERT INTO possiede_caratteristica (personaggio, equipaggiamento, abilita) VALUES (id_pg, equipaggiamento_abl, @a);

END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `abilita`
--

CREATE TABLE `abilita` (
  `id_abl` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `grado` int(11) NOT NULL,
  `azione` varchar(50) NOT NULL,
  `tempo_di_ricarica` int(11) NOT NULL,
  `n_utilizzi` int(11) NOT NULL,
  `descrizione` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `abilita`
--

INSERT INTO `abilita` (`id_abl`, `nome`, `grado`, `azione`, `tempo_di_ricarica`, `n_utilizzi`, `descrizione`) VALUES
(1, 'acrobazia', 5, 'fai un mega salto', 10, 7, 'non è un semplice salto, di più'),
(2, 'teletrasporto', 10, 'niente da dire', 60, 1, 'spostati ovunque'),
(3, 'raggirare', 7, 'convinci gli esseri viventi', 20, 2, 'puoi dire ciò che vuoi'),
(4, 'volare', 23, 'volaaaaare', 120, 5, 'perché camminare quando puoi volare'),
(5, 'guarire', 18, 'ripristina salute', 240, 3, 'puoi guarire chi e quando vuoi'),
(6, 'nuova ab', 20, 'nuova azione ab', 60, 6, 'nuova descrizione ab');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `caratteristiche_personaggio`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `caratteristiche_personaggio` (
`pg` varchar(50)
,`equip` varchar(50)
,`abl` varchar(50)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `equipaggiamento`
--

CREATE TABLE `equipaggiamento` (
  `id_pg` int(11) NOT NULL,
  `personaggio` int(11) NOT NULL,
  `abilita` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `descrizione` varchar(50) DEFAULT NULL,
  `materiale` varchar(50) DEFAULT NULL,
  `livello` int(11) DEFAULT NULL,
  `danno` int(11) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `equipaggiamento`
--

INSERT INTO `equipaggiamento` (`id_pg`, `personaggio`, `abilita`, `nome`, `descrizione`, `materiale`, `livello`, `danno`, `tipo`) VALUES
(1, 1, 2, 'lampada luminosa', 'lampada magica, per schiarire le idee', 'ferro', 4, 1, 'oggetto'),
(2, 3, 2, 'arco semplice', 'arco, per la distanza', 'legno', 5, 3, 'arma'),
(3, 3, 3, NULL, 'PROVA', 'PROVA', 22, 7, 'arma'),
(3, 4, 1, 'spada di fuoco', 'utile per gli elementali', 'ferro', 10, 20, 'arma'),
(4, 2, 5, 'libro segreto', 'libro magico di Aristofane', 'carta', 2, 1, 'oggetto'),
(5, 1, 4, 'strana ascia', 'ascia bipenne, mai dimenticarla', 'acciaio', 8, 15, 'arma')

-- --------------------------------------------------------

--
-- Struttura della tabella `missione`
--

CREATE TABLE `missione` (
  `id_mis` int(11) NOT NULL,
  `titolo` varchar(50) NOT NULL,
  `ambientazione` varchar(50) NOT NULL,
  `obiettivo` varchar(50) NOT NULL,
  `n_abilita_utilizzate` int(11) NOT NULL,
  `pe_guadagnati` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `missione`
--

INSERT INTO `missione` (`id_mis`, `titolo`, `ambientazione`, `obiettivo`, `n_abilita_utilizzate`, `pe_guadagnati`) VALUES
(1, 'un nuovo inizio', 'palude', 'trova wario', 4, 300),
(2, 'fine di un ladro', 'città', 'cerca il tesoro', 6, 400),
(3, 'il bosco senza fine', 'pianura', 'ispeziona la zona', 2, 100),
(4, 'il mondo nascosto', 'piazza', 'trova jonas', 7, 700),
(5, 'la città perduta', 'rovine', 'ripara il sigillo', 9, 500);

-- --------------------------------------------------------

--
-- Struttura della tabella `partecipazione`
--

CREATE TABLE `partecipazione` (
  `personaggio` int(11) NOT NULL,
  `missione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `partecipazione`
--

INSERT INTO `partecipazione` (`personaggio`, `missione`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 5),
(3, 3),
(3, 4),
(4, 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `personaggio`
--

CREATE TABLE `personaggio` (
  `id_pg` int(11) NOT NULL,
  `vestiario` varchar(50) NOT NULL,
  `livello` int(11) NOT NULL,
  `nome_personaggio` varchar(50) NOT NULL,
  `classe` varchar(50) NOT NULL,
  `razza` varchar(50) NOT NULL,
  `allineamento_morale` varchar(50) NOT NULL,
  `pe_totali` int(11) NOT NULL,
  `nome_giocatore` varchar(50) NOT NULL,
  `tot_ricompense` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `personaggio`
--

INSERT INTO `personaggio` (`id_pg`, `vestiario`, `livello`, `nome_personaggio`, `classe`, `razza`, `allineamento_morale`, `pe_totali`, `nome_giocatore`, `tot_ricompense`) VALUES
(1, 'armatura', 3, 'wario', 'barbaro', 'umano', 'caotico', 50, 'fabio', 3),
(2, 'armatura', 2, 'mario', 'paladino', 'umano', 'legale', 100, 'marco', 5),
(3, 'cotta di maglia', 6, 'zed', 'ranger', 'elfo', 'buono', 30, 'giz', 2),
(4, 'abito', 4, 'nivrea', 'ladro', 'mezzorco', 'malvagio', 70, 'giulia', 6),
(5, 'armatura media', 14, 'jonas', 'paladino', 'umano', 'legale', 50, 'matteo', 4),
(6, 'armatura ', 16, 'AAA', 'paladino', 'umano', 'legale', 50, 'matteo', 4),
(20, 'abito', 45, 'aaaa', 'ranger', 'orco', 'buono', 160, 'dareeo', 10);

-- --------------------------------------------------------

--
-- Struttura della tabella `possiede_caratteristica`
--

CREATE TABLE `possiede_caratteristica` (
  `personaggio` int(11) NOT NULL,
  `equipaggiamento` int(11) NOT NULL,
  `abilita` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `possiede_caratteristica`
--

INSERT INTO `possiede_caratteristica` (`personaggio`, `equipaggiamento`, `abilita`) VALUES
(3, 1, 6),
(3, 4, 3),
(3, 11, 3),
(5, 3, 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `ricompensa`
--

CREATE TABLE `ricompensa` (
  `id_ric` int(11) NOT NULL,
  `descrizione` varchar(50) NOT NULL,
  `valore` int(11) NOT NULL,
  `tipo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ricompensa`
--

INSERT INTO `ricompensa` (`id_ric`, `descrizione`, `valore`, `tipo`) VALUES
(1, 'oggetto magico, utile nel buio', 100, 'oggetto'),
(2, 'argento, molto costoso', 200, 'oggetto'),
(3, 'palla di fuoco, sempre utile', 50, 'magia'),
(4, 'spada normale, classica arma', 10, 'arma'),
(5, 'monete', 1000, 'tesoro');

-- --------------------------------------------------------

--
-- Struttura della tabella `sblocca_obiettivo`
--

CREATE TABLE `sblocca_obiettivo` (
  `ricompensa` int(11) NOT NULL,
  `missione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `sblocca_obiettivo`
--

INSERT INTO `sblocca_obiettivo` (`ricompensa`, `missione`) VALUES
(1, 1),
(1, 2),
(2, 3),
(4, 3),
(5, 2);

-- --------------------------------------------------------

--
-- Struttura per vista `caratteristiche_personaggio`
--
DROP TABLE IF EXISTS `caratteristiche_personaggio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `caratteristiche_personaggio`  AS  select distinct `personaggio`.`nome_personaggio` AS `pg`,`equipaggiamento`.`nome` AS `equip`,`abilita`.`nome` AS `abl` from ((`personaggio` join `equipaggiamento`) join `abilita`) where `personaggio`.`id_pg` = 1 ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `abilita`
--
ALTER TABLE `abilita`
  ADD PRIMARY KEY (`id_abl`);

--
-- Indici per le tabelle `equipaggiamento`
--
ALTER TABLE `equipaggiamento`
  ADD PRIMARY KEY (`id_pg`,`personaggio`,`abilita`),
  ADD KEY `personaggio` (`personaggio`),
  ADD KEY `abilita` (`abilita`);

--
-- Indici per le tabelle `missione`
--
ALTER TABLE `missione`
  ADD PRIMARY KEY (`id_mis`);

--
-- Indici per le tabelle `partecipazione`
--
ALTER TABLE `partecipazione`
  ADD PRIMARY KEY (`personaggio`,`missione`),
  ADD KEY `partecipazione_ibfk_2` (`missione`);

--
-- Indici per le tabelle `personaggio`
--
ALTER TABLE `personaggio`
  ADD PRIMARY KEY (`id_pg`);

--
-- Indici per le tabelle `possiede_caratteristica`
--
ALTER TABLE `possiede_caratteristica`
  ADD PRIMARY KEY (`personaggio`,`equipaggiamento`,`abilita`),
  ADD KEY `possiede_caratteristica_ibfk_2` (`equipaggiamento`),
  ADD KEY `possiede_caratteristica_ibfk_3` (`abilita`);

--
-- Indici per le tabelle `ricompensa`
--
ALTER TABLE `ricompensa`
  ADD PRIMARY KEY (`id_ric`);

--
-- Indici per le tabelle `sblocca_obiettivo`
--
ALTER TABLE `sblocca_obiettivo`
  ADD PRIMARY KEY (`ricompensa`,`missione`),
  ADD KEY `sblocca_obiettivo_ibfk_2` (`missione`);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `equipaggiamento`
--
ALTER TABLE `equipaggiamento`
  ADD CONSTRAINT `equipaggiamento_ibfk_1` FOREIGN KEY (`personaggio`) REFERENCES `personaggio` (`id_pg`),
  ADD CONSTRAINT `equipaggiamento_ibfk_2` FOREIGN KEY (`abilita`) REFERENCES `abilita` (`id_abl`);

--
-- Limiti per la tabella `partecipazione`
--
ALTER TABLE `partecipazione`
  ADD CONSTRAINT `partecipazione_ibfk_1` FOREIGN KEY (`personaggio`) REFERENCES `personaggio` (`id_pg`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `partecipazione_ibfk_2` FOREIGN KEY (`missione`) REFERENCES `missione` (`id_mis`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `possiede_caratteristica`
--
ALTER TABLE `possiede_caratteristica`
  ADD CONSTRAINT `possiede_caratteristica_ibfk_1` FOREIGN KEY (`personaggio`) REFERENCES `personaggio` (`id_pg`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `possiede_caratteristica_ibfk_2` FOREIGN KEY (`equipaggiamento`) REFERENCES `equipaggiamento` (`id_pg`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `possiede_caratteristica_ibfk_3` FOREIGN KEY (`abilita`) REFERENCES `abilita` (`id_abl`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `sblocca_obiettivo`
--
ALTER TABLE `sblocca_obiettivo`
  ADD CONSTRAINT `sblocca_obiettivo_ibfk_1` FOREIGN KEY (`ricompensa`) REFERENCES `ricompensa` (`id_ric`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sblocca_obiettivo_ibfk_2` FOREIGN KEY (`missione`) REFERENCES `missione` (`id_mis`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
