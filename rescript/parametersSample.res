/* Links: https://reasonml.github.io/guide/language/function */
/* Standard Positional Arguments */
let test1 = a => Js.log(j`test1: $a`)

test1(22)

let test2 = (a, b) => Js.log(j`test2: $a, $b`)

test2(1, 2)

/* Labeled Arguments:
   - Bei Labeled/Named Parametern wird das Label ein Teil der
     Funktions-Signatur:
 */
let f: /* Die Labels sind ein Teil der Signatur */
(~x: 'a, ~y: 'b) => unit = /* Funktionsrumpf: Implementierung zur Signatur */
(~x, ~y) => Js.log(j`x: $x, y: $y`)

/* Currying ist auch möglich mit Labeled Arguments */
let fMitX: /* Signatur */
(~y: 'a) => unit = /* Funktionsrumpf mit Impl. der Signatur */
f(~x="Was ist das?")

fMitX(~y=0)

let test3 = (a, b, ~c) => Js.log(j`test3: $a, $b, $c`)

test3(1, 2, 3)

test3(~c=3, 1, 2)

test3(1, ~c=3, 2)

/*
 Optionale Parameter: ~a=?
 - Labeled/Named Parameter können optional gemacht werden.
 - Die Information, dass ein Parameter optional ist, wandert
   (zusammen mit dem Label) in die Signatur der Funktion,
   d.h.: ~label:option(typ)=?
 - Optionale Parameter habe den Typ option(...)
 - Beim Aufruf allerdings wird nicht ein Argument vom Typ
   option(...) übergeben, sondern entweder keins (None) oder
   der eigentliche Wert, welcher implizit in ein option verpackt
   wird: f(~label=wert) statt f(~x=(Some wert))
 - Will man einen Wert vom Typ option(...) als optionalen Parameter
   als Argument übergeben, dann muss dieser vorher erst mit "?"
   beim Aufruf markiert werden: f(~x=?(Some(wert)))
 */
let f: /* Signatur aka Interface on function-level */
(~x: option<'a>=?, ~y: 'b) => unit = /* Signature-Implementation aka Function-Body */
(~x=?, ~y) =>
  switch x {
  | Some(wert) => Js.log(j`x: $wert, y: $y`)
  | None => Js.log(j`x: None, y: $y`)
  }

/*
 Problem hier: f(~y="...") wird nicht mit ~x und ~y aufgerufen
 sondern nur mit ~y und damit gecurried.
 D.h. der optionale Parameter ~x wird nicht mit None
 initialisiert, sondern erst gar nicht übergeben.
 */
let g: /* Signatur: ~x wurde nicht gesetzt mit None */
(
  ~x: 'a=?,
) => unit = /*
    Funktion mit optionalem Parameter wurde gecurried,
    anstatt dieser mit None initialisiert wurde
 */
f(~y=`Überraschung`)

/*
 Der optionale Parameter muss hier leider explizit gesetzt,
 um das defaultmäßige Currying zu verhindern:
 */
g(~x=?None)

/*
   Die Lösung, um das default-mäßige Currying
   eines Funktions-Aufrufs zu unterbinden
   bei der Verwendung eines optionalen Parameters, findet sich in
   der der Ocaml Spezi:
   "If a non-labeled argument is passed and its corresponding
   parameter is preceded by one or several optional parameters,
   then these parameters are defaulted, i.e. !!! the value
   None will be passed for them.!!!"
 */
let f: /* Signature mit optionalem Parameter */
(
  ~x: option<'a>=?,
  ~y: 'b,
  unit,
) => unit = /* Konvention:
     () wird oftmals als positionaler Parameter in OCaml benutzt
     bei optionalen Parametern, um beim Funktionsaufruf zu
     signalisieren, dass alle Argumente übergeben wurden
     (und die optionalen Parameter mit None initialisiert werden
     sollen) und der Aufruf !!nicht!! gecurried
     werden soll
 */
(~x=?, ~y, ()) =>
  switch x {
  | Some(wert) => Js.log(j`x: $wert, y: $y`)
  | None => Js.log(j`x: None, y: $y`)
  }

/* Erstmal hier der Aufruf mit Currying: */
let g: /* Signatur mir optionalem Parameter */
(~x: option<'a>=?, unit) => unit = /* Funktions-Rumpf d.h. Signatur-Implementierung */
f(~y="Schon wieder Curry auf Aufruf.")

g(~x=?None, ()) /* Aufruf ohne Curry */

/* Jetzt signalisiert hier der positionale Parameter () beim
   Aufruf, dass beim Aufruf das ganze Gericht
   und zwar ohne Curry serviert werden soll: */
f(~y="Yooo. Heute mal kein scharfes Curry auf den Aufruf.", ())

/* Achtung!!
   Optionale Parameter sind in der Parameterliste
   vom Typ: (~label:option(typ)=?)=>...
   und deswegen kommt das übergebene optionale Argument
   auch im Funktionsrumpf als Variable "label" vom Typ
   option('a) an und muss also mittels Pattern-Matching
   erst ausgepackt werden:
 */
let optionalToString = optional =>
  switch optional {
  | Some(x) => "Some: " ++ x
  | None => "None"
  }

let f: /* Signatur mit positionalem Parameter am Ende */
(~optional1: string=?, ~optional2: string=?, 'a) => unit = /* Implementierung */
(~optional1=?, ~optional2=?, mandatory) => {
  let optional1 = optionalToString(optional1)
  let optional2 = optionalToString(optional2)
  Js.log(j`optional1: $optional1, optional2: $optional2, mandatory: $mandatory`)
}

/* Kein Currying, da positionaler Parameter am Ende */
f("hallo") /* Ouput: optional1: None, optional2: None, mandatory: hallo */

/*
 *
 Parameter mit Default-Value: Labeled Parameter
 */
let times = (n, f) => {
  let rec aux = (acc, f) =>
    if acc > 0 {
      f()
      aux(acc - 1, f)
    }
  aux(n, f)
}

let test6 = (~spruch: string="Oben ist oben", repCount: int) =>
  /* Da das Argument bei einem Parameter mit Default-Wert
      immer vorhanden sein wird durch den Fallback
      zum default-Wert, wird hier der optionale Parameter
      auch nicht ein options('a) eingepackt
 */
  times(repCount, () => print_endline(spruch))

test6(10)

test6(~spruch="Atmen ist gesund", 2)

/*
 *
 Syntactic Sugar für Funktions-Aufrufe: Punning
 - Punning (engl. für Wortspiel) bedeutet:
 Der Variablen-Name stimmt mit dem Parametername einer
 eines Labeled-Parameters bei einer Funktion überein,
 und muss deswegen nicht nochmal explizit wiederholt
 werden.
 */
type katze = {
  name: string,
  alter: int,
  specialAttack: unit => string,
}

let feller = {name: "Max", alter: 3, specialAttack: () => "kratzen"}

let pfoter = {name: "Moritz", alter: 2, specialAttack: () => "miauen"}

let mapToFeller = (~feller: katze, ~pfoter: katze): string => feller.name

/*
 Beispiel für Punning:
 - mapToFeller hat 2 gelabelte Parameter:
 feller & pfoter
 - Es werden die gleichnamigen Variablen
 feller & pfoter an die Funktion übergeben
 - Da es in Reason Punning gibt für gelabelte
 Parameter, muss man nicht schreiben:
 f(~arg1=arg1, ~arg2=arg2, etc.) sondern kann verkürzen auf:
 f(~arg1, ~arg2, etc.)
 */
/* Falls Label == Variable-Name, Funktions-Aufruf ohne explizite Zuweisung des Labeled Parameter */
mapToFeller(~pfoter, ~feller) |> print_endline

/*
  *
   Funktions-Überladung ist nicht möglich in Reason:
   Funktions-Überladung: der derselbe Funktions-Name mit anderer Signatur (Parameterliste)

   Stattdessen gibts nur: Funktions-Überschreibung aka Shadowing
 */
let f = (x: string) => print_endline(x)

f("elf")

let f = (x: int) => x + 1 |> (value => Js.log(j` x + 1 : $value`))

/* f("elf"); --> Fehler, da f geshadowed wird */
f(11)
