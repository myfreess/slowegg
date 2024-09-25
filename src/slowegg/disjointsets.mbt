struct DisjointSets[T] {
  roots : @hashmap.T[T, T]
  ranks : @hashmap.T[T, Int] // 子树高度的上界
}

fn DisjointSets::new[T : Eq + Hash](elems : Array[T]) -> DisjointSets[T] {
  let rs = @hashmap.new(capacity = elems.length() * 2)
  let ks = @hashmap.new(capacity = elems.length() * 2)
  for elem in elems {
    rs[elem] = elem
    ks[elem] = 1
  }
  DisjointSets::{ roots: rs, ranks: ks }
}

fn rootOf[T : Eq + Hash](self : DisjointSets[T], elem : T) -> T {
  let root = self.roots[elem].unwrap()
  if root == elem {
    return elem
  } else {
    self.roots[elem] = self.rootOf(root)
    return self.roots[elem].unwrap()
  }
}

fn rankOf[T : Eq + Hash](self : DisjointSets[T], elem : T) -> Int {
  self.ranks[elem].unwrap()
}

fn union[T : Eq + Hash](self : DisjointSets[T], x : T, y : T) -> Unit {
  let x = self.rootOf(x)
  let y = self.rootOf(y)
  if x == y {
    return
  }
  if self.rankOf(x) <= self.rankOf(y) {
    self.roots[x] = y
  } else {
    self.roots[y] = x
  }
  if self.rankOf(x) == self.rankOf(y) {
    self.ranks[y] = self.rankOf(y) + 1 // 启发式策略，上界相同的树合并有可能导致最大高度超过原上界
  }
}

fn same_set[T : Eq + Hash](self : DisjointSets[T], x : T, y : T) -> Bool {
  self.rootOf(x) == self.rootOf(y)
}

test "union find" {
  let a = "aaa"
  let b = "bbb"
  let c = "ccc"
  let d = "ddd"
  let s = DisjointSets::new([a, b, c, d])
  s.union(a, c)
  s.union(b, d)
  s.union(c, d)
  assert_true!(s.same_set(a, d))
}