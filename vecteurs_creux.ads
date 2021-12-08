-- Ce module définit un type Vecteur_Creux et les opérations associés. Un
-- vecteur creux est un vecteur qui contient essentiellement des 0. Aussi pour
-- économiser l'espace de stockage et les temps de calculs, on ne conserve que
-- les valeurs non nulles.

package Vecteurs_Creux is

	type T_Vecteur_Creux is limited private;


	-- Initialiser un vecteur creux.  Il est nul.
	procedure Initialiser (V : out T_Vecteur_Creux) with
		Post => Est_Nul (V);


	-- Détruire le vecteur V.
	procedure Detruire (V: in out T_Vecteur_Creux);


	-- Est-ce que le vecteur V est nul ?
	function Est_Nul (V : in T_Vecteur_Creux) return Boolean;


	-- Récupérer la composante (valeur) du vecteur V à l'indice Indice.
	function Composante_Recursif (V : in T_Vecteur_Creux ; Frequence : in Integer) return Float
		with Pre => Indice >= 1;

	-- Modifier une composante (Indice, Valeur) d'un vecteur creux.
	procedure Modifier (V : in out T_Vecteur_Creux ;
				       Frequence : in Integer ;
					   Valeur : in Character) with
		pre => Indice >= 1,
		post => Composante_Recursif (V, Indice) = Valeur;


    -- Afficher le vecteur creux à des fins de mise au point.
	procedure Afficher (V : T_Vecteur_Creux);


private

	type T_Cellule;

	type T_Vecteur_Creux is access T_Cellule;

	type T_Cellule is
		record
			Frequence : Integer;
			Valeur : Character;
			Suivant : T_Vecteur_Creux;
			-- Invariant :
			--   Indice >= 1;
			--   Suivant = Null or else Suivant.all.Indice > Indice;
			--   	-- les cellules sont stockés dans l'ordre croissant des indices.
		end record;
end Vecteurs_Creux;
