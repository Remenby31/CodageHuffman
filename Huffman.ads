with Cellule;

generic
    type T_Donnee is private;
    type T_Cle is private;

package Huffman is
    type T_Tableau is limited private;
    type T_Cellule is limited private;

-- Calculer les fréquences des caractères du texte
  function Calcul_Frequence(texte : in String) return T_Tableau;
--Trier par ordre croissant le tableau de fréquence
  function Tri_selection(Tableau : in T_Tableau) return T_Tableau;

-- Construire l'arbre de Huffman grâce aux fréquences des caractères
    function Construire_Arbre(Tableau : in T_Tableau) return T_Cellule;

-- Afficher l'arbre de Huffman
  procedure Afficher_Arbre(Cellule : in T_Cellule);

-- Compresser le fichier
  function Compresser_ficher(texte : in String) return String;

-- Décompresser le fichier
  function Decompresser_fichier(texte : in String) return String;

  generic
        with procedure Traiter(Frequence : in Integer; Caractere : in Character);
  procedure Parcours_infixe(Tableau : in T_Tableau);

private
    type T_Element;

   type T_Cellule is access T_Element;

   type T_Element is
      record
         Donnee : T_Donnee;
         Cle : T_Cle;
         Fils_gauche : T_Cellule;
         Fils_droit : T_Cellule;
      end record;
  package Cellule_Huffman is
    new Cellule(T_Cle => T_Cle, T_Donnee => T_Donnee);
  use Cellule_Huffman;

   type T_Tableau is array(0..128) of T_Donnee;
end Huffman;
