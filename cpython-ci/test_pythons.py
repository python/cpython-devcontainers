#!/usr/bin/env python3

import sys
import pprint
import subprocess


testables = {}

with open('/usr/local/bin/versions.txt', encoding='utf-8') as fp:
    # Each line will contain either one entry, in which case that's the exact
    # version and series to use, or two lines where the first word is the
    # exact version and the second word is the series.  This latter is mostly
    # to handle pre-release versions.  E.g.
    #
    # 3.X.Y
    # 3.X.YbZ 3.X.Y
    #
    # What we want is the major.minor version so we can invoke the
    # interpreter, and the value that will be returned by `pythonX.Y -V`.
    # We'll use those to compare in the test.
    for line in fp.read().splitlines():
        words = line.split()
        if len(words) == 1:
            version = series = words[0]
        else:
            assert len(words) == 2
            version, series = words
        major, minor = series.split('.')[:2]
        testables[f'python{major}.{minor}'] = f'Python {version}'


FAIL = []
PASS = []
OUTPUTS = {}
VERSIONS = {}


for exe, output in testables.items():
    proc = subprocess.run([exe, '-V'], capture_output=True, text=True)
    version = proc.stdout.strip()
    if proc.returncode != 0:
        FAIL.append(exe)
        OUTPUTS[exe] = version
    elif version != output:
        FAIL.append(exe)
        OUTPUTS[exe] = version
    else:
        PASS.append(exe)
        VERSIONS[exe] = version


print(f'PASS: {PASS}')
print(f'FAIL: {FAIL}')

print('Python versions built:')
for b_exe, b_version in VERSIONS.items():
    print(f'    {b_exe:10} == {b_version}')

if len(FAIL) > 0:
    pprint.pprint(testables)
    pprint.pprint(OUTPUTS)

sys.exit(len(FAIL))
