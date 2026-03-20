module ninjad.writer;

import std.stdio;

class Writer{
  File output;
  uint width;

  /**
   @params:
   1. name of the file
   2. width of the output, default is 78 
  **/
  this(string filename, uint width = 78){
    this.output = File(filename, "w");
    this.width = width; 
  }
}
