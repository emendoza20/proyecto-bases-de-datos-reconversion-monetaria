/* Archivo: reconversion.sql
 * Autores: Elizabeth Mendoza C.I: V -
 			Henry J. Fontalba C.I: V - 21.584.468
 * Objetivos: Script de la base de datos que contiene
 * toda la informacion sobre la reconversion monetaria
 */

 /* CREANDO LA BASE DE DATOS */


 CREATE DATABASE reconversion TEMPLATE='template1';

 /* conectando la BD */

 \c reconversion

 /* se crea el esquema de la BD */

 CREATE SCHEMA reconversion_mon;

 /* creo los dominios */

CREATE DOMAIN reconversion_mon.cadenas_cortas varchar(50);
CREATE DOMAIN reconversion_mon.cadenas_medias varchar(100);
CREATE DOMAIN reconversion_mon.cadenas_largas varchar(500);
CREATE DOMAIN reconversion_mon.medios varchar(10)
		CHECK (VALUE IN ('TV', 'RADIO'));
CREATE DOMAIN reconversion_mon.Marcos varchar(50)
		CHECK (VALUE IN ('Decretos', 'Resoluciones'));
CREATE DOMAIN reconversion_mon.Denominacion numeric(8)
		CHECK (VALUE IN (0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500));

/* creo las tablas de la BD */

CREATE TABLE reconversion_mon.cono_monet(
	nombre_cono reconversion_mon.cadenas_cortas,
	valor reconversion_mon.Denominacion,
	fecha_lanz date not null,
	cod numeric,
	PRIMARY key (valor,nombre_cono),
	foreign key (cod) references reconversion_mon.marco_legal
	on delete cascade
	on update cascade
);

CREATE TABLE reconversion_mon.marco_legal(
	cod_marco numeric primary key,
	fecha_emi date not null,
	descripcion reconversion_mon.cadenas_largas not null,
	URL reconversion_mon.cadenas_cortas not null,
	tipoMarco reconversion_mon.Marcos not null
);
CREATE TABLE reconversion_mon.red_social(
	nombre_red reconversion_mon.cadenas_cortas primary key,
	nombre_usuario reconversion_mon.cadenas_cortas not null,
	clave reconversion_mon.cadenas_cortas not null,
	fecha_pub date not null,
	hora_pub time not null
);

CREATE TABLE reconversion_mon.personal(
	id_emp numeric(8) primary key,
	cedula reconversion_mon.cadenas_cortas not null,
	nombre reconversion_mon.cadenas_medias not null,
	cargo reconversion_mon.cadenas_medias not null 
);


CREATE TABLE reconversion_mon.localidad(
	id_recep numeric(8) primary key,
	direccion_recep reconversion_mon.cadenas_medias not null,
	tipo_recep reconversion_mon.cadenas_medias not null
);


CREATE TABLE reconversion_mon.infografia(
	tipo_infog reconversion_mon.cadenas_cortas,
	titulo reconversion_mon.cadenas_medias,
	primary key (tipo_infog,titulo),
	fecha_elab date not null,
	costo numeric not null
);

CREATE TABLE reconversion_mon.cunas(
	nombCun	reconversion_mon.cadenas_medias,
	nombCan reconversion_mon.cadenas_medias,
	primary key (nombCun,nombCan),
	foreign key(nombCan) references reconversion_mon.medioComunicacion
	on delete cascade
	on update cascade,
	tema reconversion_mon.cadenas_medias not null,
	durac numeric not null,
	fecha_trans date not null
);

CREATE TABLE reconversion_mon.autores(
	nombAutor reconversion_mon.cadenas_cortas,
	infoTit reconversion_mon.cadenas_medias,
	PRIMARY KEY (nombAutor,infoTit),
	foreign key (infoTit) references reconversion_mon.infografia
	on delete cascade
	on update cascade,
	foreign key(infoTip) references reconversion_mon.infografia
	on delete cascade
	on update cascade
);

CREATE TABLE reconversion_mon.medioComunicacion(
	nombCanal reconversion_mon.cadenas_cortas primary key,
	numCanal numeric(8) not null,
	tipoMedio reconversion_mon.medios not null
);

CREATE TABLE reconversion_mon.billetes(
	nombBi reconversion_mon.cadenas_cortas,
	valBi reconversion_mon.Denominacion,
	PRIMARY KEY (nombBi,valBi),
	foreign key (valBi) references reconversion_mon.cono_monet
	on delete cascade
	on update cascade,
	fechaLan date not null,
	foreign key (fechaLan) references reconversion_mon.cono_monet
	on delete cascade
	on update cascade,
	serialBi numeric not null,
	regPerf reconversion_mon.cadenas_medias not null,
	marcAgua reconversion_mon.cadenas_largas not null,
	microText reconversion_mon.cadenas_largas not null,
	hiloSeg reconversion_mon.cadenas_largas not null,
	fondoAntscan reconversion_mon.cadenas_largas not null,
	imgVisF reconversion_mon.cadenas_medias not null,
	impTipF reconversion_mon.cadenas_largas not null,
	impTipMag reconversion_mon.cadenas_largas not null
);

CREATE TABLE reconversion_mon.seDistribuye(
	titInfo reconversion_mon.cadenas_medias,
	cantEjemplar numeric,
	primary key (codRec,tipInfo,titInfo),
	foreign key (titInfo) references reconversion_mon.infografia
	on delete cascade
	on update cascade,
	tipInfo reconversion_mon.cadenas_cortas,
	foreign key(tipInfo) references reconversion_mon.infografia
	on delete cascade
	on update cascade,
	codRec numeric(8), 
	foreign key(codRec) references reconversion_mon.localidad
	on delete cascade
	on update cascade
	
);

CREATE TABLE reconversion_mon.PublicaEn(
	idEmp numeric(8),
	foreign key (idEmp) references reconversion_mon.personal
	on delete cascade
	on update cascade,
	nombRed reconversion_mon.cadenas_cortas,
	PRIMARY KEY (nombRed,idEmp),
	foreign key (nombRed) references reconversion_mon.red_social
	on delete cascade
	on update cascade,
	textoMensaje reconversion_mon.cadenas_largas,
	imgUsada boolean not null
);

