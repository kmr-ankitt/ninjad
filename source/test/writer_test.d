module test.writer_test;

import greninja.writer;

unittest{
    auto w = new Writer("writer_build.ninja");
    assert(w.output.name.length > 0);
}

unittest{
  import std.file;
  auto w = new Writer("line_build.ninja");
  w.line("rule cc");
  w.line("command = gcc -c $in -o $out", 1);
}
