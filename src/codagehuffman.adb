package body codagehuffman is

   function Calcul_Frequence(texte : in String) return T_Tableau is
      Tableau : T_Tableau;
   begin
      for i in 1..256 loop
         Initialiser(Tableau(i));
         Enregistrer(Tableau(i),Character'Val(i-1),1);
      end loop ;

      for i in texte'range loop
         Enregistrer(Tableau(Character'Pos(texte(i))), Tableau(Character'Pos(texte(i))).All.Cle, Tableau(Character'Pos(texte(i))).All.Donnee + 1);
      end loop;

      return Tableau;
   end Calcul_Frequence;





   procedure Afficher_Arbre(Cellule : in T_Cellule) is
   begin
      Null;
   end Afficher_Arbre;

   function Compresser_ficher return String is

      file_txt : Ada.Text_IO.file_type;			-- pour l'accès par caractère
      file_byte, file_hff : Byte_file.file_type;	-- pour l'accès par byte
      un_char : Character;
      texte : String := "";
      package Byte_file is new Ada.Sequential_IO(T_byte);
      use Byte_file ;

      procedure Tri_selection(Tableau : in out T_Tableau) is
         minimum : Integer;
         Tampon : T_Cellule;
      begin
         for I in 1..256 loop
            minimum := I;
            for J in 1..256 loop
               if Tableau(I).all.Donnee > Tableau(J).all.Donnee then
                  minimum := J;
               else
                  null;
               end if;
            end loop;
            Tampon := Tableau(I);
            Tableau(I) := Tableau(minimum);
            Tableau(minimum) := Tampon;
         end loop;
      end Tri_selection;

      function Construire_Arbre(Tableau: in out) return T_Cellule is
         Cellule : T_Cellule;
      begin
         for i in 1..(Tableau'Length-1) loop
            end loop
         return Cellule;
      end Construire_Arbre;

      Tableau : T_Tableau;

   begin
      open(file_txt, In_File, Argument(1)); 	-- Ouverture du fichier en lecture
      while not end_of_file(file_txt) loop
         Get_immediate (file_txt, un_char);
         Enregistrer(Tableau(Character'Pos(un_char)), Tableau(Character'Pos(un_char)).All.Cle, Tableau(Character'Pos(un_char)).All.Donnee + 1);
      end loop;
      close (file_txt);

      Tri_selection(Tableau);

      return texte;
   end Compresser_ficher;

   function Decompresser_fichier(texte : in String) return String is
   begin
      return "Null";
   end Decompresser_fichier;

   procedure Parcours_infixe(Tableau : in T_Tableau) is
   begin
      Null;
   end Parcours_infixe;

begin

   Null;

end codagehuffman;
