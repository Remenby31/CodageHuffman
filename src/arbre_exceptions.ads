-- DÃ©finition d'une exception commune Ã  toutes les SDA.
package Arbre_Exceptions is

	Cle_Absente_Exception  : Exception;	-- un caractere est absente d'une cellule
   Suppression_impossible_Exception : Exception; -- On ne peux pas supprimer une branche liÃ©e Ã  deux Fils
   Cle_Necessaire_Pour_Fils_Exception   : Exception; --Il faut d'abord Enregistrer une clé avant d'ajouter un Fils.
   arbre_Vide_Exception : Exception; -- La cellule est vide, donc il n'y a pas de donnée
end Arbre_Exceptions;
