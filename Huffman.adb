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
