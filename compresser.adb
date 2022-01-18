with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_line; use Ada.Command_line;
with Ada.Sequential_IO ;	-- pour l'accès typé aux fichiers (integer, naturel,							-- float, etc.)
with Text_Io;   use Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Cellule_Exceptions;         use Cellule_Exceptions;
with cellule;
with codageHuffman; use codageHuffman;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

procedure compresser is
    argument_ligne_commande : String := Argument(Argument_Count);
    file : Ada.Streams.Stream_IO.File_Type;

begin
    if Argument(2) = "-b" or Argument(2) ="--bavard" then
        Compresser_ficher;
    else
        Put(Argument(2));
    end if;

end compresser;
