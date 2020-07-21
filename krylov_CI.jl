using Pkg
Pkg.activate("./jenkins_env/")

Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators", "LearnBase"])
Pkg.pin(PackageSpec(name="LearnBase", version="0.3"))
Pkg.develop(PackageSpec(path="./"))
Pkg.update()

using PkgBenchmark
using SuiteSparseMatrixCollection


ufl_posdef = filter(p -> p.structure == "symmetric" && p.posDef == "yes" && p.type == "real" && p.rows ≤ 100, ssmc)
fetch_ssmc(ufl_posdef, format="MM")

# PkgBenchmark.benchmarkpkg("Krylov")
include("./benchmark/run_benchmarks.jl")
