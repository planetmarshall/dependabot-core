import sys
import json

import lib

if __name__ == "__main__":
    args = json.loads(sys.stdin.read())

    function = getattr(lib, args["function"])
    function(*args["args"])
