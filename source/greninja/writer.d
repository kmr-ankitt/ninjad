module greninja.writer;

import std.stdio;
import std.string : join;
import std.format : format;
import std.array : array;
import std.algorithm : map;
import greninja.utils;

class Writer
{
  File output;
  uint width;

  /**
   * @params:
   * 1. string: name of the file
   * 2. uint: width of the output, default is 78 
  **/
  this(string filename, uint width = 78)
  {
    this.output = File(filename, "w");
    this.width = width;
  }

  /** 
    * @params:
    * 1. string: text to write
    * 2. uint: (optional) indent level default is 0
  **/
  void line(string text, uint indent = 0)
  {
    string leading_space = "";
    foreach (_; 0 .. indent)
    {
      leading_space ~= "  ";
    }

    this.output.writef("%s%s\n", leading_space, text);
  }

  /** 
   * @params:
   * 1. string: name of the variable
   * 2. string: value of variable
   * 3. uint: (optional) indent level default is 0
   **/
  void variable(string key, string value, uint indent = 0)
  {
    if (value.length == 0)
      return;
    this.line(key ~ " = " ~ value, indent);
  }

  /** 
   * @params:
   * 1. string: name of the rule
   * 2. string: command to execute
  **/
  void rule(string name, string command)
  {
    this.line("rule " ~ name);
    this.line("command = " ~ command, 1);
    this.newline();
  }

  /**
    @params:
    1. string[]: output files
    2. string: rule to use
    3. string[]: input files
    4. (optional) string[]: implicit dependencies, default is empty
    5. (optional) string[]: order-only dependencies, default is empty
    4. (optional) string[][]: variables to set for this build, default is empty
  **/
  void build(T1, T2, T3)(T1 output, string rule, T2 input, T3 implicit = null,
    T3 order_only = null, string[][] variables = [])
  {

    auto outputs = asList(output);
    auto inputs = asList(input);
    auto implicits = asList(implicit);
    auto orders = asList(order_only);

    auto out_outputs = outputs.map!(a => escapePath(a)).array;
    auto all_inputs = inputs.map!(a => escapePath(a)).array;
    auto implicit_inputs = implicits.map!(a => escapePath(a)).array;
    auto order_only_inputs = orders.map!(a => escapePath(a)).array;

    string line = "build " ~ out_outputs.join(" ") ~ ": " ~ rule;

    if (all_inputs.length > 0)
      line ~= " " ~ all_inputs.join(" ");
    if (implicit_inputs.length > 0)
      line ~= " | " ~ implicit_inputs.join(" ");
    if (order_only_inputs.length > 0)
      line ~= " || " ~ order_only_inputs.join(" ");

    this.line = line;

    foreach (value; variables)
    {
      if (value.length == 0)
        continue;

      string key = value[0];
      string val = value.length > 1 ? value[1 .. $].join(" ") : "";

      this.variable(key, val, 1);
    }

    this.newline();
  }

  /**
  * @params:
  * 1. string[]: paths to include in the default target
  **/
  void _default(string[] paths)
  {
    this.line("default " ~ paths.join(" "));
  }

  void newline()
  {
    this.output.write("\n");
  }

  /** 
    * @params:
    * 1. string: path to the file to include
  **/
  void include(string path)
  {
    this.line("include " ~ escapePath(path));
  }

  /** 
    * @params:
    * 1. string: path to the file to include
  **/
  void subninja(string path)
  {
    this.line("subninja " ~ escapePath(path));
  }

  /** 
    * @params:
    * 1. string: text to write as a comment
  **/
  void comment(string text)
  {
    this.line("# " ~ text);
  }

  void close()
  {
    this.output.close();
  }
}
