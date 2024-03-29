CREATE TABLE IF NOT EXISTS dex_list(
	id			INTEGER		PRIMARY KEY,
	dex			INTEGER,
	name		VARCHAR(40),
	shiny		BOOLEAN
);

CREATE TABLE IF NOT EXISTS pkmn(
	id 		INTEGER		PRIMARY KEY,
	name 	VARCHAR(12)
);

CREATE TABLE IF NOT EXISTS dex_entries(
	dex_NAT				INTEGER,
	dex_RBY				INTEGER,
	dex_FRLG			INTEGER,
	dex_LGPE			INTEGER,
	dex_GSC				INTEGER,
	dex_HGSS			INTEGER,
	dex_RSE				INTEGER,
	dex_ORAS			INTEGER,
	dex_DP				INTEGER,
	dex_PT				INTEGER,
	dex_BW				INTEGER,
	dex_B2W2			INTEGER,
	dex_XY_CENTRAL		INTEGER,
	dex_XY_COASTAL		INTEGER,
	dex_XY_MOUNTAIN		INTEGER,
	dex_SM				INTEGER,
	dex_SM_MELEMELE		INTEGER,
	dex_SM_AKALA		INTEGER,
	dex_SM_ULAULA		INTEGER,
	dex_SM_PONI			INTEGER,
	dex_USUM			INTEGER,
	dex_USUM_MELEMELE	INTEGER,
	dex_USUM_AKALA		INTEGER,
	dex_USUM_ULAULA		INTEGER,
	dex_USUM_PONI		INTEGER,
	dex_SWSH			INTEGER,
	dex_IOA				INTEGER,
	dex_CT 				INTEGER,
	FOREIGN KEY(dex_NAT) REFERENCES pkmn(id)
);

CREATE TABLE IF NOT EXISTS forms(
	id			INTEGER,
	form_id 	INTEGER,
	form_name	VARCHAR(40),
	FOREIGN KEY(id) REFERENCES pkmn(id)
);

CREATE TABLE IF NOT EXISTS types(
	id 			INTEGER,
	slot_1 		INTEGER,
	slot_2 		INTEGER
);