/* Currying:
   - Funktion werden in Reason standardmäßig gecurried
     d.h.:
 */
let f = (x, y, z) => Js.log(j`x: $x y: $y z: $z`)

f("hallo", "wie", "gehts")

/*
  wird zu:
 - let f = x => y => z => Js.log({j|x: $x y: $y z: $z|j});
 */
/*
  *
 Currying mit Labelled/Named Parametern:
 */
let f: /* Signatur: */
(~x: string, ~y: string, ~z: string) => unit = /* Implementierung im Funktions-Rumpf: */
(~x, ~y, ~z) => {
  print_endline("x: " ++ x)
  print_endline("y: " ++ y)
  print_endline("z: " ++ z)
}

let g: (~x: string, ~y: string) => unit = f(~z="z")

g(~y="y", ~x="x")

/*
 Anwendungsfälle für Currying:
 - Dependency Injection:
 */
/* Einfache Funktion mit named Parameters */
let greeter = (~greeting: string, ~persons: list<string>) =>
  List.map(name => j`$greeting, $name`, persons)

/* Dependency Injection wird durch Currying möglich: */
let merryXmas = greeter(~greeting="Merry Christmas")

/* Funktion mit (pre-set) einem bereits gesetztem Argument
 und einem freien restlichen Parameter */
let xmasWishes = merryXmas(~persons=list{"Alex", "Sophie"})

Js.log(xmasWishes)
