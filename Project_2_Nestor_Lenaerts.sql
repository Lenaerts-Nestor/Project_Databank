drop database student_server;
create database student_server;

use student_server;


-- tabellen verwijderen => 
drop table if exists DagIndelingen;
drop table if exists FestivalEdties;
drop table if exists Artiesten;
drop table if exists Songs;
drop table if exists Locatie;
drop table if exists Tickets;
/*
-- tabelen op basis van de foto van de opdracht 
*/
create table Artiesten(
Id INT primary key auto_increment,
Naam varchar(100) not null,
Genre enum('rock', 'hiphop', 'country', 'pop'),
Herkomst varchar(2)
);
create table FestivalEdties(
Id INT primary key auto_increment,
TitelEditie varchar(45) not null,
StartDatum date not null,
EindDatum date
);
create table DagIndelingen(
Id INT primary key auto_increment,
StartOptreden Datetime not null,
Artiesten_Id Int,
FestivalEdities_Id INT,	

-- FK's hier
foreign key (Artiesten_Id) References Artiesten(Id),
foreign key (FestivalEdities_Id) References FestivalEdties(Id)

);
create table Songs(
Id INT primary key auto_increment,
Titel varchar(100) not null,
Artiesten_Id INT,
foreign key (Artiesten_Id) References Artiesten(Id)
);

#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************

/*1) Schrijf de nodige CREATE scripts om het verbeterde model te implementeren, en schrijf scripts
om de nodige relaties te leggen (foreign key constraints). Voeg ook aan deze verbeterde festivaldatabase 2 zelfgekozen tabellen toe die nuttig kunnen zijn in de context van de organisatie van
een muziekfestival. Tussen de twee tabellen moet een 1-op-veel relatie bestaan.
*/

-- een locatie heeft veel festivals, maar een festival heef 1 locatie tergelijk. BV: TOMORROWLAND OFZO
create table if not exists Locatie(
Id Int primary key auto_increment,
Adress varchar(200) not null,
Capaciteit smallint unsigned,
FestivalEdities_Id INT,

-- FK 
foreign key (FestivalEdities_Id) References FestivalEdties(Id)
);

create table if not exists Tickets(
Id Int Primary key auto_increment,
Prijs tinyint unsigned not null,
Soort ENUM('delux', 'express', 'normaal') not null,
aantal_verkocht int unsigned ,
Artiesten_Id Int,
Locatie_Id int,

-- FK
foreign key (Artiesten_Id) References Artiesten(Id),
foreign key (Locatie_Id) References Locatie(Id)
);


#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************

/* 2) Schrijf de nodige INSERT-scripts om ervoor te zorgen dat elke tabel minstens 5 bruikbare records
heeft, zodat je deze kan gebruiken in de volgende opgaven. Gebruik je eigen favoriete groepen
en liedjes

*/

INSERT INTO Artiesten (Naam, Genre, Herkomst)
VALUES ('Caleb Gordon', 'hiphop', 'UK'),
('Jennie', 'hiphop', 'BE'),
('Hott Headzz', 'country', 'BE'),
('Tyga', 'pop', 'IN'),
('Big Yavo', 'pop', 'UK'),
('testvraag10', 'pop', 'UK');


-- ik weet amper iets van festival dus ik ga het simple houden => 

INSERT INTO FestivalEdties(TitelEditie, StartDatum, EindDatum) 
VALUES ('festival1', '2023-08-01', '2023-08-03'),
('festival2', '2021-08-01', '2022-10-03'),
('festival3', '2018-07-01', '2018-08-07'),
('festival4', '2007-06-01', '2007-09-02'),
('festival5', '2002-03-01', '2002-04-01');

-- zelfde hier, 
INSERT INTO DagIndelingen (StartOptreden, Artiesten_Id, FestivalEdities_Id) 
VALUES('2023-08-01', 1, 1),
('2023-07-11', 2, 1),
('2021-08-01', 2, 2),
('2018-07-01', 3, null),
('2007-06-01', 4, 4),
('2002-03-01', 5, null),
('2020-03-01', 5, null);
-- hier merkt u dat ik niet artiest_id 6 heb ingevult om uw vraag 10 te kunnen doen ! 


INSERT INTO Songs (Titel, Artiesten_Id) 
VALUES ('Yesterday was gone', 1),
('You & me', 2),
('Hmmm, Pt.2', 3),
('sketchers', 4),
('HIM', 5),
('TESTSONG', 6);

INSERT INTO Locatie ( Adress, Capaciteit, FestivalEdities_Id) 
Values ( "langegasthuisstraat", 20000,'1'),
( 'ellermanstraat', 7000, 2),
( 'bisschoppenhoflaan', 3000, 3),
( 'kelynstraat', null, 4),
( 'antwerpenstraat', 5000, 5);

Insert into Tickets ( Prijs, Soort, Aantal_verkocht, Artiesten_Id, Locatie_Id) 
Values 
-- CALEB o.o
(40, 'delux', 11000, 1,1),
(70, 'express', 2000, 1,1),
(30, 'normaal', 7000, 1,1),
-- YENNIE :D
(35, 'delux', 1500, 2,2),
(20, 'express', 200, 2,2),
(15, 'normaal', 2000, 2,3),
(75, 'delux', 1700, 2,1),
(80, 'express', 3050, 2,2),
(51, 'normaal', 7000, 2,1),
-- Hots 
(10, 'normaal', 1050, 3,1),
-- Tyga 
(20, 'normaal', 2000,4,3),
(45, 'delux', 750, 4,3),
-- YAVO
(50, 'normaal', 1000, 5,5),
(70, 'express', 1025, 5 , 5);



/* select all om te zien 

select * from student_server.artiesten;
SELECT * FROM student_server.dagindelingen;
SELECT * FROM student_server.festivaledties;
SELECT * FROM student_server.locatie;
SELECT * FROM student_server.songs;
SELECT * FROM student_server.tickets;

*/


#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************
#************************************************************************************************************************************************************************

/* 3) Schrijf een zinvolle SELECT-query op je twee zelfgekozen tabellen, gebruikmakend van een join.
Leg in commentaar uit wat je precies wenst weer te geven met de resultatentabel die deze query
produceert.
*/

/*we willen zien per locatie hoeveel fans zijn gekomen bij elke artiest, om te zien als we kleinere of grotere locaties willen nemen voor een of andere artiest
dus om geld te besparen bij het huren van een locatie, dus als een artiest maar 1000 mensen inbrengt bij een locatie van 20.000 dat is niet goed, dus dit is om te checken ! 
we gebruiken 3 tabelen, de artiest, de locatie en de tickets !
 
 */

SELECT 
    artiesten.Naam, 
    CONCAT(UPPER(SUBSTRING(locatie.Adress, 1, 1)), SUBSTRING(locatie.Adress, 2)) as 'Adress', -- dit is om de straat netjes te tonen met hoofletters
    SUM(tickets.aantal_verkocht) as 'totaal_verkocht',
     locatie.Capaciteit as 'initiele_capaciteit',
    locatie.Capaciteit - SUM(tickets.aantal_verkocht) as 'overgebleven_capaciteit'
FROM 
    tickets
INNER JOIN locatie ON tickets.Locatie_Id = locatie.Id
INNER JOIN artiesten ON tickets.Artiesten_Id = artiesten.Id
GROUP BY 
    artiesten.Naam, locatie.Adress, locatie.Capaciteit;
    
#************************************************************************************************************************************************************************


/* 4) Schrijf een zinvolle SELECT-query op één van je zelfgekozen tabellen, waarbij je gebruik maakt
van een subquery. Leg in commentaar uit wat je precies wenst weer te geven met de
resultatentabel die deze query produceert
*/


-- we willen zien welke artiest de staduim heeft helemaal volgemaakt.
select
	artiesten.Naam,
	CONCAT(UPPER(SUBSTRING(locatie.Adress, 1, 1)), SUBSTRING(locatie.Adress, 2)) as 'Adress',
	SUM(tickets.aantal_verkocht) as 'totaal_verkocht'
from
	tickets
inner join locatie on tickets.Locatie_Id = locatie.Id
inner join artiesten on tickets.Artiesten_Id = artiesten.Id
where
	artiesten.Id in (
		select
			tickets.Artiesten_Id
		from
			tickets
		group by
			tickets.Artiesten_Id
		having
			SUM(tickets.aantal_verkocht) = locatie.Capaciteit
		and
			tickets.Locatie_Id = locatie.Id
	)
group by
	artiesten.Naam, locatie.Adress, locatie.Capaciteit;
    
    
#************************************************************************************************************************************************************************

/* 5) Schrijf een SELECT-query die berekent hoeveel songs we in onze database hebben van artiesten
die niet uit België komen (dus met een Herkomst die niet ‘BE’ is).
*/

select count(*) as 'aantal_songs'
from artiesten
where
	Herkomst != 'BE';

#************************************************************************************************************************************************************************


/*6. Maak een overzicht van FestivalEdities waarvoor nog geen DagIndelingen geregistreerd werden. */

SELECT
	festivaledties.TitelEditie,
	festivaledties.StartDatum,
	festivaledties.EindDatum
FROM
	festivaledties
LEFT JOIN
	dagindelingen
ON
	festivaledties.Id = dagindelingen.FestivalEdities_Id
WHERE
	dagindelingen.Id IS NULL;

#************************************************************************************************************************************************************************


/*7. Maak een query die voor een bepaalde editie het programmaoverzicht toont, door telkens de
datum en tijd van de start van het optreden te tonen, samen met de naam van de artiest,
gesorteerd op startdatum van het optreden. Voor welke editie je dit doet, mag je vastleggen in je
query.
*/

SELECT
	DATE_FORMAT(dagindelingen.StartOptreden, '%Y-%m-%d') as OptredingDAG, -- dit zou netjetjers eruit zien
	artiesten.Naam
FROM
	dagindelingen
INNER JOIN
	artiesten
ON
	dagindelingen.Artiesten_Id = artiesten.Id
WHERE
	dagindelingen.FestivalEdities_Id = 1
ORDER BY
	dagindelingen.StartOptreden;
    
    
#************************************************************************************************************************************************************************

/*8. Geef je persoonlijke top 3 (volgorde maakt niet uit) beste liedjes allertijden met de naam van de
artiest en de naam van het liedje.
*/

select 
	artiesten.Naam,
    songs.Titel
from 
	artiesten
inner join songs on artiesten_Id = artiesten.Id
where artiesten.Naam = 'Caleb Gordon' OR artiesten.Naam = 'Jennie' or artiesten.Naam ='Big Yavo';


#************************************************************************************************************************************************************************

/*9. Geef een overzicht van hoeveel artiesten er van een bepaald genre kwamen optreden op een bepaalde editie (voorbeeld: hoeveel rock-artiesten er kwamen in het jaar 2023).*/
select
	Naam,
	count(*) as 'Aantal',
    Genre
from artiesten
inner join dagindelingen on artiesten.Id = dagindelingen.artiesten_Id
where dagindelingen.FestivalEdities_Id = 1
group by Genre, artiesten.Naam;


/*10. Toon van alle artiesten hoe vaak ze op ons festival gespeeld hebben en zorg ervoor dat met
dezelfde query ook de artiesten getoond worden die nog nooit op ons festival gespeeld hebben.*/

SELECT
	artiesten.Naam,
	COUNT(DISTINCT dagindelingen.StartOptreden) as Aantal_gespeeld
FROM
	artiesten
LEFT JOIN
	dagindelingen
ON
	artiesten.Id = dagindelingen.Artiesten_Id
GROUP BY
	artiesten.Id
ORDER BY
	Aantal_gespeeld DESC;
