type Symbol Int

struct SymbolCtx {
  locations : @hashmap.T[String, Symbol]
  pool : Array[String]
}

fn SymbolCtx::new() -> SymbolCtx {
  SymbolCtx::{
    locations: @hashmap.new(capacity=100),
    pool: Array::new(capacity=50),
  }
}

fn intern(self : SymbolCtx, s : String) -> Symbol {
  match self.locations[s] {
    None => {
      let current = Symbol(self.pool.length())
      self.pool.push(s)
      self.locations[s] = current
      return current
    }
    Some(s) => s
  }
}

fn op_get(self : SymbolCtx, key : Symbol) -> String {
  self.pool[key._]
}

test "ctx[ctx.intern(x)] == x" {
  let ctx = SymbolCtx::new()
  let identity = fn(x) -> Unit!Error { assert_eq!(ctx[ctx.intern(x)], x) }
  identity!("foo")
  identity!("bar")
  identity!("baz")
  identity!("114514")
  identity!("y32tr32894try4$%*&*&(*$)")
}
