---
layout: post
title: Docker \'no supported platform found in manifest\'
---

Getting `ErrImagePull` and backoff.
Check events for pod and see message
1.12 = `Failed to pull image "traefik": rpc error: code = 2 desc = no supported platform found in manifest list`
17.06-ce = `Failed to pull image "traefik": rpc error: code = 2 desc = no matching manifest for linux/amd64 in the manifest list entries`
Go look at https://hub.docker.com/r/library/traefik/tags/ and see that last updated = 'an hour ago'. Thanks to https://github.com/docker-library/ruby/issues/159#issuecomment-329909957 for the tip. TODO link to /zeta/git/techotom-blog/assets/traefik-dockerhub-last-updated.jpg image.
The solution is to go back a version, so for me that's 1.4.1. Add `:1.4.1` label

```
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
      - image: traefik:1.4.1
        name: traefik-ingress-lb
```

```
$ kubectl get pods -o wide -n kube-system
NAME                                        READY     STATUS         RESTARTS   AGE       IP                NODE
etcd-kubernetes-master                      1/1       Running        0          4h        130.220.208.190   kubernetes-master
kube-apiserver-kubernetes-master            1/1       Running        0          4h        130.220.208.190   kubernetes-master
kube-controller-manager-kubernetes-master   1/1       Running        0          4h        130.220.208.190   kubernetes-master
kube-dns-2617979913-lh4lg                   3/3       Running        0          4h        10.32.0.2         kubernetes-master
kube-proxy-7cvcm                            1/1       Running        0          4h        130.220.208.190   kubernetes-master
kube-proxy-pzbth                            1/1       Running        0          1h        115.146.92.34     kubernetes-minion-2
kube-proxy-qhbwq                            1/1       Running        0          4h        130.220.208.181   kubernetes-minion-1
kube-scheduler-kubernetes-master            1/1       Running        0          4h        130.220.208.190   kubernetes-master
traefik-ingress-controller-rk97s            0/1       ErrImagePull   0          34s       115.146.92.34     kubernetes-minion-2
traefik-ingress-controller-zwg4w            0/1       ErrImagePull   0          34s       130.220.208.181   kubernetes-minion-1
weave-net-4l9kj                             2/2       Running        0          4h        130.220.208.181   kubernetes-minion-1
weave-net-5dk49                             2/2       Running        1          1h        115.146.92.34     kubernetes-minion-2
weave-net-vdwgl                             2/2       Running        0          4h        130.220.208.190   kubernetes-master
```

```
$ kubectl describe pod traefik-ingress-controller-zwg4w -n kube-system
Name:           traefik-ingress-controller-zwg4w
Namespace:      kube-system
Node:           kubernetes-minion-1/130.220.208.181
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

```Events:
  FirstSeen     LastSeen        Count   From            SubObjectPath                           Type            Reason                  Message
  ---------     --------        -----   ----            -------------                           --------        ------                  -------
  19m           19m             1       kubelet, node2                                          Normal          SuccessfulMountVolume   MountVolume.SetUp succeeded for volume "traefik-ingress-controller-token-zxl5l"
  19m           2m              8       kubelet, node2  spec.containers{traefik-ingress-lb}     Normal          Pulling                 pulling image "traefik"
  19m           2m              8       kubelet, node2  spec.containers{traefik-ingress-lb}     Warning         Failed                  Failed to pull image "traefik": rpc error: code = 2 desc = no matching manifest for linux/amd64 in the manifest list entries
  19m           6s              87      kubelet, node2                                          Warning         FailedSync              Error syncing pod
  19m           6s              79      kubelet, node2  spec.containers{traefik-ingress-lb}     Normal          BackOff                 Back-off pulling image "traefik"
```