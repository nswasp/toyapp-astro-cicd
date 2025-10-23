pipeline {
  agent any
  environment {
    IMAGE_REPO = "${env.IMAGE_REPOSITORY ?: 'registry.example.com/nswasp/toyapp'}"
    IMAGE_TAG = "${env.IMAGE_TAG ?: env.BRANCH_NAME ?: 'latest'}"
    IMAGE = "${IMAGE_REPO}:${IMAGE_TAG}"
    HELM_REG = "${env.HELM_REGISTRY ?: 'registry.example.com/helm'}"
    RELEASE_NAME = "toyapp-${env.BRANCH_NAME ?: 'local'}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build & Push') {
      steps {
        sh 'docker buildx build --platform linux/amd64 -t $IMAGE --push .'
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
        sh 'helm registry login -u $HELM_USER -p $HELM_PASS ${HELM_REG}'
        sh 'helm push out/*.tgz oci://$HELM_REG'
      }
    }
    stage('Deploy to OpenShift') {
      steps {
        sh "helm upgrade --install ${RELEASE_NAME} oci://$HELM_REG/toyapp --set image.repository=${IMAGE_REPO} --set image.tag=${IMAGE_TAG} --namespace ${NAMESPACE:-default} --atomic"
      }
    }
  }
}
