/*
  Create Js-Objekt-Types in Reason:
  - {. "field": type, "field": type }
  - mutable fields: [@bs.set]
  - Methods of Js-Objekts: [@bs.meth]
 */
type jsOb = {@set "name": string, @meth "jubeln": unit => unit}

%%raw(
  "const obj = { name: `Rudolf`, jubeln: () => console.log(`Ich bin ${obj.name}.`)}"
)

@val external obj: jsOb = "obj"

obj["name"] = "Vera"
obj["jubeln"]|>ignore


type position = {
  mutable position: int,
  mutable extent: int,
  mutable content: string,
  mutable line: int,
}
let obj2 = {
  position: 120,
  extent: 0,
  content: " dummyPosition ",
  line: 4,
}
%%raw("console.log(`Ich bin ${obj2.content}.`)")
obj2.content = "Vera"
%%raw("console.log(`Ich bin ${obj2.content}.`)")

type someMutableFields = {
  @set
  "mutable0": string,
  "immutable": int,
  @set
  "mutable1": string,
  @set
  "mutable2": string,
}

type someMethods = {
  @meth
  "send": string => unit,
  @meth
  "on": (string, (. int) => unit) => unit,
  @meth
  "threeargs": (int, string, int) => string,
  "twoArgs": (. int, string) => int,
}

/* let foo = (x: someMethods) => x["threeargs"](3, "a", 4) */

let bar = (x: someMethods) => {
  let f = x["twoArgs"]
  f(. 3, "a")
}

type jsOb2 = {@set "name": string, @meth "jubeln": unit => unit}
// jsOb2##name  #=  "Vera";
// let jsOb2:jsOb2 = jsOb2(~name="Rudolf",~jubeln= () => Js.log("Ich bin ${obj.name}."));
%%raw(
  "const jsOb2 = { name: `Rudolf`, jubeln: () => console.log(`Ich bin ${jsOb2.name}.`)}"
)
