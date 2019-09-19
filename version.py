from subprocess import check_output
from dateutil import parser

__major_version__ = '0.3.0'
__debug_build__ = True
__timestamp__ = check_output('git log --no-walk --date=iso --format=%cd || true', shell=True).decode("utf-8").rstrip()
__commit__ = check_output('git rev-parse --short HEAD || true', shell=True).decode("utf-8").rstrip()
__extra_build__ = ''
if __debug_build__ and __timestamp__:
    __timestamp__ = parser.parse(__timestamp__).strftime("%Y%m%d%H%M%S")
    __extra_build__ = '-{}{}'.format(__timestamp__, __commit__)

VERSION = '{}{}'.format(__major_version__, __extra_build__)
