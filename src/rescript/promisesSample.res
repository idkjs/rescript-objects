/* Promises in ReasonML are represented
   by Bucklescripts Js.Promise-object
   https://gist.github.com/Lokeh/a8d1dc6aa2043efa62b23e559291053e */
/* (1) Promise-creation: */
let timer = Js.Promise.make((~resolve, ~reject as _) => {
  ignore(Js.Global.setTimeout(() => resolve(. "Done!"), 1000))
  ()
})

/* (2) Promise-chaining via Js.Promise.then_-function:
   !!! important !!! then_ expects a function of signature: 'a => Js.Promise.t('a)
   That means it is not allowed to return a plain value of type 'a */
/* Chaining */
Js.Promise.then_(
  value => Js.Promise.resolve(Js.log(value)),
  Js.Promise.then_(value => Js.Promise.resolve(value + 1), Js.Promise.resolve(1)),
)|>ignore

/* Better with pipes */
Js.Promise.resolve(1)
|> Js.Promise.then_(value => Js.Promise.resolve(value + 1))
|> Js.Promise.then_(value => Js.Promise.resolve(Js.log(value)))|>ignore

/* And even better with some Reason spice */
{
  open Js.Promise
  resolve(1) |> then_(value => resolve(value + 1)) |> then_(value => resolve(Js.log(value)))
}->ignore
