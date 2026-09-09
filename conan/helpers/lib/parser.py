from collections import OrderedDict

from conan.api.conan_api import ConanAPI

from pathlib import Path


def _dependencies(conan_graph):
    nodes = conan_graph["graph"]["nodes"]
    root = nodes["0"]
    for key, node in root["dependencies"].items():
        ref = nodes[key]
        groups = [ref["context"]]
        if node["direct"]:
            groups.append("direct")
        yield {
            "name": ref["name"],
            "version": ref["version"],
            "requirements": {
                "requirement": ref["version"],
                "groups": groups,
                "source": {
                    "url" : ref["homepage"],
                }
            }
        }


def conan_to_dependabot(conan_graph):
    return list(_dependencies(conan_graph))


def parse_manifest(conanfile: Path):
    api = ConanAPI()

    host_profile = api.profiles.get_profile([api.profiles.get_default_host()])
    build_profile = api.profiles.get_profile([api.profiles.get_default_build()])
    conancenter = api.remotes.get("conancenter")

    args = OrderedDict({
        "path": conanfile.as_posix(),
        "name": None,
        "version": None,
        "user": None,
        "channel": None,
        "profile_host": host_profile,
        "profile_build": build_profile,
        "lockfile": None,
        "remotes": [conancenter],
        "update": None,
    })
    graph = api.graph.load_graph_consumer(*args.values())
    return graph.serialize()
