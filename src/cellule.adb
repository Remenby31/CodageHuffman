with Cellule_Exceptions;         use Cellule_Exceptions;
with Ada.Unchecked_Deallocation;

package body Cellule is

   procedure Free is
     new Ada.Unchecked_Deallocation (Object => T_Element, Name => T_Cellule);

   procedure Initialiser(Cellule: out T_Cellule) is
   begin
      Cellule := NULL;
   end Initialiser;

   function Est_Vide (Cellule : in T_Cellule) return Boolean is
   begin
      if Cellule = NULL then
         return True;
      end if;
      return False;
   end;

   -- Obtenir le nombre d'�l�ments d'une Cellule.
   function Taille (Cellule : in T_Cellule) return Integer is
   begin
      if Est_Vide(Cellule) then
         return 0;
      else
         return 1 + Taille(Cellule.all.Fils_droit) + Taille(Cellule.all.Fils_gauche);
      end if;
   end Taille;

   procedure Vider(Cellule : in out T_Cellule) is
   begin
      if Est_Vide(Cellule) then
         Null;
      else
         Vider(Cellule.all.Fils_droit);
         Vider(Cellule.all.Fils_gauche);
         Free(Cellule);
      end if;
   end Vider;

   function Est_Feuille(Cellule : in T_Cellule) return Boolean is
   begin
      if Est_Vide(Cellule.all.Fils_droit) and Est_Vide(Cellule.all.Fils_gauche) then
         return False;
      end if;
      return True;
   end Est_Feuille;

   function Cle_Presente(Cellule : in T_Cellule ; Cle : in T_Cle) return Boolean is
   begin
      if Est_Vide(Cellule) then
         return False;
      elsif Cellule.all.Cle = Cle then
         return True;
      else
         return Cle_Presente(Cellule.all.Fils_droit,Cle) or Cle_Presente(Cellule.all.Fils_gauche,Cle);
      end if;
   end Cle_Presente;

   function La_Donnee(Cellule : in T_Cellule ; Cle : in T_Cle) return T_Donnee is
   begin
      if Est_Vide(Cellule) then
         raise Cle_Absente_Exception;
      elsif Cellule.All.Cle = Cle then
         return Cellule.all.Donnee;
      elsif Cle_Presente(Cellule.all.Fils_gauche, Cle) then
         return La_Donnee(Cellule.All.Fils_gauche, Cle);
      else
         return La_Donnee(Cellule.All.Fils_droit, Cle);
      end if;
   end La_Donnee;

   function La_Donnee_Direct(Cellule : in T_Cellule) return T_Donnee is
   begin
      if Est_Vide(Cellule) then
         raise Cellule_Vide_Exception;
      else
         return Cellule.All.Donnee;
      end if;
   end La_Donnee_Direct;

   function La_Cle_Direct(Cellule : in T_Cellule) return T_Cle is
   begin
      if Est_Vide(Cellule) then
         raise Cellule_Vide_Exception;
      else
         return Cellule.All.Cle;
      end if;
   end La_Cle_Direct;


   procedure Enregistrer(Cellule : in out T_Cellule ; Cle : in T_Cle ; Donnee : in T_Donnee) is

   begin
      if Cellule = null then
         Cellule := new T_Element'(Cle,Donnee, null, null);
      elsif Cellule.All.Cle = Cle then
         Cellule.All.Donnee := Donnee;
      else
         Enregistrer(Cellule.All.Fils_droit, Cle, Donnee);
      end if;
   end Enregistrer;

   procedure Enregistrer_FilsDroit(Cellule_parent : in out T_Cellule; Cellule_fils : in T_Cellule) is
   begin
      if Est_Vide(Cellule_parent) then
         raise Cle_Necessaire_Pour_Fils_Exception;
      else
         Cellule_parent.All.Fils_droit := Cellule_fils;
      end if;
   end Enregistrer_FilsDroit;

   procedure Enregistrer_FilsGauche(Cellule_parent : in out T_Cellule; Cellule_fils : in T_Cellule) is
   begin
      if Est_Vide(Cellule_parent) then
         raise Cle_Necessaire_Pour_Fils_Exception;
      else
         Cellule_parent.All.Fils_gauche := Cellule_fils;
      end if;
   end Enregistrer_FilsGauche;


   Procedure Supprimer(Cellule : in out T_Cellule ; Cle : in T_Cle) is
      A_Supprimer : T_Cellule;
   begin
      if Est_Vide(Cellule) then
         raise Cle_Absente_Exception;
      elsif Cellule.All.Cle = Cle then
         if not(Est_Vide(Cellule.All.Fils_droit)) and not(Est_Vide(Cellule.All.Fils_gauche)) then
            raise Suppression_impossible_Exception;
         else
            A_Supprimer := Cellule;
            if Est_Vide(Cellule.All.Fils_droit) then
               Cellule := Cellule.All.Fils_gauche;
            else
               Cellule := Cellule.All.Fils_droit;
            end if;
         end if;
         Free(A_Supprimer);
      elsif Cle_Presente(Cellule.All.Fils_gauche,Cle) then
         Supprimer(Cellule.all.Fils_gauche,Cle);
      elsif Cle_Presente(Cellule.All.Fils_droit,Cle) then
         Supprimer(Cellule.all.Fils_droit,Cle);
      else
         raise Cle_Absente_Exception;
      end if;

   end Supprimer;

   procedure Parcours_Infixe(Cellule : in out T_Cellule) is
   begin
      if not(Est_Vide(Cellule)) then
         if not(Est_Vide(Cellule.all.Fils_gauche)) then
            Parcours_Infixe(Cellule.all.Fils_gauche);
         end if;
         Traiter(Cellule.all.Cle, Cellule.all.Donnee);
         if not(Est_Vide(Cellule.all.Fils_droit)) then
            Parcours_Infixe(Cellule.all.Fils_droit);
         end if;
      end if;
   end Parcours_Infixe;

end Cellule;
