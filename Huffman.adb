package body codagehuffman is

    function Calcul_Frequence(texte : in String) return T_Tableau is
        Tableau : T_Tableau;
    begin
        for i in 1..128 loop
            Enregistrer(Tableau(i),Character'Val(i),i);
        end loop ;

        for i in texte'range loop
            Enregistrer(Tableau(Character'Pos(texte(i))), Tableau(Character'Pos(texte(i))).All.Cle, Tableau(Character'Pos(texte(i))).All.Donnee + 1);
        end loop;

        return Tableau;
    end Calcul_Frequence;

    procedure Tri_selection(Tableau : in out T_Tableau) is
        minimum : Integer;
        Tampon : T_Cellule;
    begin
        for I in 1..256 loop
            minimum := I;
            for J in 1..256 loop
                if Tableau(I).Donnee > Tableau(J).Donnee then
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

    procedure Construire_Arbre(Tableau : in T_Tableau) is

        Tableau_Construction : T_Tableau;
        Taille : Integer;
    begin
        cellule.all.Fils_gauche := Tableau(1);
        cellule.all.Fils_droit := Tableau(2);
        cellule.all.Donnee := Tableau(1).all.Donnee + Tableau(2).all.Donnee;
        Tableau_Construction(1) := cellule;
        for I in 3..Taille loop
            for J in 1.. Taille loop
                if Tableau(I).all.Donnee = Tableau(I+1).all.Donnee and Tableau(I).all.Donnee = Tableau_Construction(J).all.Donnee then
                    Tableau_Construction(J).all.Fils_gauche := Tableau(I);
                    Tableau_Construction(J).all.Fils_droit := Tableau(I+1);
                    Tableau_Construction(J).all.Donnee := Tableau(I).all.Donnee +Tableau(I+1).all.Donnee;
                    Tri_rapide(Tableau_Construction);
                else
                    Tableau_Construction(I).all.Fils_gauche := Tableau_Construction(I);
                    Tableau_Construction(I).all.Fils_droit := Tableau(J);
                    Tableau_Construction(I).all.Donnee := Tableau_Construction(I).all.Donnee+Tableau(J).all.Donnee;
                    Tri_rapide(Tableau_Construction);
                end if ;
            end loop;
        end loop;
    end Construire_Arbre;

    procedure Afficher_Arbre(cellule : in T_cellule) is
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
