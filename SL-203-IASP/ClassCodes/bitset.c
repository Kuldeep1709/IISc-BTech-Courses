#include <stdint.h>

// Example: universe 0..31 stored in one 32-bit word
typedef uint32_t BitSet;

void bs_add(BitSet *S, int x) {
    *S |= (1u << x);
}

void bs_remove(BitSet *S, int x) {
    *S &= ~(1u << x);
}

int bs_contains(BitSet S, int x) {
    return (S >> x) & 1u;
}

BitSet bs_union(BitSet A, BitSet B) {
    return A | B;
}

BitSet bs_inter(BitSet A, BitSet B) {
    return A & B;
}

BitSet bs_diff(BitSet A, BitSet B) {
    return A & ~B;
}
