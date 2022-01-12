with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with codageHuffman; use codageHuffman;
with Cellule;

procedure Test_Huffman is

   package Cellule_codageHuffman is
     new Cellule(T_Cle => Character, T_Donnee => Integer);
   use Cellule_codageHuffman;

   type T_TabDonnee is array (1..10) of Integer;
   type T_TabCle is array (1..10) of Unbounded_String;


   procedure Test_Compresser_ficher is
      texte : String := "exemple de texte";
   begin
      Put_Line(Compresser_ficher);
      pragma Assert(Compresser_ficher = "11.001.11.000.1011.0101.11.011.10101.11.011.100.11.001.100.11.011.10100.0100.11.001.11.000.1011.100.11.011.100.11.000.1011.11.100.11.011.0101.11.001.11.000.11.0100") ;
   end Test_Compresser_ficher;

   procedure Test_Decompresser_fichier is
      texte : String :=  "11.001.11.000.1011.0101.11.011.10101.11.011.100.11.001.100.11.011.10100.0100.11.001.11.000.1011.100.11.011.100.11.000.1011.11.100.11.011.0101.11.001.11.000.11.0100";
   begin
      pragma Assert(Decompresser_fichier(texte)="exemple de texte :");
   end Test_Decompresser_fichier;

begin
   Put_Line("Début du test de Compression...");
   Test_Compresser_ficher;
   Put_Line(" - Ok"); New_Line;
   Put_Line("Début du test de Décompression...");
   Test_Decompresser_fichier;
   Put_Line(" - Ok"); New_Line;
end Test_Huffman;
