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

      file_txt : Ada.Text_IO.file_type;			-- pour l'acc√®s par caract√®re
      file_byte, file_hff : Byte_file.file_type;	-- pour l'acc√®s par byte
      un_char : Character;
      texte : constant String := "fichier.txt";

      package Byte_file is new Ada.Sequential_IO(T_byte);
      use Byte_file ;


      procedure InitialiserTableau(Tableau : out T_Tableau) is
         compteur : Integer := 0;
      begin
         for i in 1..256 loop
            Initialiser(Tableau(i));
            Enregistrer(Tableau(i),Character'Val(i - 1) , 0);
         end loop;
      end InitialiserTableau;


      procedure Tri_selection(Tableau : in out T_Tableau) is
         Tampon : T_Cellule;
      begin
         for i in Tableau'first + 1 .. Tableau'last loop
            for j in reverse Tableau'first + 1..i loop
               exit when La_Donnee_Direct(Tableau(j-1)) <= La_Donnee_Direct(Tableau(j)) ;
               Tampon := Tableau(j-1);
               Tableau(j-1) := Tableau(j);
               Tableau(j) := Tampon;
            end loop ;
         end loop ;
      end Tri_selection;

      function Construire_Arbre(Tableau: in out T_Tableau) return T_Cellule is

         function DebutTableau(Tableau : in T_Tableau) return Integer is
            indice : Integer :=1;
         begin
            while indice < Tableau'Length and La_Donnee_Direct(Tableau(indice)) = 0 loop
               indice := indice + 1;
            end loop;
            return indice;
         end DebutTableau;

         Cellule : T_Cellule;
         indice_debut : Integer;--Indice du premier indice non vide du tableau
         indice_newcellule : Integer;--L'indice de la case de la prochaine nouvelle cellule
         i : Integer;
      begin
         indice_debut := DebutTableau(Tableau);
         while indice_debut < 256 loop
            indice_newcellule := indice_debut;
            i := indice_debut;
            while i + 1 <= Tableau'last loop
               --Creation de la nouvelle cellule
               Initialiser(Cellule);
               Enregistrer(Cellule, Character'Val(0),Tableau(i).all.donnee + Tableau(i+1).all.donnee);

               --Ajout des deux cellules suivantes du Tableau dans la nouvelle cellule
               Enregistrer_FilsGauche(Cellule,Tableau(i));
               Enregistrer_FilsDroit(Cellule,Tableau(i+1));

               --RÈinitialiser les deux cellules
               Initialiser(Tableau(i));
               Enregistrer(Tableau(i), Character'Val(0),0);
               Initialiser(Tableau(i+1));
               Enregistrer(Tableau(i+1), Character'Val(0),0);

               -- Ajout de la nouvelle cellule dans le tableau
               Tableau(indice_newcellule) := Cellule;
               indice_newcellule := indice_newcellule + 1;
               i := i + 2;
               indice_debut := indice_debut + 1;
            end loop;
            Tri_selection(Tableau);
         end loop;
         return Tableau(256);
      end Construire_Arbre;

      procedure Afficher_Arbre(Arbre : in T_Cellule; avant : in Unbounded_String) is

         function Avec_Guillemets (S: Unbounded_String) return String is
         begin
            return '"' & To_String (S) & '"';
         end;

         function "&" (Left: String; Right: Unbounded_String) return String is
         begin
            return Left & Avec_Guillemets (Right);
         end;

         function "+" (Item : in String) return Unbounded_String
                       renames To_Unbounded_String;

         procedure Afficher_Donnee_Cle(Arbre : in T_Cellule) is
         begin
            Put("(");Put(La_Donnee_Direct(Arbre),1);Put(")");
            if Est_Feuille(Arbre) then
               Put(" '");Put(La_Cle_Direct(Arbre));Put("'");
            end if;
         end Afficher_Donnee_Cle;

         avant_old : Unbounded_String := To_Unbounded_String("");
      begin
         if not(Est_Vide(Arbre)) then

            Afficher_Donnee_Cle(Arbre);
            New_Line;
            if not(Est_Feuille(Arbre)) then
               Put(To_String(avant));
            end if;
            if not(Est_Vide(Arbre.all.Fils_droit)) then
               Put("\--0--");
               Afficher_Arbre(Arbre.all.Fils_droit, avant & "|      ");
               Put(To_String(avant));
            end if;

            if not(Est_Vide(Arbre.all.Fils_gauche)) then
               Put("\--1--");
               Afficher_Arbre(Arbre.all.Fils_gauche, avant & "       ");
            end if;

         end if;

      end Afficher_Arbre;


      Tableau : T_Tableau;
      Arbre : T_Cellule;
      char : Unbounded_String := To_Unbounded_String("");

   begin
      Put_Line("EntrÈe dans le programme");
      open(file_txt, In_File, texte); 	-- Ouverture du fichier en lecture

      Put_Line("Fichier rÈcupÈrÈ");
      Put("Message enregistrÈ : ");
      InitialiserTableau(Tableau);

      while not end_of_file(file_txt) loop
         Get_immediate (file_txt, un_char);
         Enregistrer(Tableau(Character'Pos(un_char) + 1), un_char, La_Donnee(Tableau(Character'Pos(un_char) + 1),un_char) + 1);
         Put(un_char); Put("|");
      end loop;
      close (file_txt);
      New_Line;
      Put_Line("Contenu du fichier rÈcupÈrÈ");
      Put("La donnÈe de o : ");Put(La_Donnee(Tableau(Character'Pos('o') + 1),'o'),1);New_Line;

      Put("DÈbut du Tri...");
      Tri_selection(Tableau);
      Put_Line(" Ok"); New_Line;



      Put("DÈbut de la construction de l'arbre...");
      Arbre := Construire_Arbre(Tableau);
      Put_Line(" Ok");New_Line;

      if Est_Feuille(Arbre) then
         Put("feuile!");
      end if;

      Afficher_Cellule(Arbre);New_Line;


      Put("DÈbut de l'affichage de l'arbre...");New_Line;
      Afficher_Arbre(Arbre,char);
      Put_Line(" Ok");New_Line;

      return texte;
   end Compresser_ficher;

   function Decompresser_fichier(texte : in String) return String is
   begin
      return "Null";
   end Decompresser_fichier;


end codagehuffman;
