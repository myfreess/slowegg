type Id Int derive(Eq, Hash)

struct Term {
  head : Symbol
  args : Array[Id]
}

struct EClass {
  nodes : Array[Term]
  parents : Array[(Term, Id)]
}
