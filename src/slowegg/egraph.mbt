type Id Int derive(Eq, Hash)

struct Term {
  head : Symbol
  args : FixedArray[Id] // don't modify its content
} derive(Eq)

pub impl Hash for Term with hash_combine(self, hasher) {
  hasher.combine(self.head)
  for i = 0; i < self.args.length(); i = i + 1 {
    hasher.combine(self.args[i])
  }
}

struct EClass {
  nodes : Array[Term]
  parents : Array[(Term, Id)]
}

struct EGraph {
  unionfind : DisjointSets[Int]
  memo : @hashmap.T[Term, Id]
}