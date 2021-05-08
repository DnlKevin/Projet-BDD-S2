/*Liste des bénévoles et de leur âge, ainsi que les événements auxquels ils ont participés*/
SELECT nom, prenom, datenaiss, idevenement, (DATEDIFF (YEAR,CURDATE(),(datenaiss))) AS age
FROM PERSONNE, BENEVOLE, EVENEMENT
WHERE PERSONNE.idpersonne = BENEVOLE.idpersonne
AND BENEVOLE.idevenement = EVENEMENT.idevenement;

/*Montant des prestations réglées aux artistes entre deux dates données*/
SELECT DISTINCT(cachetartiste), nom, prenom
FROM PERSONNE, ARTISTE, CACHET
WHERE PERSONNE.idpersonne = ARTISTE.idpersonne
AND ARTISTE.idartiste = CACHET.idartiste
AND (DATEDIFF (‘2019-12-21’, ‘2020-06-13’)) AS periode ;


/*Afficher le nombre de places disponibles pour un événement*/
SELECT COUNT(DISTINCT(idticket))
FROM EVENEMENT, SPECTACLE, TICKET
WHERE EVENEMENT.idevenement = SPECTACLE.idevenement
AND SPECTACLE.idspectacle = TICKET.idspectacle
AND statut.ticket = ‘disponible’;


/*Afficher le nombre de minutes, d’heures, de jours, de mois et d’années avant le début
d’un événement*/
SELECT idspectacle, horairedatetime, idevenement
FROM EVENEMENT, SPECTACLE
WHERE EVENEMENT.idevenement = SPECTACLE.idevenement
AND TIMESTAMPDIFF(NOW(), (horairedatetime)) 
Order by horairedatetime ASC
LIMIT 1;


/*Afficher les événements par ordre de meilleures ventes, avec les sommes collectées au total d’une part, et le bénéfice réalisé d’autre part (après paiement des artistes)
*/
SELECT idevenement, (COUNT(idticket) * typetarif) AS SommesCollectees, ((COUNT(idticket) * typetarif) – SUM(cachetartiste)) AS Benefice
FROM CACHET, SPECTACLE, EVENEMENT, TARIF, TICKET
WHERE EVENEMENT.idevenement = SPECTACLE.idevenement
AND TARIF.typetarif = SPECTACLE.typetarif
AND SPECTACLE.idartiste = ARTISTE.idartiste
AND SPECTACLE.idspectacle = TICKET.idspectacle ;


/*Proposer une requête d’insertion d’un événement composé de 7 spectacles qui utilisent les 3 salles. Elle peut être composée de plusieurs requêtes et ne doit pas imposer d’identifiant ( == elle doit pouvoir fonctionner sans tenir compte des identifiants des autres événements ou spectacles)
*/
INSERT INTO EVENEMENT (idevenement, statutevenement, idspectacle)
VALUES
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AA_aperitif’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AB_presentation’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AC_ouverture’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AD_concert’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AE_diner’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AI_after-party’),
(‘3E2_Nuit Blanche’, ‘programmée’, ‘28AF_dance’) 
WHERE EVENEMENT.idevenement = SALLE.idevenement


/*Les salaires annuels des salariés pour une année donnée*/
SELECT idsalarie, DISTINCT(salaire) 
FROM SALARIE
WHERE DATEDIFF(YEAR(‘YYYY-MM-DD’, ‘YYYY-MM-DD’);


/*Les ventes d’un événement classées par tarif (tarifs plein, jeune, etc.)*/
SELECT idevenement, typetarif
FROM EVENEMENT, TARIF, SPECTACLE
WHERE EVENEMENT.idevenement = SPECTACLE.idevenement
AND TARIF.typetarif = SPECTACLE.typetarif
ORDER BY typetarif;


/*Les pourcentages de types de spectacle pour une année donnée*/
SELECT (COUNT(DISTINCT(typespec)) / COUNT(idspectacle) * 100) AS Pourcentage
FROM SPECTACLE
WHERE DATEDIFF(YEAR(‘2019-05-21’, ‘2020-05-21’);


/*Les événements annulés ainsi que le montant des tickets remboursés*/
SELECT idevenement, SUM(prix)
FROM EVENEMENT, TICKET
WHERE statutevent = 'annule'
AND statutticket = 'rembourse' IN 
(SELECT idticket
FROM TICKET
WHERE TICKET.idspectacle = SPECTACLE.idspectacle
AND SPECTACLE.idevenement = EVENEMENT.idevenement);
