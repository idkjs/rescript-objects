/* https://reasonml.github.io/guide/language/object */
/* Classical Record Type: */
type recType = {
  name: string,
  age: int,
}

/* "Closed" Object Type (Optional) */
type closedObjectType = {"name": string, "age": int}

/* "Open" Object Type */
type openObjectType<'a> = {.."name": string, "age": int} as 'a

/* Record Creation: */
let rec1: recType = {name: "Mr.X", age: 22}

Js.log(rec1.name)

/* Closed Object Creation with pub-, pri-members */
// let obj1: closedObjectType = Pexp_object not impemented in printer

// Js.log(Pexp_send not impemented in printer)

/* Open Object Creation with pub-, pri-members */
/* let obj1: closedObjectType = {pub name = "Mr.y"; pub age = 22}; */
/* Js.log(obj1#name); */
/* TODO */
/* VANILLA JS OBJECT: */
/* Bucklescript's Vanilla JS-Object: Special Objects */
/* 1. access fields through ## */
/* 2. always come with with Js.t (as a type parameter to the Js.t type). */
/* 3. compile to actual JS objects. */
/* https://bucklescript.github.io/docs/en/object.html#object-as-record */
/* !!Optional!! VanillaJS-Type Declaration: */
type vanillaJsType = {"name": string, "age": int}

/* Create VanillaJsObj */
let vanillaJsObj1: vanillaJsType = {"name": "Mr.Record", "age": 22}

Js.log(vanillaJsObj1["name"])

/* Convert: VanillaJS-Object -> Record */
@deriving(jsConverter)
type recTestType = {
  name: string,
  age: int,
}

/* Convert: VanillaJS-Object -> Record */
let testRec1: recTestType = recTestTypeFromJs(vanillaJsObj1)

Js.log(testRec1.name)

/* Convert:  Record -> VanillaJS-Object */
let testRec2: recTestType = {name: "Mrs.Record", age: 99}

let testJs2: vanillaJsType = recTestTypeToJs(testRec2)

Js.log(testJs2["name"])
