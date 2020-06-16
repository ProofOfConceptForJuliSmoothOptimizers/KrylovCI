using Pkg
using PkgBenchmark

Pkg.activate("./jenkins_env/")

PkgBenchmark.benchmarkpkg("Krylov")
