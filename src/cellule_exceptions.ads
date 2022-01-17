-- Définition d'une exception commune à toutes les SDA.
package Cellule_Exceptions is

	Cle_Absente_Exception  : Exception;	-- un caractere est absente d'une cellule
   Suppression_impossible_Exception : Exception; -- On ne peux pas supprimer une branche liée à deux Fils
   Cle_Necessaire_Pour_Fils_Exception   : Exception; --Il faut d'abord Enregistrer une cl� avant d'ajouter un Fils.
   Cellule_Vide_Exception : Exception; -- La cellule est vide, donc il n'y a pas de donn�e
end Cellule_Exceptions;
