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



   procedure Tri_rapide(Tableau : in out T_Tableau) is


      function Tri(Tableau : in out T_Tableau; premier : in Integer; dernier : in Integer) return Integer is
         Index : Integer;
         Pivot : Integer;
      begin
         Index := premier-1;
         Pivot := Tableau(dernier).Donnee;
         for i in premier..dernier loop
            if Tableau(i).Donnee <= Pivot then
               Index := Index +1;
               Tableau(Index).Donnee := Tableau(i).Donnee;
               Tableau(i).Donnee := Tableau(Index).Donnee;
            else
               null;
            end if;

         end loop;
         Tableau(Index+1).Donnee := Tableau(dernier).Donnee;
         Tableau(dernier).Donnee := Tableau(Index+1).Donnee;
         return Index +1 ;
      end Tri;

      procedure Tri_rapide_borne(Tableau : in out T_Tableau ; premier : in Integer; dernier : in Integer) is
         variable : Integer;

      begin
         if premier < dernier then
            variable := Tri(Tableau, premier, dernier);
            Tri_rapide_borne(Tableau, premier, variable-1);
            Tri_rapide_borne(Tableau, variable+1, dernier);
         else
            null;
         end if;
      end Tri_rapide_borne;

      procedure Enlever_trou(Tableau : in out T_Tableau) is
         Tableau_non_vide : T_Tableau;
         indice_fin : Integer := 1;
      begin
         for i in 1..256 loop
            if Tableau(i).All.Donnee /= 0 then
               Tableau_non_vide(indice_fin) := Tableau(i);
               indice_fin := indice_fin + 1;
            end if;
         end loop;
         Tableau := Tableau_non_vide;
      end Enlever_trou;

   begin
      Enlever_trou(Tableau);
      Tri_rapide_borne(Tableau,1,Tableau'Length);
   end tri_rapide;

   function recupere_fichier return String is

      file_txt : Ada.Text_IO.file_type;			-- pour l'accès par caractère
      file_byte, file_hff : Byte_file.file_type;	-- pour l'accès par byte
      taille_fichier : integer;
      un_char : Character;

      package Byte_file is new Ada.Sequential_IO(T_byte) ;
      use Byte_file ;

   begin
      open (file_txt, In_File, Argument(1)); 	-- Ouverture du fichier en lecture
      taille_fichier := 0; 					-- Nb de caracteres dans le fichier
      while not end_of_file(file_txt) loop
         Get_immediate (file_txt, un_char);
         taille_fichier := taille_fichier + 1;
      end loop;
      close (file_txt);


   end recupere_fichier;


   procedure Construire_Arbre(Tableau : in out T_Tableau) is
      Cellule : T_Cellule;
   begin
      Initialiser(Cellule);
   end Construire_Arbre;

   procedure Afficher_Arbre(Cellule : in T_Cellule) is
   begin
      Null;
   end Afficher_Arbre;

   function Compresser_ficher(texte : in String) return String is
   begin
      return "Null";
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
