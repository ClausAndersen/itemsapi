CREATE USER itemdbuser WITH PASSWORD 'myPassword';

CREATE DATABASE itemdb WITH OWNER itemdbuser ENCODING 'UTF8';

\connect itemdb itemdbuser;

/* 
   Følgende felter skal bruges hvis man skal udveksle informationer med andre
   danske muséer via DublinCore:
   
     * Genstand nr. / itemid
     * Betegnelse / itemheadline
     * Modtagelses dato/ itemreceived date
     * Datering fra / itemdatingfrom date
     * Datering til / itemdatingto date
     * Beskrivelse / itemdescription
     * ref. til Donator / donatorid
     * ref. til Producent / producerid
     * Geografisk område /  ???-id
     * ref. til en eller flere Emnegrupper / "itemsubjects"

   donator og producer er ikke relationer endnu for at simplificere opgaven
   Ligeledes mangles "itemsubjects".
*/
CREATE TABLE items (
    itemid serial PRIMARY KEY,             -- Kommer fra DublinCore (Genstand nr.)
    itemheadline varchar(160) NOT NULL,    -- Kommer fra DublinCore (Betegnelse)
    itemdescription text,                  -- Kommer fra DublinCore (Beskrivelse)
    itemreceived timestamp,                -- Kommer fra DublinCore (Modtagelses dato)
    itemdatingfrom timestamp,              -- Kommer fra DublinCore (Datering fra)
    itemdatingto timestamp,                -- Kommer fra DublinCore (Datering til)
    donator varchar(320),                  -- Afledt af DublinCode (donatorid)
    producer varchar(320),                 -- Afledt af DublinCode (producerid)
    postnummer smallint,                   -- Afledt af DublinCore (Geografisk område)
    created_at timestamp DEFAULT current_timestamp
);

/* Dummy data */
INSERT INTO items (itemheadline, itemdescription) VALUES ('DASK', 'DASK var Danmarks første computer. Udviklingen af DASK startede i 1953, da nogle danske ingeniører tog til Stockholm for at følge arbejdet med konstruktion og programmering af dens forbillede, den svenske computer BESK. DASK blev under betegnelsen elektronhjerne første gang præsenteret for offentligheden ved en demonstration i Forum i september 1957 og blev et par år senere for alvor offentlig kendt, da den ved folketingsvalget i 1960 blev brugt til at forudsige og analysere valgresultatet (se Folketingsvalg). DASK lignede i sin konstruktion sine to forbilleder, IAS computeren ved Princeton University og BESK i Stockholm. DASK var baseret på radiorør (ca. 2500 stk.) og havde et ganske enkelt maskinsprog. Senere blev en ALGOL-oversætter implementeret. Dens arbejdslager bestod af et ferritkernelager på kun ca. 5 Kbyte, som blev udvidet med 5 Kbyte ROM med rutiner til Algol-systemet. Arbejdslageret var suppleret med et baggrundslager, et tromlelager med kapacitet ca. 40 Kbyte. Indlæsningen af data foregik på papirhulstrimmel, udlæsningen på papirhulstrimmel eller på elektrisk skrivemaskine. I 1958 blev der koblet en enhed til DASK, så hulkort kunne bruges både til ind- og uddata. I årene 1959-60 blev der endvidere etableret tilslutninger til fire magnetbåndstationer. DASK fungerede i ca. 10 år som servicecentermaskine og til udviklingsopgaver. Den blev demonteret i 1967. Dele af DASK, der i sin helhed fyldte en hel spisestue og vejede 3,5 t, kan ses på Teknisk Museum i Helsingør.');
INSERT INTO items (itemheadline, itemdescription) VALUES ('GIER', '1959-61 udviklede Regnecentralen sin anden datamaskine, GIER. Det var en 2. generations maskine opbygget af transistorer (i stedet for radiorør, som var grundlaget for 1. generations maskiner). Teknologien gjorde, at GIER kun fyldte ca. et garderobeskab, hvor DASK fyldte en hel spisestue. I anledning af 50-året for den første Gier har foreningen udgivet en bog "GIER 50 år" med en lang række originale beretninger og artikler om, hvordan Gier blev udviklet og serieproduktionen startet.');
INSERT INTO items (itemheadline, itemdescription) VALUES ('RC 4000', 'Henrik Jacobsen skrev en RC4000 simulator i begyndelsen af 1990erne. Det er en "virtuel" simulator, forstået sådan at den ikke simulerer RC4000s fysiske opbygning, men efterligner de logiske funktioner. Hensigten var at udvikle et værktøj som kunne erstatte en RC8000, med brug af datidens hardware; derfor er der gjort meget for at hastighedsoptimere koden. Det lykkedes; på en 486/66MHz PC er hastigheden af den simulerede RC4000/RC8000 ca. det dobbelte af en RC8000/55.');

