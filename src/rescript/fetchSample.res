/* ************* DIFFERENT SOLUTIONS FOR FETCH ************* */
/* Api: http://echo.jsontest.com/key/value/one/two */
%%raw(`require('isomorphic-fetch')`)

/* Response Type: */
type res = {
  one: string,
  key: string,
}

/* ResponseHandler: */
/* Convert: json -> record */
/* https://github.com/reasonml-community/bs-json */
/* https://stackoverflow.com/questions/43701784/how-can-i-parse-this-json-to-a-record-type */
let handleResponse = (json: Js.Json.t) => {
  let r = {
    open Json.Decode
    {
      one: json |> field("one", string),
      key: json |> field("key", string),
    }
  }
  let key = r.one
  Js.log(j`
    response ist: $key
  `)
  ()
}

/* (1) ************* FETCH VIA BS-FETCH-BINDING ************* */
/* Fetch Data from REST-API: */
/* https://github.com/reasonml-community/bs-fetch */
{
  open Js.Promise
  Fetch.fetch("http://echo.jsontest.com/key/value/one/two")
  /* Convert response -> text -> json */
  /* Js.Json.parseExn */
  /* |> then_(Fetch.Response.text) */
  /* |> then_(text => text |> Js.Json.parseExn |> handleResponse |> resolve) */
  /* Convert response -> json */
  |> then_(Fetch.Response.json)
  |> then_(text => text |> handleResponse |> resolve)
}|>ignore

/* (2) ************* Fetch via Self-defined Bucklescript-IMPORT ************* */
/* [@bs.meth] */
type jsObjectType2<'a> = {@meth "json": unit => Js.Promise.t<'a>}

type responseType2 = {"one": string, "key": string}

%%raw("require('isomorphic-fetch')")

@val("fetch")
external fetch: string => Js.Promise.t<jsObjectType2<responseType2>> = ""

let dataHandler = data => {
  Js.log("self defined type -> data.one : " ++ data["one"])
  Js.log("self defined type -> data.key : " ++ data["key"])
}

// {
//   open Js.Promise
//   fetch("http://echo.jsontest.com/key/value/one/two")
//   |> then_(response => response["json"]())
//   |> then_(data => data |> dataHandler |> resolve)
// }

/* (3) ************* FETCH VIA RAW-JS ************* */
/* Js-fetch via Js-Interop */
/* Api: http://echo.jsontest.com/key/value/one/two */
/* Define Interface to Js-function */
/* https://reasonml.github.io/guide/javascript/interop/ */
/* https://jaredforsyth.com/2017/06/03/javascript-interop-with-reason-and-bucklescript/ */
/* Bucklescript-Object vs ReasonML-Object: */
/* https://reasonml.github.io/guide/language/object/ */
/* Conversion: JS-Object <--> Record */
@deriving(jsConverter)
type responseType = {
  one: string,
  key: string,
}

%%raw(`
    require('isomorphic-fetch');
`)

let fetchApiResponseInline: unit => Js.Promise.t<Js.Json.t> = %raw(`
    ()=>fetch("http://echo.jsontest.com/key/value/one/two").then(r => r.json())
`)

let handleData = (data: responseType) => {
  Js.log("handleData")
  Js.log(data.one)
  Js.log(data.key)
}

/* Need to manually convert Json-data to Record-data */
/* Unfortunately there is a difference between a Bucklescript-object and Js.json.t */
let parseJsonData = (data: Js.Json.t): responseType => {
  open Json.Decode
  {
    one: field("one", string, data),
    key: field("key", string, data),
  }
}

/* How Promises work in reason: */
/* https://jamesfriend.com.au/a-first-reason-react-app-for-js-developers */
/* https://gist.github.com/Lokeh/a8d1dc6aa2043efa62b23e559291053e */
/* promise
   |> Js.Promise._then(value1 => promise1)
   |> Js.Promise._then(value2 => promise2)
   |> Js.Promise._then(value3 => Js.Promise.resolve(doSthgWith(value3))) */
fetchApiResponseInline() |> Js.Promise.then_(data =>
/* Need to return a Promise to fullfil expected function signature in then_(...) */
  Js.Promise.resolve(handleData(parseJsonData(data)))
)|>ignore
