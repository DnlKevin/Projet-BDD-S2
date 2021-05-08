/*1. Un événement peut-être annulé, mais il ne peut pas être supprimé de la base de
données, et un ticket vendu peut-être remboursé, mais pas supprimé*/

DELIMITER |
CREATE TRIGGER after_insert_evenement AFTER INSERT
ON Evenement FOR EARCH ROW
BEGIN
IF (DELETE from EVENEMENT where statutevenement = ‘annulé’)
Then abort();
END IF;
End |
DELIMITER ;

/*Pour tester :*/
DELETE FROM EVENEMENT
WHERE statutevenement = ‘annulé’ ;

/*2. Vérifier qu’un événement ou un spectacle ne peut pas être créé si un autre événement ou spectacle utilise déjà une des salles sur le même créneau
*/
DELIMITER |
CREATE TRIGGER before_update_spectacle BEFORE UPDATE
ON Spectacle FOR EARCH ROW
BEGIN
IF (NEW.horairedatetime = OLD.horairedatetime)
Then abort();
END IF;
End |

DELIMITER ;

/*Pour tester :*/
INSERT INTO spectacle (horairedatetime, idsalle)
VALUES
(‘2020-12-12 19:00:00’, 2),
(‘2020-12-12 19:00:00’, 2),
(‘2020-12-12 19:00:00’, 3),
(‘2020-12-12 19:00:00’, 1) ;

/*3. Un bénévole ne peut-être assigné qu’à un seul responsable par événement
*/
/*4. On ne peut pas vendre plus de tickets que disponible pour un événement par rapport aux capacités des salles utilisées
*/
check(IDSALLE is NULL or IDSALLE in (‘S1’, ‘S2’, ‘S3’)),
check(IDSALLE&lt;&gt;’S1’ or IDSALLE is NULL or NBPLACES &lt;=50),
check(IDSALLE&lt;&gt;’S2’ or IDSALLE is NULL or NBPLACES &lt;=100),
check(IDSALLE&lt;&gt;’S3’ or IDSALLE is NULL or NBPLACES &lt;=300) ;

/*Pour tester :
On peut insérer dans la table TICKET(statutticket = disponible) plus de 50/100/300 lignes en le mettant toutes ou avec une boucle WHILE pour voir que la contrainte statique(prédicat CHECK) arrête l’exécution au moment qu’un nombre de lignes dépasse le nombre de places pour chacune de 3 salles.
5. Les tickets réservés mais non payés doivent redevenir disponibles 15min avant le début d’un événement
*/
DELIMITER |
CREATE TRIGGER before_update_ticket BEFORE UPDATE
ON Ticket FOR EARCH ROW
BEGIN
IF (OLD.statutticket = ‘réservé’ AND New.statutticket = ‘non reglé’
AND MINUTE(horairedatetime) - CURTIME() &lt;= 15)
Then UPDATE(statutticket =’disponible’);
END IF;
End |
DELIMITER ;
/*Pour tester :*/
SELECT CURTIME()
UPDATE ticket
SET statutticket = ‘non reglé’
Horairedatetime = ’20:10:00’;
/*Si l’heure actuelle est diffèrent de l’heure du début de spectacle de moins de 15 minutes, le trigger va se déclencher.
*/