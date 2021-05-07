/*
 Lists: [ a, b, c, ... ]
 - immutable
 - konzipiert für sequentieller Zugriff aber nicht wahlfreiem Zugriff
 - container für Daten gleichen Typs, d.h. homogen
 - einfach verkettet
 */
let logList = list => list |> Array.of_list |> Js.Array.joinWith(", ") |> Js.log

/*
 *
 Literal-Schreibweise:
 - [a, b, c]
 */
let meineListe = list{"a", "b", "c"}

logList(meineListe)

/*
 *
 Prepend-Operator via Destructuring-Operator ... in Reason:
 - [a, b, c, ...liste]
 */
let meineListe = list{"anfang", ...meineListe}

logList(meineListe)

/*
 *
 Listen-Konkatenierung:
 - List.concat([liste1, liste2, ...])
 */
let meineWeitereListe = list{"Ente", "gut", "alles", "gut"}

let listenConcatenated = List.concat(list{meineListe, meineWeitereListe})

logList(listenConcatenated)

@ocaml.doc("
 * Wahlfreier Zugriff bei Listen in-effizient in Reason via:
 * - List.nth(index, liste);
 *
 * Sequentieller Zugriff bei [a, b, c] effizient.
 * Listen-Zugriff über Destructuring.
 * Für wahlfreien Zugriff sind Arrays besser: [|a, b, c|]
 ")
let head = List.hd(listenConcatenated)

Js.log(head)

let fuenfter = List.nth(listenConcatenated, 4)

Js.log(j`fünfter : $fuenfter`)

/*
 * Listen-Länge:
 * List.length(liste)
 */
let length = List.length(listenConcatenated)

Js.log(j`length : $length`)

if List.length(listenConcatenated) > 4 {
  /*
   Destructuring the list via pattern matching:
   let [a, b, c, ...rest] = liste;
 */
  let list{a, b, c, d, ...rest} = listenConcatenated
  Js.log(j`a: $a, b: $b, c: $c, d: $d`)
  logList(rest)
}

/*
 Arrays: [| a, b, c, ... |]
 - konzipiert für schnellen wahlfreien Zugriff mittels Index
 - homogener Datencontainer mit Elementen gleichen Typs
 - mutable
 - mapt 1:1 zu einem JS-Array, d.h. Js.Array.t('a)
 - feste Länge
 */
let meinArray: array<string> = ["a", "b", "c", "d"]

Js.log(meinArray)

/*
 *
  Wahlfreier Zugriff über Index:
  - array[index]
 */
Js.log(meinArray[2])

/*
 *
 Länge eines Arrays:
 - Array.length(array)
 */
Js.log(Array.length(meinArray))

/*
  *
  Mutable via Zuweisung:
 - array[index] = newValue;
 */
meinArray[3] = "wurst"

Js.log(meinArray)

/*
  *
  Implzite Umwandlung eines Reason-Arrays array('a) <--> Js-Array Js.Array.t('a):
 - ein array('a) ist nur ein Alias für ein Js.Array.t('a)
 - kein Typecast notwendig für Reason-Arrays
 */
let logJsArray: Js.Array.t<'a> => unit = input =>
  input |> Js.Array.joinWith(", ") |> (v => Js.log(j`logJsArray: $v`))

/* Impliziter Typ-Cast von: array(string) --> Js.Array.t(string) */
logJsArray(meinArray)

/* Impliziter Typ-Cast von: Js.Array.t(int) --> array(int) */
let nochnArray: array<int> = %raw("[1,2,99,1000,-4]")

let logReasonArray: array<int> => unit = logJsArray

logReasonArray(nochnArray)

/* Records */
/* Punning
      - "Punning" refers to the syntax shorthand for when a label and a value are the same.
      For example, in JavaScript, instead of doing return {name: name},
      you can do return {name}.
 */
type werwolf = {
  haare: string,
  geruch: string,
}

let haare = `überall`

let geruch = "streng"

/* Punning: Variablen-Name stimmt überein mit dem Label/Field-Namen */
let meAlsWerwolf = {haare: haare, geruch: geruch}

/* Deklaration eines Records */
type meinRecordType<'a> = {
  /* Some immutable fields */
  field1: int,
  field2: string,
  /* Mutable field */
  mutable field3: bool,
  /* Generic Record */
  field4: 'a,
}

/*
 Erzeugung eines Record-Objekts:
 - alle Felder müssen initialisiert werden
 */
let meinRecordObject: meinRecordType<'a> = {
  field1: 1,
  field2: "zwei",
  field3: false,
  field4: Js.Date.now(),
}

Js.log(meinRecordObject)

/* Zuweisung eines mutable fields */
meinRecordObject.field3 = true

Js.log(meinRecordObject)
