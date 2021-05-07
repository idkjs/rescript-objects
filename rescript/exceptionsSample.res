/* Exceptions */
/*
 Links:
 - https://reasonml.github.io/guide/language/exception
 */
/*
 Exception-Declaration:
    - syntax: exception Constructor(type1, type2, ...)
    - Must be capitalized as Constructors used in Variants
 */
exception DummerFehler(int, string)

exception NochDuemmererFehler(string)

exception AbsolutDummerFehler(float)

/*
  Raise Exceptions:
     - raise-syntax: raise(MeineException(...));
 */
let f: string => string = fehlerCode =>
  switch fehlerCode {
  | "a" => raise(DummerFehler(500, "DummerFehler"))
  | "b" => raise(NochDuemmererFehler("NochDuemmererFehler"))
  | "c" => raise(AbsolutDummerFehler(-10.0))
  | _ =>
    Js.log(j`f($fehlerCode) = ok`)
    "ok"
  }

/* Catching Exception:
   - Due to the absence of statements in Reason
   you usually catch exceptions in reason by
   pattern matching an expression which might raise
   an exception.
   - The exception handling is usually done by
   returning a default value for the expression.
   - There are 2 ways to apply pattern matching for exception
   handling:
   (1) try(expression) { | MyException(...) => defaultValue }
   Use-case for try: Just good for exception handling by
   mapping exceptions to default values.
   (2) switch(expression) { | exception MyException(...) => defaultValue }
   Use-case for switch: General purpose utility for mapping
   expressions to another expression and mapping exceptions
   to default values.
 */
/*
 (1) try(expression) { | MyException(...) => }
 - !!! Return expression without any mapping, if no exception
 - Map exceptions to defaultValues, if exception
 */
let tryFehlerCode = fehlerCode =>
  /* !! Evalutes to the expression, if no exception happens */
  try f(fehlerCode) catch {
  /* Map exceptions to default values */
  | DummerFehler(_, message)
  | NochDuemmererFehler(message) =>
    Js.log(j`Mapped DummerFehler oder NochDuemmererFehler to: defaultValue`)
    "defaultValue"
  | AbsolutDummerFehler(value) =>
    Js.log(j`Mapped AbsolutDummerFehler to: defaultValue`)
    "defaultValue"
  }

/* (2) switch(expression){ | exception MyException(...) => ... }:
   - !!! map expression to another expression, if no exception
   - map exception to another expression, if exception
 */
let check_f = fehlerCode =>
  switch f(fehlerCode) {
  /* Map Exceptions to defaultValues */
  | exception (DummerFehler(_, message) | NochDuemmererFehler(message)) =>
    Js.log(j`DummerFehler oder NochDuemmererFehler: $message`)
    "defaultValue"
  | exception AbsolutDummerFehler(value) =>
    Js.log(j`AbsolutDummerFehler: $value`)
    "defaultValue"
  /* No exception: Map expression to another expression */
  | result =>
    Js.log(j`success: $result`)
    result
  }

/* Test Exception handling */
let cases = list{"a", "b", "c", "d"}

cases |> List.map(tryFehlerCode)

cases |> List.map(check_f)
/*
 Summary:
 - Use try(expression) { MyException(...) => ... },
   if you want to just handle the exception but not want to
   map the non-exception-expression to another value
 - Use switch(expression) { exception MyException(...) => ... },
   if you want to map the non-exception-expression to another
   value anyway
 */
