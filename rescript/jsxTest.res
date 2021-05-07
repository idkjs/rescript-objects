/*
 Awesome:
  !!In Reason use JSX in your Reason Code as a substitute
  for function invocation.
 */
/*
  - Use Jsx to invoke the function
  "createElement(~f, ~children=[], ())"
  in the module "JsxRow"
 */
let sum = <JsxRow f={x => x * x}> 1 2 33 44 5 6 </JsxRow>

Js.log(j`sum: $sum`)

/*
 This is equivalent to the function invocation:
 !!createElement!!
 */
let sum2 = JsxRow.createElement(~f=x => x * x, ~children=list{1, 2, 33, 44, 5, 6}, ())

Js.log(j`sum2: $sum2`)
