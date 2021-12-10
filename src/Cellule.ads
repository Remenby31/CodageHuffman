package Cellule is
   type T_Cellule is limited private;

   -- Initialiser la cellule
   procedure Initialiser(Cellule : out T_Cellule);

   -- La Cellule est vide
   function Est_Vide(Cellule : out T_Cellule) return Boolean;

   --Vérifier si la cellule est une feuille
   function Est_Feuille(Cellule : in T_Cellule) return Boolean;

   -- Vérifier si le carctere est présent dans la cellule
   procedure Caractere_Present(Cellule : in T_Cellule ; Caractere : in Character);

   -- Enregistrer une cellule d'une fiche avec ses fils droit et gauche, sa frequence et le caractere
   procedure Enregistrer(Cellule : in out T_Cellule ; Caractere : in Character ; Frequence : in Integer; Fils_droit : in T_Cellule ; Fils_gauche : in T_Cellule);

   procedure Supprimer (Cellule : in out T_Cellule ; Caractere : in Character);

   function Donne_Frequence(Cellule : in T_Cellule ; Caractere : in Character) return Integer;

   -- generique avec fonction traiter
   procedure Parcrour_Infixe(Cellule : in out T_Cellule);


   --

private
   type T_Element;
   type T_Cellule is access T_Element;
   type T_Element is
      record
         Fils_gauche : T_Cellule;
         Fils_droit : T_Cellule;
         Frequence : Integer;
         Caractere : Character;
      end record;
end Cellule;
