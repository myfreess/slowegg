
// ########################################################################################
// ------------------------------- IntDisjointSet BEGIN -----------------------------------
// ########################################################################################


struct IntDisjointSet {
  roots : FixedArray[Int]
  ranks : FixedArray[Int] // 子树高度的上界
}

fn IntDisjointSet::new(upper :Int) -> IntDisjointSet {
  let rs = FixedArray::makei(upper, fn (i) { i })
  let ks = FixedArray::make(upper, 1)
  IntDisjointSet::{ roots : rs, ranks : ks }
}

fn rootOf(self : IntDisjointSet, x : Int) -> Int {
  if (self.roots[x] == x) {
    return x;
  } else {
    self.roots[x] = self.rootOf(self.roots[x])
    return self.roots[x];
  }
}

fn rankOf(self : IntDisjointSet, x : Int) -> Int {
  self.ranks[x]
}

fn merge(self : IntDisjointSet, i : Int, j : Int) -> Unit {
  let x = self.rootOf(i)
  let y = self.rootOf(j)
  if (x == y) {
    return;
  }

  if (self.rankOf(x) <= self.rankOf(y)) {
    self.roots[x] = y
  } else {
    self.roots[y] = x
  }

  if (self.rankOf(x) == self.rankOf(y)) {
    self.ranks[y] = self.ranks[y] + 1 // 启发式策略，上界相同的树合并有可能导致最大高度超过原上界
  }
}

fn op_get(self : IntDisjointSet, i: Int) -> Int {
  self.rootOf(i)
}


// ########################################################################################
// -------------------------------- IntDisjointSet END ------------------------------------
// ########################################################################################


type Id Int derive(Eq, Hash)

type Symbol

struct Term {
  head : Symbol
  args : Array[Id]
}

struct EClass {
  nodes : Array[Term]
  parents : Array[(Term, Id)]
}
