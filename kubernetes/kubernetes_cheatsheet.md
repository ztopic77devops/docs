# Kubernetes Cheat Sheet

## ArgoCD Application Example

Update:

- `metadata.name`
- `spec.destination.namespace`
- `spec.source.path`
- `spec.source.repoURL`

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <appName>
spec:
  destination:
    name: ''
    namespace: <namespace>
    server: 'https://kubernetes.default.svc'
  source:
    path: <path>
    repoURL: 'https://path/to/repo.git'
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
    syncOptions:
      - Replace=true
```


## Set Current Namespace

```bash
kubectl config set-context --current --namespace=<namespace>
```

---

# Basic Resource Listing

## List Pods

```bash
kubectl -n <namespace> get pods
kubectl -n <namespace> get po
```

## List Deployments

```bash
kubectl -n <namespace> get deployments
kubectl -n <namespace> get deploy
```

## List Services

```bash
kubectl -n <namespace> get services
kubectl -n <namespace> get svc
```

## List Ingresses

```bash
kubectl -n <namespace> get ingress
kubectl -n <namespace> get ing
```

## List Namespaces

```bash
kubectl get namespaces
kubectl get ns
```

---

# Detailed Information

## Describe Pod

```bash
kubectl -n <namespace> describe pod <podName>
```

## Describe Deployment

```bash
kubectl -n <namespace> describe deployment <deploymentName>
```

## Get Deployment YAML

```bash
kubectl -n <namespace> get deployment <deploymentName> -o yaml
```

## Get Deployment JSON

```bash
kubectl -n <namespace> get deployment <deploymentName> -o json
```

---

# Logs

## Show Pod Logs

```bash
kubectl -n <namespace> logs <podName>
```

## Follow Logs

```bash
kubectl -n <namespace> logs -f <podName>
```

## Show Logs From Specific Container

```bash
kubectl -n <namespace> logs <podName> -c <containerName>
```

## Show Previous Container Logs

Useful after a crash/restart:

```bash
kubectl -n <namespace> logs <podName> --previous
```

---

# Restart Deployment

```bash
kubectl -n <namespace> rollout restart deployment <deploymentName>
```

## Check Rollout Status

```bash
kubectl -n <namespace> rollout status deployment <deploymentName>
```

## Rollback Deployment

```bash
kubectl -n <namespace> rollout undo deployment <deploymentName>
```

---

# Working With Contexts / Environments

## Show Available Contexts

```bash
kubectl config get-contexts
```

## Switch Context

```bash
kubectl config use-context <namespace>
```

## Show Current Context

```bash
kubectl config current-context
```

---

# Execute Commands Inside Containers

## Execute Command In Pod

```bash
kubectl -n <namespace> exec <podName> -- <command>
```

## Open Interactive Shell

```bash
kubectl -n <namespace> exec -it <podName> -- bash
```

If bash is unavailable:

```bash
kubectl -n <namespace> exec -it <podName> -- sh
```

## Execute Command In Specific Container

```bash
kubectl -n <namespace> exec -it <podName> -c <containerName> -- bash
```

---

# Namespaces

## Get Deployments In Namespace

```bash
kubectl -n <namespace> get deployments
```

## Get Pods In Namespace

```bash
kubectl -n <namespace> get pods
```

## Get Services In Namespace

```bash
kubectl -n <namespace> get services
```

## Get All Resources In Namespace

```bash
kubectl -n <namespace> get all
```

---

# Delete / Restart Pods

## Force Delete Pod

```bash
kubectl -n <namespace> delete pod <podName> --grace-period=0 --force
```

#### Kubernetes will usually recreate the pod automatically if it belongs to a Deployment.

---

# Scaling

## Scale Deployment

```bash
kubectl -n <namespace> scale deployment <deploymentName> --replicas=0
```


## Scale Back Up

```bash
kubectl -n <namespace> scale deployment flex-offer-internal --replicas=1
```

---

# Useful Additional Commands

## Watch Resources Continuously

```bash
kubectl -n <namespace> get pods -w
```

---

## Sort Pods By Restart Count

```bash
kubectl -n <namespace> get pods --sort-by='.status.containerStatuses[0].restartCount'
```

---

# Show Node Information

```bash
kubectl get nodes
```

Detailed:

```bash
kubectl describe node <nodeName>
```

---

# Show Pod Resource Usage

Requires metrics-server.

```bash
kubectl -n <namespace> top pods
```

## Show Node Resource Usage

```bash
kubectl top nodes
```

---

# Port Forwarding

## Forward Local Port To Pod

```bash
kubectl -n <namespace> port-forward pod/<podName> 8080:80
```

## Forward Local Port To Service

```bash
kubectl -n <namespace> port-forward service/<serviceName> 8080:80
```

---

# Copy Files

## Copy File To Pod

```bash
kubectl -n <namespace> cp ./local.txt <podName>:/tmp/local.txt
```

## Copy File From Pod

```bash
kubectl -n <namespace> cp <podName>:/tmp/log.txt ./log.txt
```

---

# Apply / Delete YAML

## Apply Configuration

```bash
kubectl -n <namespace> apply -f deployment.yaml
```

## Delete Configuration

```bash
kubectl -n <namespace> delete -f deployment.yaml
```

---

# Debugging

## Show Events

```bash
kubectl -n <namespace> get events --sort-by=.metadata.creationTimestamp
```

## Explain Kubernetes Resource Fields

```bash
kubectl explain deployment
```

## Explain Nested Fields

```bash
kubectl explain deployment.spec.template.spec
```

---

# Common Aliases

Add to ~/.bashrc or ~/.zshrc:

```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgs='kubectl get svc'
alias kctx='kubectl config current-context'
```

Reload shell:

```bash
source ~/.bashrc
```

or:

```bash
source ~/.zshrc
```

