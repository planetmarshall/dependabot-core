import json
from collections import OrderedDict

from lib.parser import conan_to_dependabot


def _load_graph(fixture):
    with open(fixture / "graph.json", "r") as f:
        return json.load(f, object_pairs_hook=OrderedDict)


def test_parse_basic_conanfile(fixture_path):
    graph = _load_graph(fixture_path / "basic_conanfile_txt")
    deps = conan_to_dependabot(graph)
    dependency = deps[0]
    assert dependency == {
        "name": "zlib",
        "version": "1.3.1",
        "requirements": {
            "requirement": "1.3.1",
            "groups": ["host", "direct"],
            "source": {
                "url": "https://zlib.net",
            }
        }
    }

