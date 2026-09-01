import pytest
from pytest import FixtureRequest

from pathlib import Path



@pytest.fixture
def lockfile(request: FixtureRequest):
    return request.path.parent / "fixtures" / "conan.lock"
