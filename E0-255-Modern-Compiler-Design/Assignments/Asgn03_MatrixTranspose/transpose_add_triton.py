import sys
import io
import argparse
import numpy as np
import torch
import triton
import triton.language as tl

@triton.autotune(
    configs=[
        triton.Config({"BLOCK_M": 32,  "BLOCK_N": 32},  num_warps=4),
        triton.Config({"BLOCK_M": 64,  "BLOCK_N": 64},  num_warps=8),
        triton.Config({"BLOCK_M": 128, "BLOCK_N": 64},  num_warps=8),
        triton.Config({"BLOCK_M": 64,  "BLOCK_N": 128}, num_warps=8),
        triton.Config({"BLOCK_M": 128, "BLOCK_N": 128}, num_warps=16),
        triton.Config({"BLOCK_M": 32,  "BLOCK_N": 128}, num_warps=8),
        triton.Config({"BLOCK_M": 128, "BLOCK_N": 32},  num_warps=8),
    ],
    key=["N"],
)
@triton.jit
def transpose_add_kernel(
    T_ptr,
    Out_ptr,
    N: tl.constexpr,
    BLOCK_M: tl.constexpr,
    BLOCK_N: tl.constexpr,
):
    pid_m = tl.program_id(0)
    pid_n = tl.program_id(1)

    rm = pid_m * BLOCK_M + tl.arange(0, BLOCK_M)   # [BLOCK_M]
    rn = pid_n * BLOCK_N + tl.arange(0, BLOCK_N)   # [BLOCK_N]

    mask = (rm[:, None] < N) & (rn[None, :] < N)

    # Load T[rm, rn], coalesced (consecutive rn per warp)
    T_ptrs = T_ptr + rm[:, None] * N + rn[None, :]
    t_val  = tl.load(T_ptrs, mask=mask, other=0.0)  # [BLOCK_M, BLOCK_N]

    # Load T[rn, rm] as [BLOCK_N, BLOCK_M] (coalesced along rm) and then transpose in registers to get [BLOCK_M, BLOCK_N]
    Tt_ptrs       = T_ptr + rn[:, None] * N + rm[None, :]
    Tt_mask       = (rn[:, None] < N) & (rm[None, :] < N)
    t_trans_block = tl.load(Tt_ptrs, mask=Tt_mask, other=0.0)  # [BLOCK_N, BLOCK_M]
    t_trans       = tl.trans(t_trans_block)                     # [BLOCK_M, BLOCK_N]

    # Fused add + store
    out      = t_val + t_trans
    Out_ptrs = Out_ptr + rm[:, None] * N + rn[None, :]
    tl.store(Out_ptrs, out, mask=mask)


# Python wrapper
def triton_transpose_add(T: torch.Tensor) -> torch.Tensor:
    assert T.is_cuda and T.is_contiguous()
    N = T.shape[0]
    assert T.shape == (N, N)
    Out = torch.empty_like(T)

    def grid(meta):
        return (triton.cdiv(N, meta["BLOCK_M"]),
                triton.cdiv(N, meta["BLOCK_N"]))

    transpose_add_kernel[grid](T, Out, N)
    return Out


# Input
def load_input_npz(N: int) -> torch.Tensor:
    raw  = sys.stdin.buffer.read()
    data = np.load(io.BytesIO(raw))
    T    = torch.from_numpy(data["A"].astype(np.float32)).cuda().contiguous()
    assert T.shape == (N, N)
    return T


# Output
def write_output_npy(result: torch.Tensor):
    buf = io.BytesIO()
    np.save(buf, result.cpu().numpy())
    sys.stdout.buffer.write(buf.getvalue())


# Main
def main():
    parser = argparse.ArgumentParser(description="Transpose-add: Triton")
    parser.add_argument("-N", type=int, required=True)
    args = parser.parse_args()

    T = load_input_npz(args.N)

    # triggers autotuner  but NOT captured as the measured kernel by nsys
    _ = triton_transpose_add(T)
    torch.cuda.synchronize()

    # nsys profiling
    result = triton_transpose_add(T)
    torch.cuda.synchronize()

    write_output_npy(result)


if __name__ == "__main__":
    main()
    