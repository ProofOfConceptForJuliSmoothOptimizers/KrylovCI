using Pkg
bmark_dir = @__DIR__
Pkg.activate(bmark_dir)
Pkg.develop(PackageSpec(url=joinpath(bmark_dir, ".."))) 
Pkg.instantiate()

using GitHub, JSON, PkgBenchmark
commit = benchmarkpkg("Krylov"; script=joinpath(bmark_dir, ARGS[1]))  # current state of repository
master = benchmarkpkg("Krylov", "master"; script=joinpath(bmark_dir, ARGS[1]))
judgement = judge(commit, master)
export_markdown("judgement.md", judgement)
export_markdown("master.md", master)
export_markdown("commit.md", commit)

gist_json = JSON.parse("""
    {
        "description": "A benchmark for Krylov repository",
        "public": true,
        "files": {
            "judgement.md": {
                "content": "$(escape_string(sprint(export_markdown, judgement)))"
            },
            "master.md": {
                "content": "$(escape_string(sprint(export_markdown, master)))"
            },
            "commit.md": {
                "content": "$(escape_string(sprint(export_markdown, commit)))"
            }
        }
    }""")

open("gist.json", "w") do f
    JSON.print(f, gist_json)
end