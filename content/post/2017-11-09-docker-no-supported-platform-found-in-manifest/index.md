---
date: "2017-11-09T00:00:00Z"
summary: What to do when you're trying to pull an image that DockerHub hasn't built
  yet.
tags:
- docker
- kubernetes
title: Docker 'no supported platform found in manifest'
aliases:
- /2017/11/09/docker-no-supported-platform-found-in-manifest.html
---

# TL;DR
As part of a Kubernetes deployment, I was trying to pull a Docker image from DockerHub that hadn't yet been built by DockerHub, even though it looked like it was ready in the list of tags. The solution is to either wait for a bit (30 minute maybe?) and try again or for the impatient, just specify the previous version of the image.

# Background
I was trying to deploy Traefik to my Kubernetes cluster but when I listed the pods, I'd see `ErrImagePull` and `ImagePullBackOff` errors for the Traefik pod(s).

```bash
$ kubectl get pods -o wide -n kube-system
NAME                                        READY     STATUS         RESTARTS   AGE       IP                NODE
...snip...
traefik-ingress-controller-rk97s            0/1       ErrImagePull   0          34s       1.1.1.2     kubernetes-minion-2
traefik-ingress-controller-zwg4w            0/1       ErrImagePull   0          34s       1.1.1.1     kubernetes-minion-1
```

I looked closer by listing the events for pod(s) and saw some more detail:

For Docker 1.12
```
$ kubectl describe pod traefik-ingress-controller-zwg4w -n kube-system
Name:           traefik-ingress-controller-zwg4w
Namespace:      kube-system
Node:           kubernetes-minion-1/1.1.1.1
...snip...
Events:
  FirstSeen     LastSeen        Count   From                            SubObjectPath                           Type            Reason                  Message
  ---------     --------        -----   ----                            -------------                           --------        ------                  -------
  55s           55s             1       kubelet, kubernetes-minion-1                                            Normal          SuccessfulMountVolume   MountVolume.SetUp suc
ceeded for volume "traefik-ingress-controller-token-bpvj7" 
  50s           50s             1       kubelet, kubernetes-minion-1    spec.containers{traefik-ingress-lb}     Normal          BackOff                 Back-off pulling imag
e "traefik"
  54s           35s             2       kubelet, kubernetes-minion-1    spec.containers{traefik-ingress-lb}     Normal          Pulling                 pulling image "traefi
k"
  51s           32s             2       kubelet, kubernetes-minion-1    spec.containers{traefik-ingress-lb}     Warning         Failed                  Failed to pull image 
"traefik": rpc error: code = 2 desc = no supported platform found in manifest list
  51s           32s             3       kubelet, kubernetes-minion-1                                            Warning         FailedSync              Error syncing pod
```
The important message here is:
```
Failed to pull image "traefik": rpc error: code = 2 desc = no supported platform found in manifest list
```
For Docker 17.06-ce
```
...snip...
Events:
  FirstSeen     LastSeen        Count   From            SubObjectPath                           Type            Reason                  Message
  ---------     --------        -----   ----            -------------                           --------        ------                  -------
  19m           19m             1       kubelet, node2                                          Normal          SuccessfulMountVolume   MountVolume.SetUp succeeded for volume "traefik-ingress-controller-token-zxl5l"
  19m           2m              8       kubelet, node2  spec.containers{traefik-ingress-lb}     Normal          Pulling                 pulling image "traefik"
  19m           2m              8       kubelet, node2  spec.containers{traefik-ingress-lb}     Warning         Failed                  Failed to pull image "traefik": rpc error: code = 2 desc = no matching manifest for linux/amd64 in the manifest list entries
  19m           6s              87      kubelet, node2                                          Warning         FailedSync              Error syncing pod
  19m           6s              79      kubelet, node2  spec.containers{traefik-ingress-lb}     Normal          BackOff                 Back-off pulling image "traefik"
```
The important message here has a bit more information:
```
Failed to pull image "traefik": rpc error: code = 2 desc = no matching manifest for linux/amd64 in the manifest list entries
```

Hmm, that's really weird. I'm just following the instructions and trying to pull the `latest` tag, it should be there. Plus, amd64 is hardly a weird architecture, surely it's the most common one out there? Or at least common enough.

Next step in the troubleshooting process, let's go look at [https://hub.docker.com/r/library/traefik/tags/]() and we can see that last updated date of the `latest` tag is *'an hour ago'*.

{{< figure src="traefik-dockerhub-last-updated.jpg" >}}

# The solution

The tag has been pushed to DockerHub but the image wasn't actually ready to be pulled yet. On top of that, the error doesn't indicate that it isn't availble **yet**, it just says it's not there like it'll never exist.

I didn't realise that DockerHub would say that there are new tags for an image before they were actually ready to be pulled, but it appears that was the case. I learned that this is even a thing from someone having a similar issue [https://github.com/docker-library/ruby/issues/159#issuecomment-329909957]().

As I was trying to implicitly pull the `latest` tag (`1.4.2` at the time of writing), the solution was to go back a version. In my case, that's `1.4.1`. Alternatively I could've just waited for the image to be built and then try again but who has time to wait for that!

To fix this in practice, I just needed to add the `:1.4.1` label to the image name in my YAML file. You can see the change made near the bottom of this file:

```yaml
# traefik.yml
kind: DaemonSet
apiVersion: extensions/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
  labels:
    k8s-app: traefik-ingress-lb
spec:
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      hostNetwork: true
      containers:
      - image: traefik:1.4.1 # added the ':1.4.1' label
        name: traefik-ingress-lb
```
...then I can deploy the updated yaml file to my Kubernetes cluster:
```bash
$ kubectl apply -f traefik.yml
```

After updating, everything goes smoothly. The older image is pulled, the pods are created and everyone is happy.
