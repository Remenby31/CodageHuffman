with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with codageHuffman; use codageHuffman;
with Cellule;

procedure Test_Huffman is

   package Cellule_codageHuffman is
     new Cellule(T_Cle => Character, T_Donnee => Integer);
   use Cellule_codageHuffman;


   function Avec_Guillemets (S: Unbounded_String) return String is
   begin
      return '"' & To_String (S) & '"';
   end;

   function "&" (Left: String; Right: Unbounded_String) return String is
   begin
      return Left & Avec_Guillemets (Right);
   end;

   function "+" (Item : in String) return Unbounded_String
                 renames To_Unbounded_String;

   -- Afficher une Unbounded_String et un entier.
   procedure Afficher (Frequence : in Integer; Caractere : in Character) is
   begin
      Put (Frequence,1);
      Put (" : ");
      Put (Caractere);
      New_Line;
   end Afficher;

   type T_TabDonnee is array (1..10) of Integer;
   type T_TabCle is array (1..10) of Unbounded_String;

   Donnees : T_TabDonnee := (2, 5, 1, 1, 15, 2, 4, 3, 5,4);
   Cles :  T_TabCle := (+"\n", +" ", +":", +"d", +"e", +"l", +"m", +"p", +"t", +"x");
   Cles3 : String := "hfketyuiop";

   procedure Afficher is
     new codageHuffman.Parcours_Infixe(Afficher);


   procedure Test_Calcul_Frequence is

      texte : String := "exemple de texte :";
      Tableau : T_Tableau;

   begin
      Tableau := Calcul_Frequence(texte);
      Put_Line("Calcul Frequence terminé !");
      Tri_selection(Tableau);
      Put_Line("Ok");

   end Test_Calcul_Frequence;

   procedure Test_Construire_Arbre is

      texte : string := "exemple de texte :" ;
      Tableau : T_Tableau;
   begin
      Construire_Arbre(Tableau);
   end Test_Construire_Arbre;


   procedure Test_Compresser_ficher is
      texte : String := "exemple de texte";
   begin
      pragma Assert(Compresser_ficher(texte) = "11.001.11.000.1011.0101.11.011.10101.11.011.100.11.001.100.11.011.10100.0100.11.001.11.000.1011.100.11.011.100.11.000.1011.11.100.11.011.0101.11.001.11.000.11.0100") ;
   end Test_Compresser_ficher;

   procedure Test_Decompresser_fichier is
      texte : String :=  "11.001.11.000.1011.0101.11.011.10101.11.011.100.11.001.100.11.011.10100.0100.11.001.11.000.1011.100.11.011.100.11.000.1011.11.100.11.011.0101.11.001.11.000.11.0100";
   begin
      pragma Assert(Decompresser_fichier(texte)="exemple de texte :");
   end Test_Decompresser_fichier;


begin
   Put_Line("Ok");
   Test_Calcul_Frequence;
   Put_Line("ok");
   Test_Construire_Arbre;
   Test_Compresser_ficher;
   Test_Decompresser_fichier;
end Test_Huffman;
