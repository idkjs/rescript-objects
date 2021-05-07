/*
 Pattern Matching
 */
/* Some bindings to JS: */
@module("faker") @scope("name")
external findName: unit => string = "findName"

@module("faker") @scope("address")
external findCity: unit => string = "city"

@module("faker") @scope("company")
external findCompanyName: unit => string = "companyName"

/*
 (1) Destructuring variants
 */
type ort =
  | /* Variants as constants */
  Hier
  | Da
  | Drueben

let wo = Hier

let reiseEtappe: /* Signature */
ort => int = /* Implementation */
ort =>
  /* Pattern matching */
  switch ort {
  /* Destructuring */
  | Hier => 1
  | _ => 2
  }

wo |> reiseEtappe |> string_of_int |> print_endline

/*
 (2) Destructuring Variants containing values
 */
type people =
  /* Variants using Constructors as Data Containers
   (Tuple-like-style, order is important) */
  | School(int, string, string)
  | University(int, string, string)
  | Worker(int, string, string, string)

/* Helper func: f^n(arg) */
let rec apply = (n, f, arg) =>
  switch n {
  | 1 => f(arg)
  | n => apply(n - 1, f, f(arg))
  }

let generatePeople = list => {
  let age = Js.Math.random_int(0, 80)
  let name = findName()
  let city = findCity()
  switch age {
  /* Prepend new element to list: */
  /* cases using guards "when" */
  | age
    if age < 18 => /* Reason's prepend operation via JS-like destructuring:
          [head, ...list]
 */
    list{School(age, name, city), ...list}
  | age if age < 30 => list{University(age, name, city), ...list}
  | age if age < 80 => list{Worker(age, name, city, findCompanyName()), ...list}
  }
}

let logPeople: /* Signature */
list<people> => unit = /* Implementation */
ppl =>
  ppl
  /* Function Currying of List.iter into: List.iter(f) */
  |> List.iter(p =>
/* Pattern Matching */
    switch p {
    /* Destructuring Variants via Constructors */
    | School(age, name, city) => Js.log(j`$name, aged $age  going to school in $city`)
    | University(age, name, city) => Js.log(j`$name, aged $age going to uni in $city`)
    | Worker(age, name, city, company) =>
      Js.log(j`$name, aged $age going to work at $company in $city`)
    }
  )

let bunchOfPpl = apply(100, generatePeople, list{})

bunchOfPpl |> logPeople

/* Guards in Pattern Matching via switch */
type payload =
  | BadResult(int)
  | GoodResult(string)
  | NoResult

let selectable = [GoodResult("Product shipped!"), BadResult(500), BadResult(404), NoResult]

let data = selectable[Js.Math.random_int(0, Array.length(selectable))]

let isServerError = code => code >= 500

let message = switch data {
| GoodResult(_theMessage) => "gut"
/* Guard "when": Prüfung des Falls auf eine Bedingung: */
/* !! Erst Destructuring, um den enthaltenen Wert zu extrahieren */
| BadResult(errorCode) if isServerError(errorCode) => "schlecht"
  /* !! dann den Wert prüfen mittels eines Guards */
| BadResult(_errorCode) => "keine Ahnung"
| NoResult => "kein Ergebnis"
}

Js.log(j`message: $message`)

/*
 * Exceptions und Pattern Matching
 Match on Exceptions: | exception x => ...
 If a function throws an exception (covered later), you can also match on that, in addition to the function's normally returned values.
 */
let myItems = list{"item1", "item2", "item3"}

let theItem = "wasser"

switch List.find(i => i === theItem, myItems) {
| item => print_endline(item)
| exception Not_found => print_endline("No such item found!")
}
