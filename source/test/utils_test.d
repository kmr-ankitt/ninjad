module test.utils_test;

import greninja.utils;
import std.stdio;

unittest{
  auto result = asList("hello");
  assert(result.length == 1);
}

unittest{
  auto result = asList(["hello", "world"]);
  assert(result.length == 2);
  assert(result[0] == "hello");
  assert(result[1] == "world");
}

unittest{
  auto result = asList([]);
  assert(result.length == 0);
}

unittest{
  auto result = asList(null);
  assert(result.length == 0);
}
