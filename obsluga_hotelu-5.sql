-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 08 Maj 2019, 13:34
-- Wersja serwera: 10.1.38-MariaDB
-- Wersja PHP: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `obsluga_hotelu`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostepne_pokoje` (IN `poczatek` DATE, IN `koniec` DATE)  NO SQL
BEGIN
   select pokoj.NrPokoju, pokoj.LiczbaMiejsc, pokoj.Pietro, pokoj.TypPokoju, pokoj.CenaPokoju from pokoj, rezerwacja_pokoj,rezerwacja
   WHERE
   pokoj.NrPokoju=rezerwacja_pokoj.NrPokoju 
   and rezerwacja_pokoj.NrRezerwacji=rezerwacja.NrRezerwacji
   and rezerwacja.PoczatekRezerwacji>koniec 
   OR (rezerwacja.PoczatekRezerwacji<poczatek
   	   AND rezerwacja.KoniecRezerwacji<poczatek)
   
LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generuj_rachunek` (IN `id_klient` INT)  NO SQL
BEGIN
DECLARE x, y, z INT DEFAULT 0;
SELECT (pobyt.KoniecZameldowania - pobyt.PoczatekZameldowania),  (pobyt.KoniecZameldowania - pobyt.PoczatekZameldowania) * 			pokoj.CenaPokoju, pobyt.NrPobytu INTO x,y,z
FROM pobyt, pokoj
WHERE pobyt.FkKlient=id_klient 
	AND pobyt.FkPokoj=pokoj.NrPokoju;
	
 INSERT INTO rachunek VALUES (null, y, x,id_klient); 
 INSERT INTO rachunek_pobyt VALUES(z,LAST_INSERT_ID());
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `wykonaj_rezerwacje` (IN `pocz` DATE, IN `kon` DATE, IN `klient` INT(10), IN `pokoj` INT(10))  NO SQL
BEGIN
 INSERT INTO rezerwacja VALUES (null, pocz, kon,null,klient); 
 INSERT INTO rezerwacja_pokoj VALUES(LAST_INSERT_ID(),pokoj);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `znajdz_klienta` (IN `nazwisko` VARCHAR(40))  NO SQL
BEGIN
  SELECT * FROM klient
  WHERE klient.NazwiskoKlienta= nazwisko;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adres`
--

CREATE TABLE `adres` (
  `IdAdres` int(10) NOT NULL,
  `Miejscowosc` varchar(40) NOT NULL,
  `KodPocztowy` char(6) NOT NULL,
  `Ulica` varchar(20) DEFAULT NULL,
  `NrDomu` int(10) NOT NULL,
  `NrMieszkania` int(10) DEFAULT NULL,
  `NrTelefonu` char(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `adres`
--

INSERT INTO `adres` (`IdAdres`, `Miejscowosc`, `KodPocztowy`, `Ulica`, `NrDomu`, `NrMieszkania`, `NrTelefonu`) VALUES
(1, 'Wroclaw', '80-250', 'Wroclawska', 1, 1, '+48711112233'),
(2, 'Poznan', '12-130', 'Kwiatkowa', 5, 2, NULL),
(3, 'Piernikowo', '98-214', NULL, 3, NULL, NULL),
(4, 'Goszczanow', '13-115', NULL, 72, NULL, '+48438264334'),
(5, 'Gdynia', '20-140', 'Morska', 2, 14, '12233'),
(6, 'Gdansk', '98-190', 'Zabia', 90, 70, NULL),
(7, 'Warta', '30-150', 'Krakowska', 3, NULL, NULL),
(8, 'Gda?sk', '90-220', NULL, 3, NULL, NULL),
(9, 'Gdańsk', '80-250', NULL, 5, NULL, NULL),
(10, 'Godziszewo', '30-120', NULL, 2, NULL, NULL),
(11, 'Pobierowo', '30-149', NULL, 17, NULL, NULL),
(12, 'Ratajewo', '30-123', NULL, 15, NULL, NULL),
(13, 'Kurpiki', '30-249', NULL, 10, NULL, NULL),
(14, 'Sarajewp', '30-159', NULL, 20, NULL, NULL),
(15, 'Szczajewo', '30-179', NULL, 27, NULL, NULL),
(16, 'Blizanów', '30-155', NULL, 90, NULL, NULL),
(17, 'Robaczkowo', '40-120', NULL, 91, NULL, NULL),
(18, 'Kamyczkowo', '70-149', NULL, 17, NULL, NULL),
(19, 'Siateczkowo', '45-210', NULL, 70, NULL, NULL),
(20, 'Żabki', '30-220', NULL, 27, NULL, NULL),
(21, 'Pobierowo', '30-190', NULL, 99, NULL, NULL),
(23, 'Chocz', '40-149', NULL, 27, NULL, NULL),
(24, 'Pleszew', '36-149', NULL, 55, NULL, NULL),
(25, 'Randomowo', '70-149', NULL, 99, NULL, NULL);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `goscie_teraz`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `goscie_teraz` (
`NrKlienta` int(10)
,`ImieKlienta` varchar(20)
,`ImieDrugie` varchar(20)
,`NazwiskoKlienta` varchar(40)
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `historia_rezerwacji`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `historia_rezerwacji` (
`PoczatekRezerwacji` date
,`KoniecRezerwacji` date
,`ImieKlienta` varchar(20)
,`ImieDrugie` varchar(20)
,`NazwiskoKlienta` varchar(40)
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `hotel`
--

CREATE TABLE `hotel` (
  `Nazwa` int(10) NOT NULL,
  `HotelNazwa` varchar(25) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `FkAdres` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `hotel`
--

INSERT INTO `hotel` (`Nazwa`, `HotelNazwa`, `Email`, `FkAdres`) VALUES
(1, 'Hotel', 'hotel@gmail.com', 1);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `hotel_dane`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `hotel_dane` (
`HotelNazwa` varchar(25)
,`Miejscowosc` varchar(40)
,`KodPocztowy` char(6)
,`Ulica` varchar(20)
,`NrDomu` int(10)
,`NrMieszkania` int(10)
,`NrTelefonu` char(12)
,`Email` varchar(40)
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klient`
--

CREATE TABLE `klient` (
  `NrKlienta` int(10) NOT NULL,
  `ImieKlienta` varchar(20) NOT NULL,
  `ImieDrugie` varchar(20) DEFAULT NULL,
  `NazwiskoKlienta` varchar(40) NOT NULL,
  `DataUrodzenia` date DEFAULT NULL,
  `Obywatelstwo` varchar(40) NOT NULL,
  `Email` varchar(40) DEFAULT NULL,
  `FkAdres` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `klient`
--

INSERT INTO `klient` (`NrKlienta`, `ImieKlienta`, `ImieDrugie`, `NazwiskoKlienta`, `DataUrodzenia`, `Obywatelstwo`, `Email`, `FkAdres`) VALUES
(2, 'Radoslaw', 'Przemyslaw', 'Nowak', '2017-07-01', 'Polska', NULL, 1),
(3, 'Tomasz', NULL, 'Kubat', '1995-03-02', 'Polska', NULL, 1),
(4, 'Przemyslaw', 'Stanislaw', 'Kwiatkowski', '1992-05-21', 'Polska', 'kwiatkowski@wp.pl', 1),
(5, 'Wlodzimierz', 'Sebastian', 'Zomerski', '1965-03-04', 'Polska', 'wlodzimierzzomerski@wp.pl', 3),
(6, 'Patryk', NULL, 'Dziatkiewicz', NULL, 'Polska', NULL, 5),
(7, 'Janusz', NULL, 'Szczepaniak', NULL, 'Polska', NULL, 13),
(8, 'Janusz', NULL, 'Szczepaniak', NULL, 'Polska', NULL, 13),
(9, 'Janusz', NULL, 'Tracz', NULL, 'Polska', NULL, 15),
(10, 'Józef', NULL, 'Poniatowski', NULL, 'Polska', NULL, 14),
(11, 'Janusz', NULL, 'Szcześniak', NULL, 'Polska', NULL, 20),
(12, 'Jakub', NULL, 'Błaszczykowski', NULL, 'Polska', NULL, 2),
(13, 'Zbigniew', NULL, 'Boniek', NULL, 'Polska', NULL, 20),
(14, 'Robert', NULL, 'Lewandowski', NULL, 'Polska', NULL, 4),
(15, 'Tomasz', NULL, 'Hajto', NULL, 'Polska', NULL, 13),
(16, 'Adam', NULL, 'Nawałka', NULL, 'Polska', NULL, 21),
(19, 'Piotr', NULL, 'Bałtroczyk', NULL, 'Polska', NULL, 21),
(20, 'Wlodzimierz', NULL, 'Zomerski', NULL, 'Polska', NULL, 12),
(21, 'Wlodzimierz', NULL, 'Zomerski', NULL, 'Polska', NULL, 12),
(22, 'Radosław', NULL, 'Zomerski', NULL, 'Polska', NULL, 12),
(23, 'Wlodzimierz', NULL, 'Urbański', NULL, 'Polska', NULL, 14),
(24, 'Radosław', NULL, 'Kich', NULL, 'Polska', NULL, 20),
(25, 'Genowefa', NULL, 'Dych', NULL, 'Polska', NULL, 12),
(26, 'Izydor', NULL, 'Chich', NULL, 'Polska', NULL, 6),
(27, 'Danuta', NULL, 'Ziombelowksi', NULL, 'Polska', NULL, 4),
(28, 'Agnieszka', NULL, 'Stachursky', NULL, 'Polska', NULL, 6),
(29, 'Sylwia', NULL, 'Stroński', NULL, 'Polska', NULL, 7),
(30, 'Grażyna', NULL, 'Damiecki', NULL, 'Polska', NULL, 8),
(31, 'Tomasz', NULL, 'Domski', NULL, 'Polska', NULL, 11),
(32, 'Tadeusz', NULL, 'Goleń', NULL, 'Polska', NULL, 13),
(33, 'Radosław', NULL, 'Zomerski', NULL, 'Polska', NULL, 12),
(34, 'Wlodzimierz', NULL, 'Urbański', NULL, 'Polska', NULL, 14),
(35, 'Radosław', NULL, 'Kich', NULL, 'Polska', NULL, 20),
(36, 'Genowefa', NULL, 'Dych', NULL, 'Polska', NULL, 12),
(37, 'Izydor', NULL, 'Chich', NULL, 'Polska', NULL, 6),
(38, 'Danuta', NULL, 'Ziombelowksi', NULL, 'Polska', NULL, 4),
(39, 'Agnieszka', NULL, 'Stachursky', NULL, 'Polska', NULL, 6),
(40, 'Sylwia', NULL, 'Stroński', NULL, 'Polska', NULL, 7),
(41, 'Grażyna', NULL, 'Damiecki', NULL, 'Polska', NULL, 8),
(42, 'Tomasz', NULL, 'Domski', NULL, 'Polska', NULL, 11),
(43, 'Tadeusz', NULL, 'Goleń', NULL, 'Polska', NULL, 13);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `platnosc_pokoj`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `platnosc_pokoj` (
`FkKlient` int(10)
,`Oplata` int(10)
,`CzasPobytu` int(10)
,`PoczatekZameldowania` date
,`KoniecZameldowania` date
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pobyt`
--

CREATE TABLE `pobyt` (
  `NrPobytu` int(10) NOT NULL,
  `PoczatekZameldowania` date NOT NULL,
  `KoniecZameldowania` date DEFAULT NULL,
  `FkPokoj` int(10) NOT NULL,
  `FkKlient` int(10) NOT NULL,
  `FkRezerwacja` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `pobyt`
--

INSERT INTO `pobyt` (`NrPobytu`, `PoczatekZameldowania`, `KoniecZameldowania`, `FkPokoj`, `FkKlient`, `FkRezerwacja`) VALUES
(1, '2019-05-05', '2019-05-07', 1, 3, 8),
(15, '2019-05-23', '2019-05-29', 1, 3, 9),
(16, '2019-05-08', '2019-05-08', 3, 10, 8),
(17, '2019-05-08', '2019-05-08', 3, 12, 6),
(18, '2019-05-05', '2019-05-08', 4, 16, 7),
(19, '2019-05-04', '2019-05-17', 5, 6, 7),
(20, '2019-05-08', '2019-05-17', 2, 38, 10),
(41, '2019-05-08', '2019-05-10', 2, 38, 12),
(42, '2019-05-08', '2019-05-23', 2, 34, 12),
(43, '2019-05-08', '2019-05-24', 3, 35, 12),
(44, '2019-05-08', '2019-05-30', 4, 36, 13),
(45, '2019-05-08', '2019-05-18', 5, 37, 14),
(46, '2019-05-08', '2019-05-25', 2, 38, 15),
(47, '2019-05-08', '2019-05-14', 7, 39, 16),
(48, '2019-05-08', '2019-05-24', 9, 40, 17),
(49, '2019-05-08', '2019-05-18', 12, 41, 18),
(50, '2019-05-08', '2019-05-31', 15, 42, 19);

--
-- Wyzwalacze `pobyt`
--
DELIMITER $$
CREATE TRIGGER `ustaw_dostepny` AFTER UPDATE ON `pobyt` FOR EACH ROW UPDATE pokoj,pobyt SET pokoj.DostepnyTeraz=1 
WHERE pobyt.FkPokoj=pokoj.NrPokoju
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ustaw_niedostepny` AFTER INSERT ON `pobyt` FOR EACH ROW UPDATE pokoj,pobyt SET pokoj.DostepnyTeraz=0 
WHERE pobyt.FkPokoj=pokoj.NrPokoju
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pokoj`
--

CREATE TABLE `pokoj` (
  `NrPokoju` int(10) NOT NULL,
  `LiczbaMiejsc` int(10) NOT NULL,
  `Pietro` int(10) NOT NULL,
  `TypPokoju` varchar(15) NOT NULL,
  `CenaPokoju` int(10) NOT NULL,
  `DostepnyTeraz` char(1) NOT NULL,
  `FkNazwa` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `pokoj`
--

INSERT INTO `pokoj` (`NrPokoju`, `LiczbaMiejsc`, `Pietro`, `TypPokoju`, `CenaPokoju`, `DostepnyTeraz`, `FkNazwa`) VALUES
(1, 2, 1, 'dwuosobowy', 100, '1', 1),
(2, 2, 1, 'dwuosobowy', 100, '1', 1),
(3, 2, 1, 'dwuosobowy', 100, '1', 1),
(4, 2, 1, 'dwuosobowy', 100, '1', 1),
(5, 2, 1, 'dwuosobowy', 100, '1', 1),
(7, 2, 2, 'dwuosobowy', 200, '1', 1),
(8, 2, 2, 'dwuosobowy', 200, '1', 1),
(9, 2, 2, 'dwuosobowy', 200, '1', 1),
(10, 2, 2, 'dwuosobowy', 200, '1', 1),
(11, 2, 2, 'dwuosobowy', 200, '1', 1),
(12, 2, 2, 'dwuosobowy', 200, '1', 1),
(13, 2, 3, 'dwuosobowy', 300, '1', 1),
(14, 2, 3, 'dwuosobowy', 300, '1', 1),
(15, 2, 3, 'dwuosobowy', 300, '1', 1),
(16, 2, 3, 'dwuosobowy', 300, '1', 1),
(17, 2, 3, 'dwuosobowy', 300, '1', 1),
(18, 4, 4, 'apartament', 500, '1', 1),
(19, 4, 4, 'apartament', 500, '1', 1),
(20, 4, 4, 'apartament', 500, '1', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rachunek`
--

CREATE TABLE `rachunek` (
  `NrRachunku` int(10) NOT NULL,
  `Oplata` int(10) NOT NULL,
  `CzasPobytu` int(10) NOT NULL,
  `FkKlient` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `rachunek`
--

INSERT INTO `rachunek` (`NrRachunku`, `Oplata`, `CzasPobytu`, `FkKlient`) VALUES
(1, 200, 2, 3),
(3, 200, 2, 3),
(4, 500, 2, 3),
(5, 200, 3, 8),
(7, 300, 3, 16),
(8, 0, 0, 30),
(9, 0, 0, 33),
(10, 1500, 15, 34),
(11, 0, 0, 31),
(12, 1500, 15, 34),
(13, 1500, 15, 34),
(14, 1000, 10, 37),
(15, 0, 0, 32),
(16, 1500, 15, 34),
(17, 1000, 10, 37),
(18, 1500, 15, 34),
(19, 0, 0, 33),
(20, 1500, 15, 34),
(21, 1000, 10, 37),
(22, 1600, 16, 35),
(23, 0, 0, 33),
(24, 1500, 15, 34),
(25, 1000, 10, 37),
(26, 1600, 16, 35),
(27, 0, 0, 28),
(28, 1500, 15, 34),
(29, 1000, 10, 37),
(30, 1600, 16, 35),
(31, 0, 0, 29),
(32, 1500, 15, 34),
(33, 1000, 10, 37),
(34, 1600, 16, 35),
(36, 1500, 15, 34),
(37, 1000, 10, 37),
(38, 1600, 16, 35),
(39, 2200, 22, 36),
(40, 1500, 15, 34),
(41, 1600, 16, 35),
(42, 2200, 22, 36),
(43, 1000, 10, 37),
(44, 1500, 15, 34),
(45, 1000, 10, 37),
(46, 1600, 16, 35),
(47, 2200, 22, 36),
(48, 1500, 15, 34),
(49, 1600, 16, 35),
(50, 2200, 22, 36),
(51, 1000, 10, 37),
(52, 1200, 6, 39),
(53, 1200, 6, 39);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rachunek_pobyt`
--

CREATE TABLE `rachunek_pobyt` (
  `NrPobytu` int(10) NOT NULL,
  `NrRachunku` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `rachunek_pobyt`
--

INSERT INTO `rachunek_pobyt` (`NrPobytu`, `NrRachunku`) VALUES
(1, 1),
(1, 4),
(18, 7),
(42, 10),
(42, 12),
(42, 13),
(45, 14),
(42, 16),
(45, 17),
(42, 18),
(42, 20),
(45, 21),
(43, 22),
(42, 24),
(45, 25),
(43, 26),
(42, 28),
(45, 29),
(43, 30),
(42, 32),
(45, 33),
(43, 34),
(42, 36),
(45, 37),
(43, 38),
(44, 39),
(42, 40),
(43, 41),
(44, 42),
(45, 43),
(42, 44),
(45, 45),
(43, 46),
(44, 47),
(42, 48),
(43, 49),
(44, 50),
(45, 51),
(47, 52),
(47, 53);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rezerwacja`
--

CREATE TABLE `rezerwacja` (
  `NrRezerwacji` int(10) NOT NULL,
  `PoczatekRezerwacji` date NOT NULL,
  `KoniecRezerwacji` date NOT NULL,
  `DataOperacji` date DEFAULT NULL,
  `FkKlient` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `rezerwacja`
--

INSERT INTO `rezerwacja` (`NrRezerwacji`, `PoczatekRezerwacji`, `KoniecRezerwacji`, `DataOperacji`, `FkKlient`) VALUES
(3, '2019-04-25', '2019-04-30', '2019-04-24', 2),
(4, '2019-04-25', '0000-00-00', '2019-04-24', 3),
(6, '2019-04-28', '2019-05-05', '2019-04-24', 3),
(7, '2019-04-28', '2019-05-05', '2019-04-24', 3),
(8, '2019-05-20', '2019-05-25', '2019-04-24', 2),
(9, '2019-05-11', '2019-05-13', '2019-05-05', 3),
(10, '2019-05-16', '2019-05-25', '2019-05-08', 3),
(12, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(13, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(14, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(15, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(16, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(17, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(18, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(19, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(20, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(21, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(22, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(23, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(24, '2019-12-15', '2019-12-15', '2019-05-08', 2),
(26, '2019-05-15', '2019-12-10', '2019-05-08', 3),
(27, '2019-05-15', '2019-12-13', '2019-05-08', 2),
(28, '2019-06-15', '2019-12-12', '2019-05-08', 3),
(29, '2019-09-15', '2019-12-19', '2019-05-08', 4),
(30, '2019-05-15', '2019-12-13', '2019-05-08', 5),
(31, '2019-04-15', '2019-12-15', '2019-05-08', 6),
(32, '2019-05-15', '2019-12-10', '2019-05-08', 3),
(33, '2019-05-15', '2019-12-13', '2019-05-08', 2),
(34, '2019-06-15', '2019-12-12', '2019-05-08', 3),
(35, '2019-09-15', '2019-12-19', '2019-05-08', 4),
(36, '2019-05-15', '2019-12-13', '2019-05-08', 5),
(37, '2019-04-15', '2019-12-15', '2019-05-08', 6),
(38, '2019-04-15', '2019-12-20', '2019-05-08', 7),
(39, '2019-02-15', '2019-12-15', '2019-05-08', 8),
(40, '2019-06-15', '2019-12-14', '2019-05-08', 9),
(41, '2019-07-15', '2019-12-15', '2019-05-08', 10),
(42, '2019-04-15', '2019-12-20', '2019-05-08', 11),
(43, '2019-06-15', '2019-12-15', '2019-05-08', 12),
(44, '2019-05-15', '2019-12-10', '2019-05-08', 3),
(45, '2019-05-15', '2019-12-13', '2019-05-08', 2),
(46, '2019-06-15', '2019-12-12', '2019-05-08', 3),
(47, '2019-09-15', '2019-12-19', '2019-05-08', 4),
(48, '2019-05-15', '2019-12-13', '2019-05-08', 5),
(49, '2019-04-15', '2019-12-15', '2019-05-08', 6),
(50, '2019-04-15', '2019-12-20', '2019-05-08', 7),
(51, '2019-02-15', '2019-12-15', '2019-05-08', 8),
(52, '2019-06-15', '2019-12-14', '2019-05-08', 9),
(53, '2019-07-15', '2019-12-15', '2019-05-08', 10),
(54, '2019-04-15', '2019-12-20', '2019-05-08', 11),
(55, '2019-06-15', '2019-12-15', '2019-05-08', 12),
(56, '2019-03-15', '2019-12-15', '2019-05-08', 13),
(57, '2019-02-15', '2019-12-15', '2019-05-08', 14),
(59, '2019-05-15', '2019-12-10', '2019-05-08', 3),
(60, '2019-05-15', '2019-12-13', '2019-05-08', 2),
(61, '2019-06-15', '2019-12-12', '2019-05-08', 3),
(62, '2019-09-15', '2019-12-19', '2019-05-08', 4),
(63, '2019-05-15', '2019-12-13', '2019-05-08', 5),
(64, '2019-04-15', '2019-12-15', '2019-05-08', 6),
(65, '2019-04-15', '2019-12-20', '2019-05-08', 7),
(66, '2019-02-15', '2019-12-15', '2019-05-08', 8),
(67, '2019-06-15', '2019-12-14', '2019-05-08', 9),
(68, '2019-07-15', '2019-12-15', '2019-05-08', 10),
(69, '2019-04-15', '2019-12-20', '2019-05-08', 11),
(70, '2019-06-15', '2019-12-15', '2019-05-08', 12),
(71, '2019-03-15', '2019-12-15', '2019-05-08', 13),
(72, '2019-02-15', '2019-12-15', '2019-05-08', 14),
(73, '2019-05-15', '2019-12-10', '2019-05-08', 3),
(74, '2019-05-15', '2019-12-13', '2019-05-08', 2),
(75, '2019-06-15', '2019-12-12', '2019-05-08', 3),
(76, '2019-09-15', '2019-12-19', '2019-05-08', 4),
(77, '2019-05-15', '2019-12-13', '2019-05-08', 5),
(78, '2019-04-15', '2019-12-15', '2019-05-08', 6),
(79, '2019-04-15', '2019-12-20', '2019-05-08', 7),
(80, '2019-02-15', '2019-12-15', '2019-05-08', 8),
(81, '2019-06-15', '2019-12-14', '2019-05-08', 9),
(82, '2019-07-15', '2019-12-15', '2019-05-08', 10),
(83, '2019-04-15', '2019-12-20', '2019-05-08', 11),
(84, '2019-06-15', '2019-12-15', '2019-05-08', 12),
(85, '2019-03-15', '2019-12-15', '2019-05-08', 13),
(86, '2019-02-15', '2019-12-15', '2019-05-08', 14);

--
-- Wyzwalacze `rezerwacja`
--
DELIMITER $$
CREATE TRIGGER `wstaw_date` BEFORE INSERT ON `rezerwacja` FOR EACH ROW BEGIN
	SET NEW.DataOperacji=NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rezerwacja_pokoj`
--

CREATE TABLE `rezerwacja_pokoj` (
  `NrRezerwacji` int(10) NOT NULL,
  `NrPokoju` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Zrzut danych tabeli `rezerwacja_pokoj`
--

INSERT INTO `rezerwacja_pokoj` (`NrRezerwacji`, `NrPokoju`) VALUES
(7, 1),
(8, 1),
(9, 1),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3),
(22, 3),
(23, 3),
(24, 3),
(26, 1),
(27, 2),
(28, 3),
(29, 4),
(30, 5),
(32, 1),
(33, 2),
(34, 3),
(35, 4),
(36, 5),
(37, 5),
(38, 1),
(39, 2),
(40, 3),
(41, 4),
(42, 5),
(44, 1),
(45, 2),
(46, 3),
(47, 4),
(48, 5),
(49, 5),
(50, 1),
(51, 2),
(52, 3),
(53, 4),
(54, 5),
(55, 5),
(56, 3),
(57, 4),
(59, 1),
(60, 2),
(61, 3),
(62, 4),
(63, 5),
(64, 5),
(65, 1),
(66, 2),
(67, 3),
(68, 4),
(69, 5),
(70, 5),
(71, 3),
(72, 4),
(73, 1),
(74, 2),
(75, 3),
(76, 4),
(77, 5),
(78, 5),
(79, 1),
(80, 2),
(81, 3),
(82, 4),
(83, 5),
(84, 5),
(85, 3),
(86, 4);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `wolne_ten_miasiac`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `wolne_ten_miasiac` (
`NrPokoju` int(10)
,`LiczbaMiejsc` int(10)
,`Pietro` int(10)
,`TypPokoju` varchar(15)
,`CenaPokoju` int(10)
);

-- --------------------------------------------------------

--
-- Struktura widoku `goscie_teraz`
--
DROP TABLE IF EXISTS `goscie_teraz`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `goscie_teraz`  AS  select `t2`.`NrKlienta` AS `NrKlienta`,`t2`.`ImieKlienta` AS `ImieKlienta`,`t2`.`ImieDrugie` AS `ImieDrugie`,`t2`.`NazwiskoKlienta` AS `NazwiskoKlienta` from (`pobyt` `t1` join `klient` `t2`) where ((`t2`.`NrKlienta` = `t1`.`FkKlient`) and (`t1`.`KoniecZameldowania` = NULL)) ;

-- --------------------------------------------------------

--
-- Struktura widoku `historia_rezerwacji`
--
DROP TABLE IF EXISTS `historia_rezerwacji`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `historia_rezerwacji`  AS  select `a`.`PoczatekRezerwacji` AS `PoczatekRezerwacji`,`a`.`KoniecRezerwacji` AS `KoniecRezerwacji`,`b`.`ImieKlienta` AS `ImieKlienta`,`b`.`ImieDrugie` AS `ImieDrugie`,`b`.`NazwiskoKlienta` AS `NazwiskoKlienta` from (`rezerwacja` `a` join `klient` `b` on((`a`.`NrRezerwacji` = `b`.`NrKlienta`))) ;

-- --------------------------------------------------------

--
-- Struktura widoku `hotel_dane`
--
DROP TABLE IF EXISTS `hotel_dane`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hotel_dane`  AS  select `t2`.`HotelNazwa` AS `HotelNazwa`,`t1`.`Miejscowosc` AS `Miejscowosc`,`t1`.`KodPocztowy` AS `KodPocztowy`,`t1`.`Ulica` AS `Ulica`,`t1`.`NrDomu` AS `NrDomu`,`t1`.`NrMieszkania` AS `NrMieszkania`,`t1`.`NrTelefonu` AS `NrTelefonu`,`t2`.`Email` AS `Email` from (`adres` `t1` join `hotel` `t2`) where (`t1`.`IdAdres` = `t2`.`FkAdres`) ;

-- --------------------------------------------------------

--
-- Struktura widoku `platnosc_pokoj`
--
DROP TABLE IF EXISTS `platnosc_pokoj`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `platnosc_pokoj`  AS  select `t1`.`FkKlient` AS `FkKlient`,`t1`.`Oplata` AS `Oplata`,`t1`.`CzasPobytu` AS `CzasPobytu`,`t2`.`PoczatekZameldowania` AS `PoczatekZameldowania`,`t2`.`KoniecZameldowania` AS `KoniecZameldowania` from ((`rachunek` `t1` join `pobyt` `t2`) join `rachunek_pobyt` `t3`) where ((`t1`.`NrRachunku` = `t3`.`NrRachunku`) and (`t2`.`NrPobytu` = `t3`.`NrPobytu`)) ;

-- --------------------------------------------------------

--
-- Struktura widoku `wolne_ten_miasiac`
--
DROP TABLE IF EXISTS `wolne_ten_miasiac`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `wolne_ten_miasiac`  AS  select `t1`.`NrPokoju` AS `NrPokoju`,`t1`.`LiczbaMiejsc` AS `LiczbaMiejsc`,`t1`.`Pietro` AS `Pietro`,`t1`.`TypPokoju` AS `TypPokoju`,`t1`.`CenaPokoju` AS `CenaPokoju` from ((`pokoj` `t1` join `rezerwacja` `t2`) join `rezerwacja_pokoj` `t3`) where ((`t1`.`NrPokoju` = `t3`.`NrPokoju`) and (`t2`.`NrRezerwacji` = `t3`.`NrRezerwacji`) and (month(`t2`.`PoczatekRezerwacji`) <> month(curdate())) and (`t1`.`DostepnyTeraz` = 'T')) ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adres`
--
ALTER TABLE `adres`
  ADD PRIMARY KEY (`IdAdres`);

--
-- Indeksy dla tabeli `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`Nazwa`),
  ADD KEY `FkAdres` (`FkAdres`);

--
-- Indeksy dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD PRIMARY KEY (`NrKlienta`),
  ADD KEY `ImiKliIdx` (`ImieKlienta`),
  ADD KEY `NazKli` (`NazwiskoKlienta`,`ImieKlienta`),
  ADD KEY `ImiDruIdx` (`ImieDrugie`) USING BTREE,
  ADD KEY `FkAdres` (`FkAdres`);

--
-- Indeksy dla tabeli `pobyt`
--
ALTER TABLE `pobyt`
  ADD PRIMARY KEY (`NrPobytu`),
  ADD KEY `PocZamIdx` (`PoczatekZameldowania`),
  ADD KEY `KonZamIdx` (`KoniecZameldowania`),
  ADD KEY `FkPokoj` (`FkPokoj`),
  ADD KEY `FkKlient` (`FkKlient`),
  ADD KEY `FkRezerwacja` (`FkRezerwacja`);

--
-- Indeksy dla tabeli `pokoj`
--
ALTER TABLE `pokoj`
  ADD PRIMARY KEY (`NrPokoju`),
  ADD KEY `FkNazwa` (`FkNazwa`);

--
-- Indeksy dla tabeli `rachunek`
--
ALTER TABLE `rachunek`
  ADD PRIMARY KEY (`NrRachunku`),
  ADD KEY `OplIdx` (`Oplata`),
  ADD KEY `CzaPobIdx` (`CzasPobytu`),
  ADD KEY `FkKlient` (`FkKlient`);

--
-- Indeksy dla tabeli `rachunek_pobyt`
--
ALTER TABLE `rachunek_pobyt`
  ADD KEY `NrPobytu` (`NrPobytu`),
  ADD KEY `NrRachunku` (`NrRachunku`);

--
-- Indeksy dla tabeli `rezerwacja`
--
ALTER TABLE `rezerwacja`
  ADD PRIMARY KEY (`NrRezerwacji`),
  ADD KEY `PocRezIdx` (`PoczatekRezerwacji`),
  ADD KEY `KonRezIdx` (`KoniecRezerwacji`),
  ADD KEY `FkKlient` (`FkKlient`);

--
-- Indeksy dla tabeli `rezerwacja_pokoj`
--
ALTER TABLE `rezerwacja_pokoj`
  ADD KEY `NrRezerwacji` (`NrRezerwacji`),
  ADD KEY `NrPokoju` (`NrPokoju`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `adres`
--
ALTER TABLE `adres`
  MODIFY `IdAdres` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT dla tabeli `hotel`
--
ALTER TABLE `hotel`
  MODIFY `Nazwa` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `klient`
--
ALTER TABLE `klient`
  MODIFY `NrKlienta` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT dla tabeli `pobyt`
--
ALTER TABLE `pobyt`
  MODIFY `NrPobytu` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT dla tabeli `pokoj`
--
ALTER TABLE `pokoj`
  MODIFY `NrPokoju` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT dla tabeli `rachunek`
--
ALTER TABLE `rachunek`
  MODIFY `NrRachunku` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT dla tabeli `rezerwacja`
--
ALTER TABLE `rezerwacja`
  MODIFY `NrRezerwacji` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`FkAdres`) REFERENCES `adres` (`IdAdres`);

--
-- Ograniczenia dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD CONSTRAINT `klient_ibfk_1` FOREIGN KEY (`FkAdres`) REFERENCES `adres` (`IdAdres`);

--
-- Ograniczenia dla tabeli `pobyt`
--
ALTER TABLE `pobyt`
  ADD CONSTRAINT `pobyt_ibfk_1` FOREIGN KEY (`FkKlient`) REFERENCES `klient` (`NrKlienta`),
  ADD CONSTRAINT `pobyt_ibfk_2` FOREIGN KEY (`FkPokoj`) REFERENCES `pokoj` (`NrPokoju`),
  ADD CONSTRAINT `pobyt_ibfk_3` FOREIGN KEY (`FkRezerwacja`) REFERENCES `rezerwacja` (`NrRezerwacji`);

--
-- Ograniczenia dla tabeli `pokoj`
--
ALTER TABLE `pokoj`
  ADD CONSTRAINT `pokoj_ibfk_1` FOREIGN KEY (`FkNazwa`) REFERENCES `hotel` (`Nazwa`);

--
-- Ograniczenia dla tabeli `rachunek`
--
ALTER TABLE `rachunek`
  ADD CONSTRAINT `rachunek_ibfk_1` FOREIGN KEY (`FkKlient`) REFERENCES `klient` (`NrKlienta`);

--
-- Ograniczenia dla tabeli `rachunek_pobyt`
--
ALTER TABLE `rachunek_pobyt`
  ADD CONSTRAINT `rachunek_pobyt_ibfk_1` FOREIGN KEY (`NrPobytu`) REFERENCES `pobyt` (`NrPobytu`),
  ADD CONSTRAINT `rachunek_pobyt_ibfk_2` FOREIGN KEY (`NrRachunku`) REFERENCES `rachunek` (`NrRachunku`);

--
-- Ograniczenia dla tabeli `rezerwacja`
--
ALTER TABLE `rezerwacja`
  ADD CONSTRAINT `rezerwacja_ibfk_1` FOREIGN KEY (`FkKlient`) REFERENCES `klient` (`NrKlienta`);

--
-- Ograniczenia dla tabeli `rezerwacja_pokoj`
--
ALTER TABLE `rezerwacja_pokoj`
  ADD CONSTRAINT `rezerwacja_pokoj_ibfk_1` FOREIGN KEY (`NrRezerwacji`) REFERENCES `rezerwacja` (`NrRezerwacji`),
  ADD CONSTRAINT `rezerwacja_pokoj_ibfk_2` FOREIGN KEY (`NrPokoju`) REFERENCES `pokoj` (`NrPokoju`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
