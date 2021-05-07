/*
    Modules:
 */
/*
  ## Modul-Dateien:
   - Per default stellt in Reason jede Quellcode-Datei
   ein Modul dar (Modul-Dateien)
   - Per default werden alle top-level Variablen in einer
   Modul-Datei exportiert.
   - Modul-Dateien werden normalerweise kleingeschrieben,
   CamelCase (meinModule.re)
   - Der Modul-Name einer Modul-Dateien entspricht dem
   Datei-Namen (aber großgeschrieben).
 */
/*
 ## Unter-Module in einer Modul-Datei:
 module MeinModul = { ... }
 */
module Zoo = {
  type animal = {
    name: string,
    species: string,
  }
  let animals = ref((Hashtbl.create(0): Hashtbl.t<string, string>))
  let addAnimal = animal => Hashtbl.add(animals.contents, animal.name, animal.species)
  let visitAnimals: (animal => unit) => unit = f =>
    animals.contents |> Hashtbl.iter((name, species) => f({name: name, species: species}))
  let zooName = "Zur Schlangengrube"
  let description = "Kaninchen Stall mit angeschlossenem Terrarium"
  let privateStuff = ["private", "keep", "out"]
}

/* Add some animals to the zoo */
list{
  ("Max", "Meerschweinchen"),
  ("Josef", "Kaninchen"),
  ("Maxine", "Maus"),
  ("Klara", "Schlange"),
} |> List.iter(((name, species)) =>
  /* Call Module function: */
  Zoo.addAnimal({name: name, species: species})
)

/* Call Module function: */
Zoo.visitAnimals(({name, species}) => Js.log(j`name: $name von Spezies: $species`))

/*
  ## Importieren:
  - werden großgeschrieben
  - Module werden über ihren Modul-Namen referenziert.
  - Ein Modul kann auch nur für eine Expressions referenziert
  werden: MyModule.(....)
  - Ein Modul kann auch für eine ganze Modul-Datei importiert werden:
  open MyModule;
 */
Js.log(Zoo.zooName)

{
  open Zoo
  Js.log(j`ZooName: $zooName und Description: $description`)
}

open Zoo

Js.log(j`ZooName: $zooName und Description: $description`)

/*
  Signatur eines Modules: Module-Interface
  - werden großgeschrieben
  - https://reasonml.github.io/guide/language/module/
  - Put the signature definitions of a module file
  in a corresponding *.rei-file
  - Alternatively you can define the module interface via:
  module type EstablishmentType = {
   type profession;
   let getProfession: profession => string;
 };
 */
module type TransportMittel = {
  let name: string
  let preis: float
}

module Auto: TransportMittel = {
  /* Nicht veröffentlicht über die Modul-Signatur: */
  let automarke = "BrummBrumm Unlimited"
  /* Über die Modul-Signatur veröffentlicht */
  let name = "auto von " ++ automarke
  let preis = 14000.99
}

module Kutsche: TransportMittel = {
  /* Nicht veröffentlicht über die Modul-Signatur: */
  let pferdName = "Mr.Ed"
  /* Über die Modul-Signatur veröffentlicht */
  let preis = 900.77
  let name = j`"kutsche mit $pferdName"`
}

let name = Auto.name

let preis = Auto.preis
/* Nicht veröffentlicht über das Module-Interface: */
/* Daher auch nicht zugänglich */
/* let automarke = Auto.automarke; */
/*
 *
  Bemerkungen:
  Every .rei file is a signature
     Similar to how a react.re file implicitly defines
     a module React, a file react.rei implicitly defines
     a signature for React.
     If react.rei isn't provided, the signature of
     react.re defaults to exposing all the fields
     of the module. Because they don't contain
     implementation files, .rei files are used
     in the ecosystem to also document the public
     API of their corresponding modules. */
/*
  file react.re (implementation. Compiles to module React):
    type state = int;
    let render = (str) => str;
 */
/* file react.rei (interface. Compiles to signature of module React):
       type state = int;
       let render: str => str;
 */
