/* Special variables in NodeJs */
let dirname: option<string> = %bs.node(__dirname)

let filename: option<string> = %bs.node(__filename)

let _module: option<Node.node_module> = %bs.node(_module)

let require: option<Node.node_require> = %bs.node(require)
