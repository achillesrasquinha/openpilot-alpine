

# imports - module imports
from openpilot_alpine.exception import (
    Openpilot_alpineError
)

# imports - test imports
import pytest

def test_openpilot_alpine_error():
    with pytest.raises(Openpilot_alpineError):
        raise Openpilot_alpineError