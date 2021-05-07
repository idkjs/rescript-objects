/* Type Declarations in Reason */
/*
 Generelles:
 - Typen werden immer !!kleingeschrieben!!: type meinTyp = ...
 - Konstruktoren werden immer grossgeschrieben: type meinTyp = Pizza;
 - ein Typ ist eine zulässige Menge von Werten
 - Konstruktoren sind dabei die Werte innerhalb dieser Menge (aka Datentyp)
 */
/*
 Konstruktoren in Varianten:
 - werden immer !!grossgeschrieben!!
 - stellen die Werte in einem Datentyp dar
 - können Container sein, die wiederum Werte
   anderer Datentypen aufnehmen können
 - Varianten müssen einen Konstruktor haben
 */
/* Typ-Deklaration */
type fenster =
  | Glas /* Konstruktor */
  | Luft(list<string>) /* Konstruktor als Daten-Container */

let verandaTuer: fenster = Glas

let holzhuettenFenster = Luft(list{"Pollen", "Insekten", `Kälte`})

/*
 *
 Tuples
 */
type personData = (int, string, float) /* Type-ALias */

/* Implizit vom Typ personData: */
let mrMax: (int, string, float) = (22, "Max Musterman", 1.77)

let logDenMal: personData => unit = pData => {
  /* Destructuring tuple: */
  let (age, name, height) = pData
  Js.log(j`$name ist $age alt und ist $height m gross.`)
}

/* Kein Type-Cast erforderlich, bei einem Type-Alias: */
logDenMal(mrMax)

/*
 *
 Generics bzw. Parametrized Types: typ('a)
 - Typ-Parameter sind Platzhalter für konkrete Typen und
   werden mittels Apostroph deklariert: 'a
 - Generische Typen bzw. Generics werden ähnlich zu Funktionen deklariert:
   type typ('a, 'b, ...) = ...
 - Der Parameter-Typ wird dabei bei der Typ-Deklaration durchgereicht:
   type typ('a) = list(array('a))
 */
/* Generischer Typ: */
type schliessbar<'a> =
  | Geschlossen('a)
  | Offen('a)

let schliesse: 'a => schliessbar<'a> = ding => Geschlossen(ding)

let oeffne: 'a => schliessbar<'a> = ding => Offen(ding)

/*
 Der konkrete Typ wird dann bei der Verwendung des Generics
 via Type Inference ermittelt und implizit gesetzt.
 */
let offenesHolzhuettenFenster = f => Offen(f)

let geschlossenesVerandaFenster = f => Geschlossen(f)

/* Generics werden oft als Abstraktion bei DatenContainer benutzt, um
   damit Funktionen zu definieren, die generisch
 */
let container: list<string> = list{"weiss", "nix", `über`, "string", "theorie"}

/*
 Generischer Typ result('a, 'b) mit 2 ParameterTypen:
 */
type result<'a, 'b> =
  | Ok('a)
  | Error('b)

/*
 Record-Typ:
 */
type myPayload = {data: string}

/*
 Generischer List-Typ mit Parameter-Typ für die
 */
type myPayloadResults<'errorType> = list<result<myPayload, 'errorType>>

let payloadResults: myPayloadResults<string> = list{
  Ok({data: "hi"}),
  Ok({data: "bye"}),
  Error("Something wrong happened!"),
}

/* Rekursive Datentypen */
type rec tree<'a> =
  | Node(tree<'a>)
  | Leaf('a)

/* Mutual Recursive Types */
/* Normalerweise muss ein Typ erst deklariert sein,
 damit man ihn verwenden kann in Reason. */
/* Mutually Recursive Types
 Just like functions, types can be mutually recursive through and: */
type rec student = {taughtBy: teacher}
and teacher = {students: list<student>}
