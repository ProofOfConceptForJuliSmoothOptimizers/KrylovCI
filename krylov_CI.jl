using Pkg
Pkg.activate("./jenkins_env/")

Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators"])
Pkg.develop(PackageSpec(path="./Krylov.jl"))
Pkg.update()

using SuiteSparseMatrixCollection


ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

# PkgBenchmark.benchmarkpkg("Krylov")
include("./Krylov.jl/benchmark/run_benchmarks.jl")
