generic
   type T_Cle is private;
   type T_Donnee is private;

package Arbre is


   type T_Element;

   type T_Arbre is access T_Element;

   type T_Element is
      record
         Cle : T_Cle;
         Donnee : T_Donnee;
         Fils_gauche : T_Arbre;
         Fils_droit : T_Arbre;
      end record;



   -- Initialiser l'arbre
   procedure Initialiser(Arbre : out T_Arbre);

   procedure Vider(Arbre : in out T_Arbre) with
     Post => Est_Vide (Arbre);

   -- L'arbre est vide
   function Est_Vide(Arbre : in T_Arbre) return Boolean;

   -- Obtenir le nombre d'Alignements d'un Arbre.
   function Taille (Arbre : in T_Arbre) return Integer with
     Post => Taille'Result >= 0
     and (Taille'Result = 0) = Est_Vide (Arbre);

   --V�rifier si l'arbre est une feuille
   function Est_Feuille(Arbre : in T_Arbre) return Boolean;

   -- V�rifier si le carctere est pr�sent dans l'arbre
   function Cle_Presente(Arbre : in T_Arbre ; Cle : in T_Cle) return Boolean;

   function La_Donnee(Arbre : in T_Arbre ; Cle : in T_Cle) return T_Donnee;

   function La_Donnee_Direct(Arbre : in T_Arbre) return T_Donnee;
   function La_Cle_Direct(Arbre : in T_Arbre) return T_Cle;

   -- Enregistrer un arbre d'une fiche avec ses fils droit et gauche, sa frequence et le caractere
   procedure Enregistrer(Arbre : in out T_Arbre ; Cle : in T_Cle ; Donnee : in T_Donnee);

   procedure Enregistrer_FilsDroit(Arbre_parent : in out T_Arbre; Arbre_fils : in T_Arbre);

   procedure Enregistrer_FilsGauche(Arbre_parent : in out T_Arbre; Arbre_fils : in T_Arbre);


   -- Supprimer la Donn�e associ�e � une Cl� dans un Arbre.
   -- Exception : Cle_Absente_Exception si Cl� n'est pas utilis�e dans la Cellule
   procedure Supprimer(Arbre : in out T_Arbre ; Cle : in T_Cle) with
     Post =>  Taille (Arbre) = Taille (Arbre)'Old - 1 -- un �l�ment de moins
     and not Cle_Presente (Arbre, Cle);

   -- generique avec fonction traiter
   generic
      with procedure Traiter (Cle : in out T_Cle; Donnee: in out T_Donnee);
   procedure Parcours_Infixe(Arbre : in out T_Arbre);



end Arbre;
