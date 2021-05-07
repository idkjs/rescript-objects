/* Links: https://reasonml.github.io/guide/language/object */
/*
  *
   Plain Js-Objects in Reason:
   - type: Js.t('a) where 'a is the Reason-type
   - fields & methods accessible via ##
   - fields mutable via #= -operator
   - represent/compiled to plain JS-objects
   - any methods and fields of Js.t('a)-objects are accessible via ##-operator
 */
%%raw(` const jsObject = {
      myName: "blabla",
      myMethod: (greeting) => console.log(\`\${greeting}, Mr.\${jsObject.myName}\`)
    };`)

@val external jsObject: 'a = "jsObject"

/* The type Js.t('a) doesnt provide any field or method information: */
/* Any field is accessible: */
Js.log(jsObject["myName"])

jsObject["myName"] = "HERBERT"

/* Any method is accessible: */
jsObject["myMethod"]("Hello")

/*
  *
 Explicit type declaration for plain JS-Objects:
 If you declare a type in Reason for a Js-Object, beware:
 - Methods must be explicitly declared as methods via [@bs.meth]
 - Mutable Fields must be explicitly declared as settable via [@bs.set]
 */
type guest = {
  @set
  "myName": /* Declare field of Js-Object as mutable */
  string,
  @meth
  "myMethod": /* Declare as method of Js-Object */
  string => unit,
}

@val external jsObjectTyped: guest = "jsObject"

jsObjectTyped["myName"] = "Vanessa"

Js.log(jsObjectTyped["myName"])

jsObjectTyped["myMethod"]("huhu")
