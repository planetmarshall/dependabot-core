from conan.api.conan_api import ConanAPI

from pathlib import Path

def parse_lockfile(lockfile: Path):

    api = ConanAPI()
    lock = api.lockfile.get_lockfile(lockfile)
    for dep in lock:
        print(dep)



