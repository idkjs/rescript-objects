/*
 Awesome:
  !!In Reason you can use JSX in your Reason Code for
  function invocation.
 */
/*
 A Jsx-Component which calculates:
  Sum of f(x), where x is passed in as children and f as props
 */
let createElement = (~f: int => int, ~children=list{}, ()) => {
  Js.log(children)
  let initialState = 0
  let reducer = (state, item) => state + f(item)
  List.fold_left(reducer, initialState, children)
}

/* React-Reason:
   https://reasonml.github.io/reason-react/docs/en/creation-props-self.html
   works a bit differently.
   - Instead of "createElement" a "make"-function is invoked
   when using JSX.
   - the make function should return a React-Component
   (a special record-type)
   - For enabling React-Reason put this in the bsconfig.json:
     "reason": {"react-jsx": 2}
 */
let make = (~f: int => int, children) => {
  Js.log(children)
  let initialState = 0
  let reducer = (state, item) => state + f(item)
  Array.fold_left(reducer, initialState, children)
}
