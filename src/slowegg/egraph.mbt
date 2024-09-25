type Id Int derive(Eq, Hash)

struct Term {
  head : Symbol
  args : Array[Id]
} derive(Eq)

// TODO: Implement hash() for Term

struct EClass {
  nodes : Array[Term]
  parents : Array[(Term, Id)]
}

struct EGraph {
  unionfind : DisjointSets[Int]
  memo : @hashmap.T[Term, Id]
}