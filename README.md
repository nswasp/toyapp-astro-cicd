# Astro SSR CI/CD (toyapp)

This repository contains a scaffold for the DevOps practical: building an Astro SSR app image, packaging a Helm chart, pushing Helm to an OCI registry, and deploying to OpenShift with an optional Nginx BasicAuth sidecar.

Files added:
- `Dockerfile` — multi-stage build for Astro SSR
- `Jenkinsfile` — pipeline: build/push/package/push-helm/deploy
- `charts/toyapp` — Helm chart with templates

Quick local checks

Build image (local):
```bash
docker build -t toyapp:local .
docker run -p 4321:4321 toyapp:local
```

Template Helm manifests:
```bash
helm lint charts/toyapp
helm template charts/toyapp --set image.repository=registry.example.com/nswasp/toyapp --set image.tag=latest
```

Push & deploy (CI / manual)

1. Build and push image (CI):
```bash
docker buildx build --platform linux/amd64 -t $IMAGE_REPO:$IMAGE_TAG --push .
```
2. Package and push Helm chart:
```bash
helm package charts/toyapp -d out
helm registry login -u $HELM_USER -p $HELM_PASS $HELM_REG
helm push out/*.tgz oci://$HELM_REG
```
3. Deploy to OpenShift:
```bash
oc login --token=... --server=https://api.cluster.example
helm upgrade --install toyapp-$RELEASE oci://$HELM_REG/toyapp --set image.repository=$IMAGE_REPO --set image.tag=$IMAGE_TAG --namespace $NAMESPACE --atomic
oc get pods -n $NAMESPACE
oc get route -n $NAMESPACE
```

Notes:
- `app.auth.enabled` toggles creation of a BasicAuth secret and the nginx sidecar. When enabled, traffic is routed via port 8080. When disabled, service targetPort maps to the app port (4321).
- The Helm helper `chart.parseEnv` converts the `envVars` multi-line string into container env entries.
