import sys
import io
import argparse
import numpy as np
import torch

# Core kernel
def add_with_transpose(T: torch.Tensor) -> torch.Tensor:
    """Computes T + T^T"""
    return T + T.t()


# Input
def load_input_npz(N: int) -> torch.Tensor:
    """Read input.npz from stdin binary stream"""
    raw = sys.stdin.buffer.read()
    data = np.load(io.BytesIO(raw))
    T = torch.from_numpy(data["A"].astype(np.float32))
    assert T.shape == (N, N), f"Expected ({N},{N}), got {T.shape}"
    return T


# Output
def write_output_npy(result: torch.Tensor):
    """Write result as .npy to stdout binary stream"""
    buf = io.BytesIO()
    np.save(buf, result.cpu().numpy())
    sys.stdout.buffer.write(buf.getvalue())


# Main
def main():
    parser = argparse.ArgumentParser(description="Transpose-add: PyTorch")
    parser.add_argument("-N", type=int, required=True, help="Matrix size NxN")
    parser.add_argument("--mode", choices=["cpu", "gpu", "inductor"],
                        default="gpu", help="Execution mode (default: gpu)")
    args = parser.parse_args()

    T = load_input_npz(args.N)

    if args.mode == "cpu":
        result = add_with_transpose(T)

    elif args.mode == "gpu":
        device = torch.device("cuda")
        T_gpu = T.to(device)
        # temp run not timed and nsys will capture the actual kernel below
        _ = add_with_transpose(T_gpu)
        torch.cuda.synchronize()
        # actual run this is what nsys will profile
        result = add_with_transpose(T_gpu)
        torch.cuda.synchronize()
        result = result.cpu()

    elif args.mode == "inductor":
        device = torch.device("cuda")
        T_gpu = T.to(device)
        fn = torch.compile(add_with_transpose, backend="inductor")
        # triggers compilation, not timed by nsys kernel
        _ = fn(T_gpu)
        torch.cuda.synchronize()
        # actual run
        result = fn(T_gpu)
        torch.cuda.synchronize()
        result = result.cpu()
    
    write_output_npy(result)


if __name__ == "__main__":
    main()
    