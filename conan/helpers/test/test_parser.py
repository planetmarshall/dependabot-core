from lib.parser import parse_lockfile

def test_parse_lockfile(lockfile):
    requirements = parse_lockfile(lockfile)
