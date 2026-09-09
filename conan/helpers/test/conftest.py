import pytest
from pytest import FixtureRequest

from pathlib import Path


@pytest.fixture
def fixture_path(request: FixtureRequest):
    return request.path.parent / "fixtures"
