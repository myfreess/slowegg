type Id Int derive(Eq, Hash)

struct Term {
  head : Symbol
  args : FixedArray[Id]
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
  mut next_id : Int
  unionfind : DisjointSets[Id]
  memo : @hashmap.T[Term, Id]
  classes : @hashmap.T[Id, EClass]
  dirty_unions : Array[Id]
}

fn EGraph::new() -> EGraph {
  EGraph::{
    next_id : 0,
    unionfind : DisjointSets::new([]),
    memo : @hashmap.new(),
    classes : @hashmap.new(),
    dirty_unions : []
  }
}

fn next_id(self : EGraph) -> Id {
  let id = self.next_id
  self.next_id += 1
  return id
}

fn find_root(self : EGraph, id : Id) -> Id {
  self.unionfind.find_root(id)
}

fn same_class(self : EGraph, t1 : Term, t2 : Term) -> Bool {
  self.unionfind.same_set(self.memo[t1].unwrap(), self.memo[t2].unwrap())
}

fn canonicalize(self : EGraph, t : Term) -> Unit {
  for i = 0; i < t.args.length(); i = i + 1 {
    t.args[i] = self.find_root(t.args[i])
  }
}

fn find_class(self : EGraph, t : Term) -> Id? {
  self.canonicalize(t)
  if self.memo.contains(t) {
    let id = self.memo[t].unwrap()
    return Some(self.find_root(id))
  } else {
    return None
  }
}

fn push(self : EGraph, t : Term) -> Id {
  let id = self.find_class(t)
  match id {
    None => {
      let id = self.next_id()
      self.unionfind.union(id, id)
      let cls = EClass::{ nodes : [t], parents : [] }
      for child in t.args {
        self.classes[child].unwrap().parents.push((t, id))
      } else {
        self.classes[id] = cls
        self.memo[t] = id
        return id
      }
    }
    Some(id) => id
  }
}

