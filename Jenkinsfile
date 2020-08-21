// def bmarkFile = ""
pipeline {
  agent any
  options {
    skipDefaultCheckout true
  }
  triggers {
    GenericTrigger(
     genericVariables: [
        [
            key: 'action', 
            value: '$.action',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '[^(created)]', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'comment',
            value: '$.comment.body',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'org',
            value: '$.organization.login',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: 'ProofOfConceptForJuliSmoothOptimizers' //Optional, defaults to empty string
        ],
        [
            key: 'pullrequest',
            value: '$.issue.number',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '[^0-9]', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ],
        [
            key: 'repo',
            value: '$.repository.name',
            expressionType: 'JSONPath', //Optional, defaults to JSONPath
            regexpFilter: '', //Optional, defaults to empty string
            defaultValue: '' //Optional, defaults to empty string
        ]
     ],

     causeString: 'Triggered on $comment',

     token: 'KrylovCI',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,

     regexpFilterText: '$comment',
     regexpFilterExpression: '@JSOBot runbenchmarks'
    )
  }
  stages {
    stage('pull from repository') {
      steps {
        sh 'git clone https://${GITHUB_AUTH}@github.com/$org/$repo.git'
        dir(WORKSPACE + "/$repo") {
            sh 'git checkout ' + BRANCH_NAME
            sh 'git pull'
        }        
      }
    }
    stage('checkout on new branch') {
      steps {
        dir(WORKSPACE + "/$repo") {
          sh '''
          git fetch --no-tags origin '+refs/heads/master:refs/remotes/origin/master'
          git checkout -b benchmark
          '''    
        }   
      }
    }
    stage('run benchmarks') {
      script {
        def bmarkFile = getBenchmarkFile("$comment")
      }
      steps {
        dir(WORKSPACE + "/$repo") {
          sh '''
          set -x
          julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "**Starting benchmarks!**"
          julia benchmark/run_benchmarks.jl ${bmarkFile}
          '''
        }   
      }
    }
  }
  post {
    success {
      dir(WORKSPACE + "/$repo") {
        sh 'julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -g'
      }   
    }
    failure {
      dir(WORKSPACE + "/$repo") {
        sh 'julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "**An error has occured while running the benchmarks :( ** "'
      }   
    }
    cleanup {
      dir(WORKSPACE){
            sh "pwd"
        }        
      sh 'printenv'
      // sh 'git checkout ' + BRANCH_NAME
      sh '''
      rm -rf $repo
      '''
      // git branch -D benchmark
      // git clean -fd
    }
  }
}

def getBenchmarkFile(comment) {
  def bmarkFile = comment.tokenize(' ')
  return (bmarkfile.length > 2) ? bmarkfile[2]: 'benchmarks.jl'
}