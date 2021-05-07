/*
 Links:
 - https://github.com/glennsl/bucklescript-cookbook

 - Bucklescript-Cheetsheet:
  https://bucklescript.github.io/docs/en/interop-cheatsheet.html

 - Converting JS into Reason:
  https://reasonml.github.io/guide/javascript/converting
 *
 */
type auto

/*
 * Bind the CONSTRUCTOR from JS to a Reason function:
 * - [@bs.new]
 */
@module @new
external createAuto: (~marke: string) => auto = "../../../src/js/auto"

let brumbrum = createAuto(~marke="BrumBrum")

Js.log(brumbrum)

/*
 * Import GLOBAL JS-variable in the scope into Reason:
 * - [@bs.val]
 */
%%raw(`const val = { secret: "ley" }`)

@val external valley: 'a = "val"

Js.log(valley["secret"])

/*
 Convert a Js.NULLABLE RETURN-VALUE in JS to OPTION-type in Reason
 - [@bs.return nullable]
 */
%%raw(`const test = (input) => (input==="nix") ? undefined : "unleer"`)

@val("test") @return(nullable)
external kannseinLeer: string => option<string> = "test"

list{"nix", "drin"} |> List.map(wert =>
  switch kannseinLeer(wert) {
  | Some(wert) => Js.log(j`wert gefunden : $wert`)
  | None => Js.log("wert leer")
  }
)

/*
 * Create Js-Objekt in Reason:
 * - { "prop1" : "val" , "prop2": val }
 */
%%raw("const values = obj => Object.values(obj)")

@val external keys: 'a => Js.Array.t<string> = "values"

let jsObject = {"art": "test", "gueltig": true, "id": 284}

Js.log(jsObject["gueltig"])

/*
  Create Js-Objekt-Types in Reason:
  - {. "field": type, "field": type }
  - mutable fields: [@bs.set]
  - Methods of Js-Objekts: [@bs.meth]
 */
type jsOb = {@set "name": string, @meth "jubeln": unit => unit}

%%raw("const obj = { name: `Rudolf`, jubeln: () => console.log(`Ich bin ${obj.name}.`)}")

@val external obj: jsOb = "obj"

obj["name"] = "Vera"

obj["jubeln"]()

/*
 * import OBJECT-METHODs as functions into Reason
 * - [@bs.send] : 1st argument in function parameterlist is the object
 */
%%raw(`const wolf = { name: "gang", getData: (title, age, szn) =>
  \`\${title} wolf\${wolf.name}
Alter: \${age}
Sozialversicherungsnr.: \${szn}\`};`)

type wolf

@val external testObjekt: wolf = "wolf"

@send
external getDataFromTestObject: (wolf, ~title: string, ~age: int, ~szn: string) => string =
  "getData"

let nameOfTestObjekt = testObjekt |> getDataFromTestObject(~age=54, ~szn="444", ~title="Herr")

Js.log(nameOfTestObjekt)

/*
 *  Import VARIADIC JS-functions into Reason by wrapping arguments
 *  into a Reason-Array:
 *  - [@bs.splice]
 */
%%raw(`
const verpluescher = (...tiere) => tiere.map(tier => "Plüsch" + tier.toLowerCase()).join(", ")
`)

@val @variadic
external verpluescher: array<string> => string = "verpluescher"

Js.log(verpluescher(["Baer", "Hai", "Kamel", "Loewe"]))

/*
 * import a DEFAULT function from a ES6-MODULE-EXPORT:
 * - [@bs.module "module-path"] external fn : <signature> = "default"
 */
let default = {"pommes": "fritz", "ungesund": true}

/*
 * import a DEFAULT function from a COMMONJS-MODULE-EXPORT
 * - [@bs.module] external fn : <signature> = <module-path>
 */
type fahrrad

@module @new
external createFahrrad: string => fahrrad = "../../../src/js/fahrrad"
/*
  Bucklescript-Cheetsheet
  https://bucklescript.github.io/docs/en/interop-cheatsheet.html
 */
