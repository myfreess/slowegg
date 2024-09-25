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

fn find_root[T : Eq + Hash](self : DisjointSets[T], elem : T) -> T {
  let root = self.roots[elem].unwrap()
  if root == elem {
    return elem
  } else {
    self.roots[elem] = self.find_root(root)
    return self.roots[elem].unwrap()
  }
}

fn rank_of[T : Eq + Hash](self : DisjointSets[T], elem : T) -> Int {
  self.ranks[elem].unwrap()
}

fn union[T : Eq + Hash](self : DisjointSets[T], x : T, y : T) -> Unit {
  let x = self.find_root(x)
  let y = self.find_root(y)
  if x == y {
    return
  }
  if self.rank_of(x) <= self.rank_of(y) {
    self.roots[x] = y
  } else {
    self.roots[y] = x
  }
  if self.rank_of(x) == self.rank_of(y) {
    self.ranks[y] = self.rank_of(y) + 1 // 启发式策略，上界相同的树合并有可能导致最大高度超过原上界
  }
}

fn same_set[T : Eq + Hash](self : DisjointSets[T], x : T, y : T) -> Bool {
  self.find_root(x) == self.find_root(y)
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