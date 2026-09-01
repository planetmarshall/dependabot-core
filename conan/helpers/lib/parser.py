from conan.api.conan_api import ConanAPI

from pathlib import Path


def dependencies(conanfile: Path):
    api = ConanAPI()

    host_profile = api.profiles.get_profile([api.profiles.get_default_host()])
    build_profile = api.profiles.get_profile([api.profiles.get_default_build()])
    conancenter = api.remotes.get("conancenter")

    args = OrderedDict({
        "path": conanfile_path.as_posix(),
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
    deps = [ { "name": node.name, "version": str(node.ref.version) } for node in graph.nodes[1:] ]
