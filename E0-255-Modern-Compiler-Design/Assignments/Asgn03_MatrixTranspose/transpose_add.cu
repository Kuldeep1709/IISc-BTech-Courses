#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cuda_runtime.h>

#define TILE       32
#define Shared_Memory_Cols (TILE + 1)

#define CUDA_CHECK(call)                                                  \
    do {                                                                  \
        cudaError_t err = (call);                                         \
        if (err != cudaSuccess) {                                         \
            fprintf(stderr, "CUDA error at %s:%d — %s\n",                \
                    __FILE__, __LINE__, cudaGetErrorString(err));         \
            exit(EXIT_FAILURE);                                           \
        }                                                                 \
    } while (0)


// Kernel
__global__ void transpose_add_kernel( const float* __restrict__ T,float* __restrict__ Out, int N)
{
    __shared__ float shmem_A[TILE][Shared_Memory_Cols];
    __shared__ float shmem_B[TILE][Shared_Memory_Cols];

    int tx  = threadIdx.x;
    int ty  = threadIdx.y;
    int row = blockIdx.y * TILE + ty;
    int col = blockIdx.x * TILE + tx;

    // Load T[row, col] — coalesced
    shmem_A[ty][tx] = (row < N && col < N) ? T[row * N + col] : 0.0f;

    // Load transposed tile: T[bx*TILE+ty, by*TILE+tx] — coalesced
    int t_row = blockIdx.x * TILE + ty;
    int t_col = blockIdx.y * TILE + tx;
    shmem_B[ty][tx] = (t_row < N && t_col < N) ? T[t_row * N + t_col] : 0.0f;

    __syncthreads();

    // Out[row, col] = T[row,col] + T[col,row]
    // T[col,row] = shmem_B[tx][ty]
    if (row < N && col < N){
        Out[row * N + col] = shmem_A[ty][tx] + shmem_B[tx][ty];
    }
}


// Launcher
void launch_transpose_add(const float* d_T, float* d_Out, int N)
{
    dim3 threads(TILE, TILE);
    dim3 blocks((N + TILE - 1) / TILE, (N + TILE - 1) / TILE);
    transpose_add_kernel<<<blocks, threads>>>(d_T, d_Out, N);
    CUDA_CHECK(cudaGetLastError());
}


// Input
float* read_matrix_stdin(int* rows, int* cols)
{
    char line[65536];
    while (fgets(line, sizeof(line), stdin)) {
        if (line[0] != '#' && line[0] != '\n' && line[0] != '\r') break;
    }
    if (sscanf(line, "%d %d", rows, cols) != 2) {
        fprintf(stderr, "Error: could not read matrix dimensions\n");
        exit(1);
    }
    int n = (*rows) * (*cols);
    float* mat = (float*)malloc(n * sizeof(float));
    for (int i = 0; i < n; ++i) {
        if (fscanf(stdin, "%f", &mat[i]) != 1) {
            fprintf(stderr, "Error: could not read matrix data at element %d\n", i);
            exit(1);
        }
    }
    return mat;
}

// Output
void write_matrix_stdout(const float* mat, int rows, int cols)
{
    printf("%d %d\n", rows, cols);
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            printf("%.6f", mat[i * cols + j]);
            if (j < cols - 1) putchar(' ');
        }
        putchar('\n');
    }
}


// main
int main(int argc, char** argv)
{
    int N = -1;

    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "-N") == 0 && i + 1 < argc)
            N = atoi(argv[++i]);
    }

    if (N <= 0) {
        fprintf(stderr, "Usage: %s -N <size>\n", argv[0]);
        fprintf(stderr, "  Input:  stdin  (.dat text format)\n");
        fprintf(stderr, "  Output: stdout (.dat text format)\n");
        return 1;
    }

    // Read input from stdin
    int rows, cols;
    float* h_T = read_matrix_stdin(&rows, &cols);
    if (rows != N || cols != N) {
        fprintf(stderr, "Error: matrix is %dx%d but -N %d was given\n", rows, cols, N);
        return 1;
    }

    size_t bytes = (size_t)N * N * sizeof(float);
    float *d_T, *d_Out;
    CUDA_CHECK(cudaMalloc(&d_T,   bytes));
    CUDA_CHECK(cudaMalloc(&d_Out, bytes));
    CUDA_CHECK(cudaMemcpy(d_T, h_T, bytes, cudaMemcpyHostToDevice));

    // Temp Run : (not measured by nsys kernel summary as the benchmarked run)
    launch_transpose_add(d_T, d_Out, N);
    CUDA_CHECK(cudaDeviceSynchronize());

    // Actual run : this single kernel launch is what nsys profiles
    launch_transpose_add(d_T, d_Out, N);
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copy result back and write to stdout
    float* h_Out = (float*)malloc(bytes);
    CUDA_CHECK(cudaMemcpy(h_Out, d_Out, bytes, cudaMemcpyDeviceToHost));
    write_matrix_stdout(h_Out, N, N);

    free(h_T);
    free(h_Out);
    cudaFree(d_T);
    cudaFree(d_Out);
    return 0;
}