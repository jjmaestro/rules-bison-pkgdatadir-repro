project('rpcalc', 'c')

bison = find_program('bison')

bison_output = custom_target(
  'rpcalc_parser',
  output: ['rpcalc.tab.c', 'rpcalc.tab.h'],
  input: 'rpcalc.y',
  command: [bison, '-d', '-o', 'rpcalc.tab.c', '@INPUT@'],
)

executable('rpcalc', [bison_output[0]], install: true)
