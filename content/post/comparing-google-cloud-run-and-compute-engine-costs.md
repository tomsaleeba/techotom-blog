---
title: "Comparing Google Cloud Run and Compute Engine Costs"
date: 2020-05-28T10:54:45+09:30
summary: "How much do you pay for convenience? TL;DR roughly 2.5x as much"
tags:
- Google Cloud
---
I like working with containers because they're portable, repeatable and a
heap of other reasons, but that's not what this post is about. It's about how
run your containers in a cost effective way.

AWS ECS on Fargate is one method to "just deploy" your containers and not have
to worry about what they run on. That's great, but you need to pay for that
convenience. I found a blog post that did the calculations (don't have the link
anymore) to compare Fargate to EC2. The result was you were paying about 5x the
cost of an EC2 instance for your memory and compute. That's too much for me.

Today I stumbled across Google Cloud Run while looking for something else. I
couldn't find a blog post that has done the comparison between Cloud Run and
Compute Engine so I'm writing it!

Looking at the [Compute Engine
pricing](https://cloud.google.com/compute/vm-instance-pricing) and the [Cloud
Run pricing](https://cloud.google.com/run/pricing) for Sydney, because that's
where I'm running my workload, we get the following numbers:

```
Cloud run
$0.00002400 per vCPU-second = 0.00002400 * 3600 = 0.0864
$0.00000250 per GiB-Second = 0.00000250 * 3600 = 0.009

GCE
$0.030950 / vCPU hour
$0.004147 / GB hour
```

So we just need to turn vCPU/GiB seconds into hours by multiplying by 3600:
```
Cloud run
$0.00002400 * 3600 = 0.0864 per vCPU-hour
$0.00000250 * 3600 = 0.0090 per GiB-hour
```

Now we compare with GCE:
```
0.0864 / 0.030950 = 2.791599
0.0090 / 0.004147 = 2.170244
```

So Cloud Run is 2.8x more expensive for compute and 2.2x more expensive for
memory. This doesn't take into account
  - free usage for Cloud Run
  - the fact that you don't pay when your container isn't running
  - the memory used by the OS in GCE, which can't run containers, but you still
      need to pay for
  - your time! You need to setup and maintain a VM and that's not cheap.

It also doesn't address the fact that for memory, there appears to be two
different units in play: GB and GiB. I couldn't find enough info in the Google
Cloud doco to tell me if that is a typo or they do actually use different units.
Assuming it's correct, we can convert knowing the 1GB = 0.931323GiB.

```
GCE
$0.004147 per GB hour = 0.004147 * 0.931323 = $0.003862 per GiB hour
```

Now we compare with Cloud Run:

```
0.0090 / 0.003862 = 2.330399
```

The situation is slightly worse at 2.3x the cost for memory.

In any case, I'm very happy with the direction that pricing for this type of
service is headed :D
