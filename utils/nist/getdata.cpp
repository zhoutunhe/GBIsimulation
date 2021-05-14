#include <cstdio>
using namespace std;


int main() {
  for (int Z = 1; Z < 92; ++Z)
    printf("wget http://physics.nist.gov/PhysRefData/XrayMassCoef/ElemTab/z%02d.html\n",Z);
  return 0;
}
