with Arbre_Exceptions;         use Arbre_Exceptions;
with Ada.Unchecked_Deallocation;

package body Arbre is

   procedure Free is
     new Ada.Unchecked_Deallocation (Object => T_Element, Name => T_Arbre);

   procedure Initialiser(Arbre: out T_Arbre) is
   begin
      Arbre := NULL;
   end Initialiser;

   function Est_Vide (Arbre : in T_Arbre) return Boolean is
   begin
      if Arbre = NULL then
         return True;
      end if;
      return False;
   end;

   -- Obtenir le nombre d'�l�ments d'une Cellule.
   function Taille (Arbre : in T_Arbre) return Integer is
   begin
      if Est_Vide(Arbre) then
         return 0;
      else
         return 1 + Taille(Arbre.all.Fils_droit) + Taille(Arbre.all.Fils_gauche);
      end if;
   end Taille;

   procedure Vider(Arbre : in out T_Arbre) is
   begin
      if Est_Vide(Arbre) then
         Null;
      else
         Vider(Arbre.all.Fils_droit);
         Vider(Arbre.all.Fils_gauche);
         Free(Arbre);
      end if;
   end Vider;

   function Est_Feuille(Arbre : in T_Arbre) return Boolean is
   begin
      if Est_Vide(Arbre.all.Fils_droit) and Est_Vide(Arbre.all.Fils_gauche) then
         return True;
      end if;
      return False;
   end Est_Feuille;

   function Cle_Presente(Arbre : in T_Arbre ; Cle : in T_Cle) return Boolean is
   begin
      if Est_Vide(Arbre) then
         return False;
      elsif Arbre.all.Cle = Cle then
         return True;
      else
         return Cle_Presente(Arbre.all.Fils_droit,Cle) or Cle_Presente(Arbre.all.Fils_gauche,Cle);
      end if;
   end Cle_Presente;

   function La_Donnee(Arbre : in T_Arbre ; Cle : in T_Cle) return T_Donnee is
   begin
      if Est_Vide(Arbre) then
         raise Cle_Absente_Exception;
      elsif Arbre.All.Cle = Cle then
         return Arbre.all.Donnee;
      elsif Cle_Presente(Arbre.all.Fils_gauche, Cle) then
         return La_Donnee(Arbre.All.Fils_gauche, Cle);
      else
         return La_Donnee(Arbre.All.Fils_droit, Cle);
      end if;
   end La_Donnee;

   function La_Donnee_Direct(Arbre : in T_Arbre) return T_Donnee is
   begin
      if Est_Vide(Arbre) then
         raise Arbre_Vide_Exception;
      else
         return Arbre.All.Donnee;
      end if;
   end La_Donnee_Direct;

   function La_Cle_Direct(Arbre : in T_Arbre) return T_Cle is
   begin
      if Est_Vide(Arbre) then
         raise Arbre_Vide_Exception;
      else
         return Arbre.All.Cle;
      end if;
   end La_Cle_Direct;


   procedure Enregistrer(Arbre : in out T_Arbre ; Cle : in T_Cle ; Donnee : in T_Donnee) is

   begin
      if Arbre = null then
         Arbre := new T_Element'(Cle,Donnee, null, null);
      elsif Arbre.All.Cle = Cle then
         Arbre.All.Donnee := Donnee;
      else
         Enregistrer(Arbre.All.Fils_droit, Cle, Donnee);
      end if;
   end Enregistrer;

   procedure Enregistrer_FilsDroit(Arbre_parent : in out T_Arbre; Arbre_fils : in T_Arbre) is
   begin
      if Est_Vide(Arbre_parent) then
         raise Cle_Necessaire_Pour_Fils_Exception;
      else
         Arbre_parent.All.Fils_droit := Arbre_fils;
      end if;
   end Enregistrer_FilsDroit;

   procedure Enregistrer_FilsGauche(Arbre_parent : in out T_Arbre; Arbre_fils : in T_Arbre) is
   begin
      if Est_Vide(Arbre_parent) then
         raise Cle_Necessaire_Pour_Fils_Exception;
      else
         Arbre_parent.All.Fils_gauche := Arbre_fils;
      end if;
   end Enregistrer_FilsGauche;



   Procedure Supprimer(Arbre : in out T_Arbre ; Cle : in T_Cle) is
      A_Supprimer : T_Arbre;
   begin
      if Est_Vide(Arbre) then
         raise Cle_Absente_Exception;
      elsif Arbre.All.Cle = Cle then
         if not(Est_Vide(Arbre.All.Fils_droit)) and not(Est_Vide(Arbre.All.Fils_gauche)) then
            raise Suppression_impossible_Exception;
         else
            A_Supprimer := Arbre;
            if Est_Vide(Arbre.All.Fils_droit) then
               Arbre := Arbre.All.Fils_gauche;
            else
               Arbre := Arbre.All.Fils_droit;
            end if;
         end if;
         Free(A_Supprimer);
      elsif Cle_Presente(Arbre.All.Fils_gauche,Cle) then
         Supprimer(Arbre.all.Fils_gauche,Cle);
      elsif Cle_Presente(Arbre.All.Fils_droit,Cle) then
         Supprimer(Arbre.all.Fils_droit,Cle);
      else
         raise Cle_Absente_Exception;
      end if;

   end Supprimer;

   procedure Parcours_Infixe(Arbre : in out T_Arbre) is
   begin
      if not(Est_Vide(Arbre)) then
         if not(Est_Vide(Arbre.all.Fils_gauche)) then
            Parcours_Infixe(Arbre.all.Fils_gauche);
         end if;
         Traiter(Arbre.all.Cle, Arbre.all.Donnee);
         if not(Est_Vide(Arbre.all.Fils_droit)) then
            Parcours_Infixe(Arbre.all.Fils_droit);
         end if;
      end if;
   end Parcours_Infixe;

end Arbre;
