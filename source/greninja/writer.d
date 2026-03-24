module greninja.writer;

import std.stdio;
import std.string : join;
import std.format : format;

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
  void build(string[] output, string rule, string[] input, string[] implicit = [],
    string[] order_only = [], string[][] variables = [])
  {
    string line = "build " ~ output.join(" ") ~ ": " ~ rule;

    if (input.length > 0)
      line ~= " " ~ input.join(" ");
    if (implicit.length > 0)
      line ~= " | " ~ implicit.join(" ");
    if (order_only.length > 0)
      line ~= " || " ~ order_only.join(" ");

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

  void close()
  {
    this.output.close();
  }
}
