#!/bin/bash

echo "Github_auth: $GITHUB_AUTH"
julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c '**Starting benchmarks!**'  

if julia benchmark/run_benchmarks.jl $bmark_file ; then

    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -g
else
    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c '**An error has occured while running the benchmarks in file $bmark_file** '
fi