let add = [%raw
  {js|
  function(a, b) {
    console.log("hello from raw JavaScript!");
    return a + b
  }
|js}
];

Js.log(add(1, 2));
