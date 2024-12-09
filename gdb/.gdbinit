set confirm off
set pagination off

skip -gfi /usr/include/c++/*/*/*
skip -gfi /usr/include/c++/*/*
skip -gfi /usr/include/c++/*

python
import glob
import sys

for p in glob.glob("/usr/share/gcc*/python"):
    sys.path.insert(0, p)

from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers(None)
end
