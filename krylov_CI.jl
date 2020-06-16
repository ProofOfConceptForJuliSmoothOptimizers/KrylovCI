using Pkg
Pkg.activate("./jenkins_env/")
Pkg.add(["PkgBenchmark", "BenchmarkTools", "MatrixDepot", "MatrixMarket", "GitHub", "JSON", "LinearOperators"])

using PkgBenchmark
Pkg.develop(PackageSpec(path="./Krylov.jl"))
Pkg.update()

fetch_ssmc(ufl_posdef, format="MM")

# PkgBenchmark.benchmarkpkg("Krylov")
include("./Krylov.jl/benchmark/run_benchmarks.jl")
