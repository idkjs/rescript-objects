/* [@bs.module "axios"] external get : string => Js.Promise.t(string) = "get"; */
/* Axio-Bucklescript-Bindings: https://github.com/meafmira/bs-axios */
/* Conversion: Record <--> Native Js-Object */
/* https://bucklescript.github.io/docs/en/object.html#object-as-record */
@deriving(jsConverter)
type recType = {
  one: string,
  key: string,
}

let handleResponse = (data: recType) => {
  Js.log("handleResponse")
  Js.log(data.one)
  Js.log(data.key)
}

{
  open Js.Promise
  Axios.get("http://echo.jsontest.com/key/value/one/two") |> then_(response =>
    response["data"] |> recTypeFromJs |> handleResponse |> resolve
  )
}

let jsObject = {"one": "einss", "key": "schluesselll"}

/* Convert Js-Object -> Record */
let record: recType = recTypeFromJs(jsObject)

Js.log(record.one)

Js.log(record.key)
