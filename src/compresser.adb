with Ada.Command_line; use Ada.Command_line;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with codageHuffman; use codageHuffman;


procedure compresser is
    argument_ligne_commande : String := Argument(Argument_Count);
    file : Ada.Streams.Stream_IO.File_Type;

begin
    if Argument(2) = "-b" or Argument(2) ="--bavard" then
        Compresser_ficher(Argument(1),True);
    else
        Compresser_ficher(Argument(1),False);
    end if;

end compresser;
