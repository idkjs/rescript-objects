/* Mutation */
/*
 Boxing an immutable values for mutability:
 - ref(value)
 - Syntactic sugar for: {contents: wert}
   of type ref('a) = {mutable contents: 'a}
 */
let box: ref<int> = ref(99)

let box2: ref<int> = {contents: 99}

/*
 Zuweisung eines refs:
  - box := wert;
  - Syntactic sugar for: box.contents = wert
 */
box := 100

box2.contents = 100

/*
 Unboxing a ref:
 - box^
 - Syntactic sugar for: box.contents
 */
print_int(box.contents)

print_int(box.contents)
