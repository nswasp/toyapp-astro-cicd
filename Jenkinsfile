pipeline {
  agent any
  environment {
    IMAGE_REPO = "${env.IMAGE_REPOSITORY ?: 'registry.example.com/nswasp/toyapp'}"
    IMAGE_TAG = "${env.IMAGE_TAG ?: env.BRANCH_NAME ?: 'latest'}"
    IMAGE = "${IMAGE_REPO}:${IMAGE_TAG}"
    HELM_REG = "${env.HELM_REGISTRY ?: 'registry.example.com/helm'}"
    RELEASE_NAME = "toyapp-${env.BRANCH_NAME ?: 'local'}"
    // Optional cache registry for buildx caching. Example: registry.example.com/nswasp/cache
    BUILD_CACHE_REG = "${env.BUILD_CACHE_REG ?: ''}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Prepare') {
      steps {
        script {
          GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          env.GIT_COMMIT = GIT_COMMIT
          echo "Git commit: ${GIT_COMMIT}"
        }
      }
    }

    stage('Build & Push') {
      steps {
        script {
          // ensure docker buildx builder exists
          sh 'docker buildx create --use --name ci-builder || true'

          // Optionally use a remote cache registry if provided
          def cacheArgs = ''
          if (env.BUILD_CACHE_REG?.trim()) {
            cacheArgs = "--cache-from=type=registry,ref=${env.BUILD_CACHE_REG} --cache-to=type=registry,ref=${env.BUILD_CACHE_REG},mode=max"
          } else {
            cacheArgs = '--cache-to=type=inline'
          }

          // Build and push with buildx, include git SHA label
          sh "docker buildx build --platform linux/amd64 -t ${IMAGE} --label git-commit=${GIT_COMMIT} ${cacheArgs} --push ."
        }
      }
    }

    stage('Package Helm') {
      steps {
        sh 'helm lint charts/toyapp'
        sh 'helm package charts/toyapp -d out'
      }
    }

    stage('Push Helm OCI') {
      steps {
        // Expect HELM_USER and HELM_PASS to be provided as Jenkins credentials
        sh 'helm registry login -u $HELM_USER -p $HELM_PASS ${HELM_REG}'
        sh 'helm push out/*.tgz oci://$HELM_REG'
      }
    }

    stage('Deploy to OpenShift') {
      steps {
        // Assumes oc already logged in on the agent or KUBECONFIG is provided via credentials
        sh '''
          helm upgrade --install ${RELEASE_NAME} oci://$HELM_REG/toyapp \
            --set image.repository=${IMAGE_REPO} \
            --set image.tag=${IMAGE_TAG} \
            --set image.labels.gitSha=${GIT_COMMIT} \
            --namespace ${NAMESPACE:-default} \
            --atomic --timeout 5m
        '''
      }
    }
  }
  post {
    always {
      echo "Pipeline finished for ${RELEASE_NAME}"
    }
  }
}
