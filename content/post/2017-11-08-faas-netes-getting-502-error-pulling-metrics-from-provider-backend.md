---
date: "2017-11-08T00:00:00Z"
summary: How I caused headaches for myself by deploying faas-netes to a different
  namespace when it only wants to run in the default one.
tags:
- openfaas
- faas-netes
- kubernetes
title: faas-netes getting 502 'Error pulling metrics from provider/backend'
---
# TL;DR
You can't deploy faas-netes in your own namespace, you need to deploy it in the default namespace. It seems that the [https://github.com/openfaas/faas-netes/blob/32a818328921900f250501f1e117d1aee551b85b/faas.yml#L79](DNS lookup is fully specified) including the `default` namespace. If you want to use other namespaces, it seems that using the [https://github.com/openfaas/faas-netes/blob/master/HELM.md](Helm chart) is your best bet at the time of writing.

# Background
I've been playing with OpenFaaS and specifically faas-netes; the deployment of OpenFaaS on Kubernetes.

I deployed to my cluster with the following:
```
kubectl create namespace openfaas
kubectl apply -n openfaas -f https://raw.githubusercontent.com/openfaas/faas-netes/master/faas.yml,https://raw.githubusercontent.com/openfaas/faas-netes/master/monitoring.yml,https://raw.githubusercontent.com/openfaas/faas-netes/master/rbac.yml
```

Then I opened up the web UI and looked at the network traffic in developer tools and was seeing every AJAX call to '/system/functions` in the network logs getting a 502 error. Hmm, that's weird.

I tried using `faas-cli` and that wasn't going well either. It was also getting 500 HTTP response codes.

Looking at the logs for the `gateway` pod, I could see the error:
```
2017/11/09 05:09:13 http: proxy error: dial tcp: lookup faas-netesd.default.svc.cluster.local on 10.96.0.10:53: dial udp 10.96.0.10:53: i/o timeout
2017/11/09 05:09:13 < [http://faas-netesd.default.svc.cluster.local:8080/system/functions] - 502 took 2.650294 seconds
```
```
502 Error pulling metrics from provider/backend
```

# The solution
You can see that the DNS lookup that the `gateway` pod was attempting is `faas-netesd.default.svc.cluster.local`. This second part of that means that it's looking in the `default` namespace. That's not the `openfaas` namespace that I deployed to. Now it's starting to make sense. If you look at the YAML for the faas-netes service, you'll see that the [https://github.com/openfaas/faas-netes/blob/32a818328921900f250501f1e117d1aee551b85b/faas.yml#L79](DNS lookup is fully specified).

The problem is I was rebellious and didn't follow the instructions that said to deploy to the default namespace.

The solution is to **deploy to the default namespace**. So don't create your own namespace and deploy to it, just do:
```
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/faas.yml,https://raw.githubusercontent.com/openfaas/faas-netes/master/monitoring.yml,https://raw.githubusercontent.com/openfaas/faas-netes/master/rbac.yml
```

I think this was a conscious choice to address things like [https://github.com/openfaas/faas-netes/issues/12](DOS-ing the DNS service).

Most people probably won't have this problem because they'll follow the instructions but for those that do experience this problem and google for the error message, I hope this has helped you.
