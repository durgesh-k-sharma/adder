#!/bin/sh
# Builds every test/*.snek and compares the binary's output with test/*.expected
fail=0
for f in test/*.snek; do
  n=$(basename "$f" .snek)
  make -s test/$n.run >/dev/null 2>&1
  got=$(./test/$n.run)
  want=$(cat test/$n.expected)
  if [ "$got" = "$want" ]; then echo "PASS $n: $got"; else echo "FAIL $n: got $got, want $want"; fail=1; fi
done
exit $fail
