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

   procedure Afficher_Tableau(Tableau : in T_Tableau) is
   begin
      New_Line;
      Put("Cle");Put("     |     ");Put("Donnee");New_Line;
      for i in 1..256 loop
         if Est_Vide(Tableau(i)) then
            Put_Line("----- Vide -----");
         else
            Put(La_Cle_Direct(Tableau(i)));Put("  |     ");Put(La_Donnee_Direct(Tableau(i)),1);New_Line;
         end if;
      end loop;
   end Afficher_Tableau;

   procedure Afficher_Cellule(Cellule : in T_Cellule) is
   begin
      New_Line;
      Put("Cle");Put("     |     ");Put("Donnee");New_Line;
      if Est_Vide(Cellule) then
         Put_Line("----- Vide -----");
      else
         Put(La_Cle_Direct(Cellule));Put("       |     ");Put(La_Donnee_Direct(Cellule),1);New_Line;
      end if;
   end Afficher_Cellule;

   function Compresser_ficher return String is

      file_txt : Ada.Text_IO.file_type;			-- pour l'accÃ¨s par caractÃ¨re
      file_byte, file_hff : Byte_file.file_type;	-- pour l'accÃ¨s par byte
      un_char : Character;
      texte : constant String := "fichier.txt";

      package Byte_file is new Ada.Sequential_IO(T_byte);
      use Byte_file ;

      procedure Tri_selection(Tableau : in out T_Tableau) is
         minimum : Integer;
         Tampon : T_Cellule;
      begin
         for I in 1..254 loop
            minimum := I;
            for J in 2..255 loop
               if Tableau(I).all.Donnee > Tableau(J).all.Donnee then
                  minimum := J;
               end if;
            end loop;
            if minimum /= i then
               Tampon := Tableau(I);
               Tableau(I) := Tableau(minimum);
               Tableau(minimum) := Tampon;
            end if;
         end loop;
      end Tri_selection;

      function Construire_Arbre(Tableau: in out T_Tableau) return T_Cellule is

         function dernierIndice(Tableau : in T_Tableau) return Integer is
            indice_dernier : Integer :=1;
         begin

            while indice_dernier < Tableau'Length or La_Donnee_Direct(Tableau(indice_dernier)) = 0 loop
               indice_dernier := indice_dernier + 1;
            end loop;
            return indice_dernier;
         end dernierIndice;

         Cellule : T_Cellule;
         indice_fin : Integer;
         indice_newcellule : Integer;
         i : Integer;
      begin
         indice_fin := dernierIndice(Tableau);
         while indice_fin > 1 loop
            indice_newcellule := 1;
            i := 1;
            while i+1 <= dernierIndice(Tableau) loop
               Initialiser(Cellule);
               Enregistrer(Cellule, Character'Val(0),Tableau(i).all.donnee + Tableau(i+1).all.donnee);
               Enregistrer_FilsGauche(Cellule,Tableau(i));
               Enregistrer_FilsDroit(Cellule,Tableau(i+1));

               Initialiser(Tableau(i));
               Initialiser(Tableau(i+1));
               Tableau(indice_newcellule) := Cellule;
               indice_newcellule := indice_newcellule + 1;
               i := i + 2;
               indice_fin := indice_fin - 1;
            end loop;
            Tri_selection(Tableau);

         end loop;
         return Cellule;
      end Construire_Arbre;

      procedure InitialiserTableau(Tableau : out T_Tableau) is
         compteur : Integer := 0;
      begin
         for i in 1..256 loop
            Initialiser(Tableau(i));
            Enregistrer(Tableau(i),Character'Val(i - 1) , 0);
         end loop;
      end InitialiserTableau;

      Tableau : T_Tableau;
      Arbre : T_Cellule;

   begin
      Put_Line("Entrée dans le programme");
      open(file_txt, In_File, texte); 	-- Ouverture du fichier en lecture

      Put_Line("Fichier récupéré");
      Put("Message enregistré : ");
      InitialiserTableau(Tableau);

      while not end_of_file(file_txt) loop
         Get_immediate (file_txt, un_char);
         Enregistrer(Tableau(Character'Pos(un_char) + 1), un_char, La_Donnee(Tableau(Character'Pos(un_char) + 1),un_char) + 1);
         Put(un_char); Put("|");
      end loop;
      close (file_txt);
      New_Line;
      Put_Line("Contenu du fichier récupéré");
      Put("La donnée de o : ");Put(La_Donnee(Tableau(Character'Pos('o') + 1),'o'),1);New_Line;

      Put("Début du Tri...");
      Tri_selection(Tableau);
      Put_Line(" Ok");
      --Afficher_Tableau(Tableau);


      Put("Début de la construction de l'arbre...");
      Arbre := Construire_Arbre(Tableau);
      Put_Line(" Ok");

      return texte;
   end Compresser_ficher;

   function Decompresser_fichier(texte : in String) return String is
   begin
      return "Null";
   end Decompresser_fichier;


end codagehuffman;
