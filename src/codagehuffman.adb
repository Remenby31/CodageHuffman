package body codagehuffman is

   file_txt : Ada.Text_IO.file_type;			-- pour l'accès par caractère
   file_byte, file_hff : Byte_file.file_type;	-- pour l'accès par byte
   nom_fichier : constant String := "fichier.txt";
   texte_a_envoyer : Unbounded_String;

   procedure InitialiserTableau(Tableau : out T_Tableau) is
      compteur : Integer := 0;
      str : String := "0";
      str2 : String := "\$";
   begin
      for i in 1..256 loop
         Initialiser(Tableau(i));
         str(1) := Character'Val(i - 1);
         Enregistrer(Tableau(i), To_Unbounded_String(str), -1);
      end loop;
      Initialiser(Tableau(257));
      Enregistrer(Tableau(257), To_Unbounded_String(str2), 0);
   end InitialiserTableau;

   procedure Afficher_Arbre(Arbre : in T_Cellule) is

      procedure Afficher_Arbre_rec(Arbre : in T_Cellule; avant : in Unbounded_String) is

         procedure Afficher_Donnee_Cle(Arbre : in T_Cellule) is
         begin
            Put("(");Put(La_Donnee_Direct(Arbre),1);Put(")");
            if Est_Feuille(Arbre) then
               Put(" '");Put(To_String(La_Cle_Direct(Arbre)));Put("'");
            end if;
         end Afficher_Donnee_Cle;

      begin
         if not(Est_Vide(Arbre)) then

            Afficher_Donnee_Cle(Arbre);
            New_Line;

            if not(Est_Feuille(Arbre)) then
               Put(To_String(avant));
            end if;

            if not(Est_Vide(Arbre.all.Fils_droit)) then
               Put("\--0--");
               Afficher_Arbre_rec(Arbre.all.Fils_droit, avant & "|      ");
               Put(To_String(avant));
            end if;

            if not(Est_Vide(Arbre.all.Fils_gauche)) then
               Put("\--1--");
               Afficher_Arbre_rec(Arbre.all.Fils_gauche, avant & "       ");
            end if;

         end if;
      end Afficher_Arbre_rec;

      unstr : Unbounded_String;

   begin
      Afficher_Arbre_rec(Arbre,unstr);
   end Afficher_Arbre;

   procedure Afficher_Tableau(Tableau : in T_Tableau) is
   begin
      New_Line;
      Put("Cle");Put("     |     ");Put("Donnee");New_Line;
      for i in 1..256 loop
         if Est_Vide(Tableau(i)) then
            Put_Line("----- Vide -----");
         else
            Put(To_String(La_Cle_Direct(Tableau(i))));Put("  |     ");Put(La_Donnee_Direct(Tableau(i)),1);New_Line;
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
         Put(To_String(La_Cle_Direct(Cellule)));Put("       |     ");Put(La_Donnee_Direct(Cellule),1);New_Line;
      end if;
   end Afficher_Cellule;

   procedure Ecrire_Fichier(un_byte : in T_byte) is
   begin
      Open(file_hff, Append_File, nom_fichier & ".hff"); -- Création / écriture
      write(file_hff, un_byte);
      close(file_hff);
   end Ecrire_Fichier;

   procedure Ecrire_Fichier(Ch : in Character) is
      un_byte : T_byte := Character'Pos(Ch);
   begin
      Ecrire_Fichier(un_byte);
   end Ecrire_Fichier;

   procedure Ecrire_Fichier(entier : in Integer) is
      ch : Character := Character'Val (entier);
   begin
      Ecrire_Fichier(ch);
   end Ecrire_Fichier;

   procedure Ecrire_Fichier(str : in String) is
   begin
      for i in 1..str'Last loop
         Ecrire_Fichier(str(i));
      end loop;
   end Ecrire_Fichier;


   procedure Compresser_ficher is


      package Byte_file is new Ada.Sequential_IO(T_byte);
      use Byte_file ;


      function Donne_Tableau return T_Tableau is
         Tableau : T_Tableau;
         str : String := " ";
      begin
         open(file_txt, In_File, nom_fichier); 	-- Ouverture du fichier en lecture

         Put_Line("Fichier récupéré");
         Put("Message lu : ");

         InitialiserTableau(Tableau);
         while not end_of_file(file_txt) loop
            Get_immediate (file_txt, str(1));
            if La_Donnee_Direct(Tableau(Character'Pos(str(1)) + 1)) = - 1 then
               Enregistrer(Tableau(Character'Pos(str(1)) + 1), To_Unbounded_String(str), 1);
            else
               Enregistrer(Tableau(Character'Pos(str(1)) + 1), To_Unbounded_String(str), (La_Donnee_Direct(Tableau(Character'Pos(str(1)) + 1)) + 1));
            end if;
            Put(str(1)); Put("|");
         end loop;
         close (file_txt);
         return Tableau;
      end Donne_Tableau;

      procedure Creer_Fichier is
      begin
         create(file_hff, Out_File, nom_fichier & ".hff");
         close(file_hff);
      end Creer_Fichier;

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
            while indice < Tableau'last and La_Donnee_Direct(Tableau(indice)) = -1  loop
               indice := indice + 1;
            end loop;
            return indice;
         end DebutTableau;

         Cellule : T_Cellule;
         str1 : String := "0";
         indice_debut : Integer;--Indice du premier indice non vide du tableau
         indice_newcellule : Integer;--L'indice de la case de la prochaine nouvelle cellule
         i : Integer;
      begin
         indice_debut := DebutTableau(Tableau);

         while indice_debut < Tableau'last loop
            indice_newcellule := indice_debut;
            i := indice_debut;
            while i + 1 <= Tableau'last loop
               --Creation de la nouvelle cellule
               Initialiser(Cellule);
               Enregistrer(Cellule, To_Unbounded_String(str1),La_Donnee_Direct(Tableau(i)) + La_Donnee_Direct(Tableau(i+1)));

               --Ajout des deux cellules suivantes du Tableau dans la nouvelle cellule
               Enregistrer_FilsGauche(Cellule,Tableau(i));
               Enregistrer_FilsDroit(Cellule,Tableau(i+1));

               --Réinitialiser les deux cellules
               Initialiser(Tableau(i));
               Enregistrer(Tableau(i), To_Unbounded_String(str1),-1);
               Initialiser(Tableau(i+1));
               Enregistrer(Tableau(i+1), To_Unbounded_String(str1),-1);

               -- Ajout de la nouvelle cellule dans le tableau
               Tableau(indice_newcellule) := Cellule;
               indice_newcellule := indice_newcellule + 1;
               i := i + 2;
               indice_debut := indice_debut + 1;
            end loop;
            Tri_selection(Tableau);
         end loop;
         return Tableau(257);
      end Construire_Arbre;



      function Recherche_Code(Arbre : in T_Cellule; str : in Unbounded_String) return Unbounded_String is
         unstr : Unbounded_String;
         function Recherche_Code_rec(Arbre : in T_Cellule; str : in Unbounded_String) return Unbounded_String is

            Code_Gauche : Unbounded_String;
            Fin_Code_Gauche : Character;

         begin
            if Est_Vide(Arbre) then
               return To_Unbounded_String("f");

            elsif Est_Feuille(Arbre) then
               if La_Cle_Direct(Arbre) = str then
                  return To_Unbounded_String("v");
               else
                  return To_Unbounded_String("f");
               end if;
            else

               Code_Gauche := Recherche_Code_rec(Arbre.All.Fils_gauche, str);
               Fin_Code_Gauche := To_String(Code_Gauche)(To_String(Code_Gauche)'Last);

               if Fin_Code_Gauche = 'v' then
                  return "1" & Code_Gauche;
               end if;
               return "0" & Recherche_Code_rec(Arbre.All.Fils_droit, str);
            end if;
         end Recherche_Code_rec;
      begin
         unstr := Recherche_Code_rec(Arbre,str);
         return Delete(unstr,To_String(unstr)'Last,To_String(unstr)'Last);

      end Recherche_Code;

      procedure Ecrire(Arbre : in T_Cellule) is
         unstr_a_ecrire : Unbounded_String;


         procedure Ecrire_Table_Huffman(Arbre : in T_Cellule) is



            procedure Donne_Liste_Element(Arbre : in T_Cellule; str : in out Unbounded_String; position_compteur : in out Integer; position_fin : in out Integer) is
            begin
               if not(Est_Vide(Arbre)) then
                  if not(Est_Vide(Arbre.all.Fils_gauche)) then
                     Donne_Liste_Element(Arbre.all.Fils_gauche, str, position_compteur, position_fin);
                  end if;

                  if Est_Feuille(Arbre) then
                     position_compteur := position_compteur + 1;
                     if La_Cle_Direct(Arbre) = To_Unbounded_String("\$") then
                        position_fin := position_compteur;
                     else
                        str := str & La_Cle_Direct(Arbre);
                     end if;
                  end if;

                  if not(Est_Vide(Arbre.all.Fils_droit)) then
                     Donne_Liste_Element(Arbre.all.Fils_droit, str, position_compteur, position_fin);
                  end if;
               end if;
            end Donne_Liste_Element;

            str : String := "";
            unstr : Unbounded_String;
            position_compteur : Integer :=0;
            position_fin : Integer :=0;

         begin
            --Récupération des symboles et de la position du symbole de fin depuis le Tableau
            Donne_Liste_Element(Arbre, unstr, position_compteur, position_fin);
            New_Line; Put("Donneés :");
            Put(position_fin,1);Put(To_String(unstr));New_Line;

            --Ecriture du Tableau des symboles dans le fichier
            unstr :=  unstr & Element(unstr,To_String(unstr)'Last);
            Ecrire_Fichier(position_fin);
            Ecrire_Fichier(To_String(unstr));

         end Ecrire_Table_Huffman;

         procedure Ecrire_Arbre(Arbre : in T_Cellule; unstr_a_ecrire : in out Unbounded_String) is
         begin
            if not(Est_Vide(Arbre)) then
               if not(Est_Vide(Arbre.all.Fils_gauche)) then
                  unstr_a_ecrire := unstr_a_ecrire & To_Unbounded_String("0");
                  Ecrire_Arbre(Arbre.all.Fils_gauche,unstr_a_ecrire);
               end if;
               if Est_Feuille(Arbre) then
                  unstr_a_ecrire := unstr_a_ecrire & To_Unbounded_String("1");
               end if;
               if not(Est_Vide(Arbre.all.Fils_droit)) then

                  Ecrire_Arbre(Arbre.all.Fils_droit,unstr_a_ecrire);
               end if;
            end if;
         end Ecrire_Arbre;

         procedure Ecrire_Texte(Arbre : in T_Cellule; unstr_a_ecrire : in out Unbounded_String) is

            function Encoder_Texte return String is
               unstr_ch : Unbounded_String;
               unstr_bin : Unbounded_String;
               str : String := " ";
            begin
               open(file_txt, In_File, nom_fichier);
               while not end_of_file(file_txt) loop
                  Get_immediate (file_txt, str(1));
                  unstr_ch := unstr_ch & str(1);
               end loop;

               for i in 1..To_String(unstr_ch)'Last loop
                  str(1) := Element(unstr_ch,i);
                  unstr_bin := unstr_bin & Recherche_Code(Arbre,To_Unbounded_String(str));
               end loop;

               close (file_txt);

               return To_String(unstr_bin);
            end Encoder_Texte;

         begin
            unstr_a_ecrire := unstr_a_ecrire & Encoder_Texte;
         end Ecrire_Texte;

         procedure Ecrire_ChaineBin(str : in String) is

            function Octet_to_Entier(Chaine : in Unbounded_String) return Integer is
               Octet : T_byte := 0;
               i : Integer := 1;
               Chaine_bis : String := " ";
            begin
               while i <= To_String(Chaine)'length loop
                  if To_String(Chaine)(i)= '0' then
                     Octet := (Octet*2) or 0;
                  elsif To_String(Chaine)(i) = '1' then
                     Octet := (Octet*2) or 1;
                  end if;
                  i := i+1;
               end loop;
               return Integer(Octet);
            end Octet_to_Entier;

            i: integer := 1;
            unstr : Unbounded_String;
         begin
            -- Les octets complets
            while i + 7 < str'Last loop
               for k in 0..7 loop
                  unstr := unstr & str(i+k);
               end loop;
               Ecrire_Fichier(Octet_to_Entier(unstr));New_Line;
               i := i + 8;
            end loop;
            -- Les octets de fin
            i := i - 8;
            for j in i..str'Last loop
               unstr := unstr & str(j);
            end loop;
            --On rajoutes des 0 pour le dernier octet
            while Length(unstr) < 8 loop
               unstr := unstr & '0';
            end loop;
         end Ecrire_ChaineBin;

      begin

         Ecrire_Table_Huffman(Arbre);
         Ecrire_Arbre (Arbre,unstr_a_ecrire);
         New_Line;Put("Code Arbre :         ");Put(To_String(unstr_a_ecrire));New_Line;
         Ecrire_Texte(Arbre,unstr_a_ecrire);
         Put("Code Arbre + texte : ");Put(To_String(unstr_a_ecrire));New_Line;
         Ecrire_ChaineBin(To_String(unstr_a_ecrire));

      end Ecrire;

      Tableau : T_Tableau;
      Arbre : T_Cellule;
      char : Unbounded_String := To_Unbounded_String("");
      str : String := "a";
      un_byte :  T_byte := 115;


   begin
      Put_Line("Entrée dans le programme");

      Tableau := Donne_Tableau;
      Creer_Fichier;

      Put_Line("Contenu du fichier récupéré");

      Put("Début du Tri...");
      Tri_selection(Tableau);
      Afficher_Tableau(Tableau);
      Put_Line(" Ok"); New_Line;


      Put("Début de la construction de l'arbre...");
      Arbre := Construire_Arbre(Tableau);
      Put_Line(" Ok");New_Line;

      Afficher_Cellule(Arbre);New_Line;


      Put("Début de l'affichage de l'arbre...");New_Line;
      Afficher_Arbre(Arbre);
      Put_Line(" Ok");New_Line;

      Put("Début du chemin...");New_Line;
      char := Recherche_Code(Arbre,To_Unbounded_String("t"));
      Put(To_String(char));New_Line;
      Put_Line(" Ok");New_Line;

      Put("Début de l'Ecriture...");New_Line;
      Ecrire(Arbre);New_Line;
      Put_Line(" Ok");New_Line;


   end Compresser_ficher;

   procedure Decompresser_fichier is

      function Lire_Texte return Unbounded_String is

         unstr : Unbounded_String;
         un_char : Character;
      begin
         open (file_txt, In_File, nom_fichier & ".hff"); 	-- Ouverture du fichier en lecture
         while not end_of_file(file_txt) loop
            Get_immediate (file_txt, un_char);
            unstr := unstr & un_char;
         end loop;

         return unstr;
      end Lire_Texte;

      procedure Separer_Code(code: in Unbounded_String; indice_fin : out Integer; elements : out Unbounded_String; code_arbre : out Unbounded_String) is

         function Donne_indice_fin(code : in Unbounded_String) return Integer is
            str : String := To_String(code);
         begin
            return Character'Pos(str(str'First));
         end Donne_indice_fin;

         function Donne_elements(code : in Unbounded_String) return Unbounded_String is
            i : Integer := 2;
         begin
            while Element(code,i) /= Element(code,i+1) loop
               i := i + 1;
            end loop;
            return Unbounded_Slice(code,2,i);
         end Donne_elements;

         function Donne_Code_Arbre(code : in Unbounded_String) return Unbounded_String is
            i : Integer := 2;
         begin
            while Element(code,i) /= Element(code,i+1) loop
               i := i + 1;
            end loop;
            return Unbounded_Slice(code,i + 2,To_String(code)'Last);
         end Donne_Code_Arbre;

      begin

         indice_fin := Donne_indice_fin(code);
         elements := Donne_elements(code);
         code_arbre := Donne_Code_Arbre(code);
      end Separer_Code;

      function Construire_Arbre(indice_fin : in Integer; elements : in String; code_arbre_ch : in String) return T_Cellule is

         function Conversion_binaire(unstr_ch : in Unbounded_String) return Unbounded_String is

            function ch_to_bin(ch : in Character) return unbounded_string is
               Quotient : Integer;
               Entier : Integer;
               reste : Integer;
               codage : unbounded_string;
            begin
               Entier := Character'Pos(ch);
               while Entier /= 0  loop
                  Quotient := Entier/2 ;
                  reste := Entier mod 2;
                  codage := Integer'Image(reste)(2) & codage;
                  Entier:= quotient;
               end loop;
               while To_String(codage)'Last /= 8 loop
                  codage := "0" & codage;
               end loop;
               return codage;
            end ch_to_bin;

            unstr_bin : Unbounded_String;
         begin
            for i in 1..To_String(unstr_ch)'Last loop
               unstr_bin := unstr_bin & ch_to_bin(Element(unstr_ch,i));
            end loop;
            return unstr_bin;
         end Conversion_binaire;

         indice_fin2 : Integer := indice_fin;
         code_arbre_bin : Unbounded_String;
         indice_arbre : Integer := 1;
         indice_element : Integer := 1;
         Arbre : T_Cellule;

         procedure Construire_Arbre_rec(Arbre : in out T_Cellule; code_arbre : in String; indice_arbre : in out Integer; indice_element : in out Integer) is

            New_Arbre : T_Cellule;
            str : String := " ";

         begin

            if indice_element < elements'Last + 1 then

               if code_arbre(indice_arbre) = '1' then

                  if indice_element = indice_fin2 then

                     Enregistrer(Arbre,To_Unbounded_String("\$"),0);
                     indice_fin2 := 0;

                  else

                     str(1) := elements(indice_element);
                     Enregistrer(Arbre,To_Unbounded_String(str),0);
                     Put("Indice element"); Put(str);New_Line;
                     indice_element := indice_element + 1;
                  end if;

                  indice_arbre := indice_arbre + 1;

               else
                  Initialiser(New_Arbre);
                  Enregistrer(Arbre,To_Unbounded_String("0"),0);

                  indice_arbre := indice_arbre + 1;

                  Enregistrer_FilsGauche(Arbre,New_Arbre);
                  Construire_Arbre_rec(Arbre.All.Fils_gauche,code_arbre, indice_arbre,indice_element);

                  Enregistrer_FilsDroit(Arbre,New_Arbre);
                  Construire_Arbre_rec(Arbre.All.Fils_droit,code_arbre, indice_arbre,indice_element);

               end if;
            end if;
         end Construire_Arbre_rec;


      begin

         Initialiser(Arbre);
         Enregistrer(Arbre,To_Unbounded_String("0"),0);
         code_arbre_bin := Conversion_binaire(To_Unbounded_String(code_arbre_ch));
         New_Line;Put("code_arbre :");Put(To_String(code_arbre_bin)); New_Line;
         Construire_Arbre_rec(Arbre,To_String(code_arbre_bin),indice_arbre,indice_element);
         return Arbre;
      end Construire_Arbre;



      indice_fin : Integer;
      elements : Unbounded_String;
      code_arbre : Unbounded_String;
      code : Unbounded_String;
      Arbre : T_Cellule;
   begin
      code := Lire_Texte;
      Separer_Code(code, indice_fin, elements, code_arbre);
      New_Line;Put("Code :");Put(To_String(Code));
      New_Line;Put("indice_fin :");Put(indice_fin,1);
      New_Line;Put("elements :");Put(To_String(elements));
      New_Line;Put("code_arbre :");Put(To_String(code_arbre));
      Arbre := Construire_Arbre(indice_fin,To_String(elements),To_String(code_arbre));



      Afficher_Arbre(Arbre);
   end Decompresser_fichier;


end codagehuffman;
















