/*
#opgave 1 : Je maakt create-scripts die de tabellen aanmaken met voor elke kolom het bijpassende datatype.
*/
-- tabel Artiesten
drop table if exists Artiesten;
create table if not exists Artiesten(
Naam varchar(100),
Genre enum('rock', 'hiphop', 'country', 'pop'),
Jaar_oprichting date ,
Aantal_optredens tinyint unsigned          #ik heb tinyint gebruik omdat ik denk niet dat een persoon 10.000 keer heeft op een festival heeft gespeeld
);

-- tabel Songs
drop table if exists Songs;
create table if not exists Songs(
Artiest_Naam varchar(100),
Titel varchar(100),
Duurtijd smallint unsigned
);

-- tabel Daginndelingen
drop table if exists Dagindelingen;
create table if not exists Dagindelingen(
Datum date ,
Tijdstip time,
Artiest varchar(100)
);

################################################################################################################################################################################################

/*
#opgave 2: Bedenk nog 2 extra tabellen die nuttig kunnen zijn in de context van de organisatie van een
muziekfestival, elke tabel moet minstens 3 kolommen hebben. Schrijf hiervoor de nodige createscripts.
*/
# meneer,de tabellen hieronder heb ik overall not null gedaan ! om errors te voorkomen , bij opgave 1 heb ik zonder not null gedaan en alleen de bijpassende datataype toegevoegd.

-- tabel Tickets
drop table if exists Tickets;
create table if not exists Tickets(
Prijs tinyint unsigned not null,
Soort ENUM('delux', 'express', 'normaal') not null,
aantal int unsigned not null   
);

-- tabel Locatie
drop table if exists Locatie;
create table if not exists Locatie(
Naam varchar(100) not null,
Adress varchar(200) not null,
Capaciteit smallint unsigned not null 				
);

################################################################################################################################################################################################

/*
#opgave 3: Je maakt de nodige scripts om ervoor te zorgen dat elke tabel minstens 5 en maximum 10
bruikbare records heeft, zodat je deze kan gebruiken in de volgende opgaven. Gebruik je eigen
favoriete groepen en liedjes. Dit is je kans om jouw beste muziekfestival ooit samen te stellen!
*/

-- Tabel Artiesten

insert into Artiesten(Naam, Genre, Jaar_oprichting, Aantal_optredens) values
('YNG Martyr', 'hiphop', '2018-07-20', 5), 
('Caleb Gordon', 'pop', '2015-03-08', 7),
('Sleepy Hallow', 'hiphop', '2016-08-12', 3),
('Ariana Grande', 'pop', '2008-03-03', 0), #dit is om de select te proberen verder aan
('Tyga', 'hiphop', '2008-08-25', 0); #dit is om de select te proberen verder aan

-- Tabel Songs
#ik heb de duurtijd voor sommige overdreven veel gezet om vraag 10 te kunnen doen ! ! ! 
insert into Songs(Artiest_Naam, Titel, Duurtijd) values
('YNG Martyr', 'On My Way', 1280), 
('Caleb Gordon', 'Wishes', 1230),
('Caleb Gordon', 'Yesterday Is Gone', 1880),
('Caleb Gordon', 'Rocky Road', 1200),
('Sleepy Hallow', '2055', 2240),
('Tyger', 'Taste', 2180),
('Tyger', 'Colombia', 760),
('Ariana Grande', 'God Is a Man', 6240);

-- Tabel Dagindelingen
insert into Dagindelingen(Datum, Tijdstip, Artiest) values
('2023-09-25', '12:00:00', 'YNG Martyr'),
('2023-10-15', '15:00:00', 'Caleb Gordon'),
('2023-11-6', '18:00:00', 'Sleepy Hallow'),
('2023-12-27', '12:00:00', 'Ariana Grande'),
('2023-05-03', '15:00:00', 'Tyga');


-- Tabel Tickets
INSERT INTO Tickets (Prijs, Soort, aantal) VALUES
(100, 'delux', 100),
(75, 'express', 200),
(50, 'normaal', 300);

-- Tabel Locatie
# voor de andere naam locatie heb ik gewoon randoms gepakt van de internet.
INSERT INTO Locatie (Naam, Adress, Capaciteit) VALUES
('Rock Werchter', 'Kouter, 2220, Werchter, België', 60.000),
('Tomorrowland', 'Boom, België', 400.000),
('sportpaleis', 'Schouwburgstraat 1, 2018 Antwerpen', 75.000), #dit is sportpaleis ! 
('Lowlands', 'Biddinghuizen, Nederland', 50.000),
('Primavera Sound', 'Barcelona, Spanje', 200.000);

################################################################################################################################################################################################

/*
#Opgave 4: Schrijf 2 select queries waar minstens een where- en een order by-clausule in staat.
Bijvoorbeeld: selecteer alle artiesten die nog nooit op het festival zijn geweest, alfabetisch
geordend op naam.
*/
# selecteer alle artiesten die nog nooit op het festival zijn geweest, alfabeticsch geordend op naam.
SELECT Naam
FROM Artiesten
WHERE Aantal_optredens = 0
ORDER BY Naam ASC;

# selecteer alle adressen dat begin met B , niet alfabetisch geordend op Adress.
select Adress
 from Locatie
 where Adress LIKE 'B%'
 order by Adress Desc;

################################################################################################################################################################################################

/*
#opgave 5 : Schrijf een query die op zoek gaat naar liedjes waarvan de titel een bepaald stukje tekst bevat
(tip: Like).

*/

 # selecteer de liedje die begint met de letter a, zou 1 resultaten tonen, ik veronder stel dat met text u bedoeld zoals hieronder
select Titel
 from Songs
 where Titel LIKE '%Is a%'; 

################################################################################################################################################################################################

/*
#opgave 6: Schrijf een query die een kolom toevoegt aan de tabel met Artiesten, om de herkomst van de
band vast te leggen met twee tekst-tekens (bv. BE voor België, NL voor Nederland, etc.). 
*/

alter table Artiesten
add column herkomst varchar(2) not null default 'US'; #ze zijn allemaal van US, dus ga ik direct default 'US' = USA !

################################################################################################################################################################################################

/*
#opgave 7: Schrijf een query die voor alle Artiesten waarvoor de herkomst nog niet ingevuld werd (= NULL)
de waarde 'BE' wordt ingevuld.
*/

UPDATE Artiesten 						#het werkt, maar aangezien ik default 'US' heb gedaan, zou niks moeten veranderen!
SET herkomst = 'BE'
WHERE herkomst IS NULL;

################################################################################################################################################################################################
/*
#opgave 8 : Schrijf een query die de titel en de duurtijd van de songs toont, maar enkel voor de songs
waarvan de titel minimaal 20 teksttekens bevat.
*/

	#opletten, ik heb naam veranderd naar Titel bij het creatie. want was te veel verwaring voor mij overal.
    #aangezien de liedjes die ik leuk vind hebben geen lange titel. ga ik in commentaar zetten een andere query.
    
SELECT Titel, Duurtijd
FROM Songs
WHERE LENGTH(Titel) >= 20;  #opletten meneer : veranderd de >= naar <= en je zou een paar resultaten moeten zien meneer.

################################################################################################################################################################################################
/*
#opgave 9: Schrijf een query die alle genres van artiesten bij elkaar groepeert en een overzicht geeft van
hoeveel artiesten er zijn van een bepaald genre.
*/
SELECT Genre, COUNT(*) AS aantal_genress
FROM Artiesten
GROUP BY Genre;

################################################################################################################################################################################################
/*
#opgave 10: Schrijf een query die per artiest toont wat de som is van de duurtijd van al zijn liedjes (tip:
groeperen). Toon enkel die artiesten waarvan de naam de letter ‘a’ NIET bevat, en die minstens
1000 seconden aan liedjes in de database hebben. Voeg een passende sortering toe.

*/
#dit zou niks geven want, meeste artiesten hebben a op hun naam, verander de %a% naar %e% 
SELECT Artiest_Naam, SUM(Duurtijd) AS Totale_Duurtijd
FROM Songs
WHERE Artiest_Naam NOT LIKE '%a%'  -- %e% <<== dit om te testen.
GROUP BY Artiest_Naam
HAVING SUM(Duurtijd) >= 1000
ORDER BY Totale_Duurtijd DESC 
