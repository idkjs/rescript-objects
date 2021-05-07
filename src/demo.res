
Js.log(List.length(list{1,2,3}))
%%raw(`
// look ma, regular JavaScript!
var message = "hello";
function greet(m) {
  console.log(m)
}
`)
@val
external greet: (string) => unit = "greet"
let _ = greet("me")

@val
external message: string = "message"
Js.log(message)
let add = %raw(`
  function(a, b) {
    console.log("hello from raw JavaScript!");
    return a + b
  }
`)

Js.log(add(1, 2))
