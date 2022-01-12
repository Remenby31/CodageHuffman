with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_line; use Ada.Command_line;
with Ada.Sequential_IO ;	-- pour l'accès typé aux fichiers (integer, naturel,							-- float, etc.)
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with cellule;

package codageHuffman is
   type T_Tableau is private;
   type T_byte is mod 2**8;

   package Byte_file is new Ada.Sequential_IO(T_byte) ;
   use Byte_file ;

   -- Calculer les fr�quences des caract�res du texte
   function Calcul_Frequence(texte : in String) return T_Tableau;

   -- Compresser le fichier
   function Compresser_ficher return String;

   -- D�compresser le fichier
   function Decompresser_fichier(texte : in String) return String;


private

   package Cellule_codageHuffman is
     new Cellule(T_Cle => Character, T_Donnee => Integer);
   use Cellule_codageHuffman;

   type T_Tableau is array(1..256) of T_Cellule;

end codagehuffman;
