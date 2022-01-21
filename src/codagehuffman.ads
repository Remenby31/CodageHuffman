with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_line; use Ada.Command_line;
with Ada.Sequential_IO ;	-- pour l'accès typé aux fichiers (integer, naturel,							-- float, etc.)
with Text_Io;   use Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Arbre_Exceptions;         use Arbre_Exceptions;
with Arbre;

package codageHuffman is
   type T_Tableau is private;
   type T_byte is mod 2**8;

   package Byte_file is new Ada.Sequential_IO(T_byte) ;
   use Byte_file ;


   -- Compresser le fichier
   procedure Compresser_ficher(nom_fichier : in String; Bool_afficher_Arbre : in Boolean);

   -- D�compresser le fichier
   procedure Decompresser_fichier(nom_fichier : in String);

private

   package Arbre_codageHuffman is
     new Arbre(T_Cle => Unbounded_String, T_Donnee => Integer);
   use Arbre_codageHuffman;

   type T_Tableau is array(1..257) of T_Arbre;

end codagehuffman;
