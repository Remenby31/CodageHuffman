with Ada.Command_line; use Ada.Command_line;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with codageHuffman; use codageHuffman;


procedure decompresser is
    argument_ligne_commande : String := Argument(Argument_Count);
    file : Ada.Streams.Stream_IO.File_Type;

begin

    Decompresser_fichier(Argument(1));

end decompresser;
