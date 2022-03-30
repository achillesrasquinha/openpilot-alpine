
from __future__ import absolute_import


try:
    import os

    if os.environ.get("OPENPILOT_ALPINE_GEVENT_PATCH"):
        from gevent import monkey
        monkey.patch_all(threaded = False, select = False)
except ImportError:
    pass

# imports - module imports
from openpilot_alpine.__attr__ import (
    __name__,
    __version__,
    __build__,

    __description__,

    __author__
)
from openpilot_alpine.config      import PATH
from openpilot_alpine.__main__    import main

from bpyutils.cache       import Cache
from bpyutils.config      import Settings
from bpyutils.util.jobs   import run_all as run_all_jobs, run_job


cache = Cache(dirname = __name__)
cache.create()

settings = Settings()


def get_version_str():
    version = "%s%s" % (__version__, " (%s)" % __build__ if __build__ else "")
    return version
