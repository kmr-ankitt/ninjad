module greninja.utils;

string[] asList(T)(T input)
{
  static if (is(T == string))
  {
    return [input];
  }
  else static if (is(T == string[]))
  {
    return input.dup;
  }
  else static if (is(T == typeof(null)))
  {
    return [];
  }
  else static if (is(T == void[]))
  {
    return [];
  }
  else
  {
    static assert(0, "Unsupported type");
  }
}
