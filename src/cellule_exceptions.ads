-- Définition d'une exception commune à toutes les SDA.
package Cellule_Exceptions is

	Cle_Absente_Exception  : Exception;	-- un caractere est absente d'une cellule
   Suppression_impossible_Exception : Exception; -- On ne peux pas supprimer une branche liée à deux Fils
   Besoin_Cle_Pour_Fils   : Exception; --Il faut d'abord Enregistrer une clef avant d'jouter un Fils.
end Cellule_Exceptions;
