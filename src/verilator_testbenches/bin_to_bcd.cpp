#include "Vbin_to_bcd.h"
#include "VerilatorTBench.h"

int main(int nargs, char **args) {
  Verilated::commandArgs(nargs, args);
  auto tb = new VerilatorTBench<Vbin_to_bcd>("bin_to_bcd.vcd");

  int binary_in = 0;

  for (int i = 0; i < 64; ++i) {
    tb->core->i_bin = i;
    int msb = tb->core->o_bcd_msb;
    int lsb = tb->core->o_bcd_lsb;

    tb->tick();
    assert(lsb == i % 10);
    assert(msb == i / 10);
    printf("0x%04x -> %d%d\n", i, msb, lsb);
  }

  delete tb;
  return 0;
}
