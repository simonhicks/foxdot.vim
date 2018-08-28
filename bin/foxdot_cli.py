import os
import cmd

from FoxDot import *

class FoxDotConsole(cmd.Cmd):
    prompt = "FoxDot> "
    intro = "LiveCoding with Python and SuperCollider"

    def default(self, line):
        execute(line)

if __name__ == "__main__":
    FoxDotConsole().cmdloop()
