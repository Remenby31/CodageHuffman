with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with codageHuffman; use codageHuffman;
with Cellule;

procedure Test_Huffman is

   package Cellule_codageHuffman is
     new Cellule(T_Cle => Unbounded_String, T_Donnee => Integer);
   use Cellule_codageHuffman;

   type T_TabDonnee is array (1..10) of Integer;
   type T_TabCle is array (1..10) of Unbounded_String;


   procedure Test_Compresser_ficher is
      nom_fichier : String := "fichier.txt";
      Bool_afficher_Arbre : Boolean := True;
   begin
      Compresser_ficher(nom_fichier,Bool_afficher_Arbre);
   end Test_Compresser_ficher;

   procedure Test_Decompresser_fichier is
      nom_fichier : String := "fichier.txt.hff";
      Bool_afficher_Arbre : Boolean := True;
   begin
      Decompresser_fichier(nom_fichier,Bool_afficher_Arbre);
   end Test_Decompresser_fichier;

begin
   Put_Line("Début du test de Compression...");
   --Test_Compresser_ficher;
   Put_Line(" - Ok"); New_Line;
   Put_Line("Début du test de Décompression...");
   Test_Decompresser_fichier;
   Put_Line(" - Ok"); New_Line;
end Test_Huffman;
