# Review of "Applied Machine Learning at Facebook: A Datacenter Infrastructure Perspective"
Claudio Montanari (cmonta9) 


## Summary

[//]: # (Replace this text with a one or two sentence summary of the paper)
This paper gives an high level overview of the infrastructure (in terms of software development frameworks, ML services, hardware and network resources) build at Facebook to develop and deploy Machine Learning models.      

## Problem Description

[//]: # (Replace with text with a description of the problem they were trying to solve and why this is an important problem.)
In a company like Facebook Machine Learning is used in a variety of different context. Thus, the better approach is to make decision that are context wise; taking into account how data are generated, latency requirements and servers load cycles for instance. 

## Contributions

[//]: # ( Replace this text with a summary of the contributions of the paper. What is the hypothesis of the work?  What is the proposed solution, and what key insight guides their solution?)
From the software development perspective Facebook developed three main frameworks:

- __PyTorch:__ mainly for AI research project. Flexible and easy to debug front-end, not optimized for production and mobile development. 
- __Caffe2:__ mainly for training and deploying large scale machine learning models. Here the goal was to achieve maximum performance. 
- __FBLearner:__ suite of three tools each one specialized on a different aspect of the machine learning pipeline:
	- __Feature Store__ catalog for feature generation. It's like a marketplace where it's easy to share and find new feature generation techniques. 
	- __Flow__ tool that translates the execution flow of the training as a graph; in this way it enables scheduling and resource management.
	- __Predictor__ inference engine for Machine Learning models. Optimized for low latency results.

From the hardware and network resources perspective what we find are custom-designed servers:

- __CPU-based:__ a 2U chassis which can come in 2 variants: the first one for throughput oriented purposes (Broadwell-D processor, 32GB RAM and minimal disk); the second one optimized for compute and memory intensive tasks (2x Broadwell-EP or Skylake SP CPU, with large amounts of DRAM).
- __GPU-based:__ an 8-GPU mesh interconnected using a NVIDIA NVLink which can support NVIDIA Tesla P100 and V100 GPUs. Here the goal was to accelerate the training process.

In practice, given a ML service and it's training and inference requirements (how often the model have to be retrained, latency, are there diurnal peak cycles etc..) the service can take advantage of the above mentioned infrastructure.    



## Evaluation

[//]: # ( Replace this text with a summary of the evaluation in this paper. What did the paper evaluate and was it appropriate?)
The paper doesn't provide any kind of experimental data; the only way to evaluate the quality of their infrastructure is, I think, by evaluating, as users, the quality of ML services at Facebook. 


## Limitations and Possible Improvements

[//]: # ( Replace this text with a discussion of the limitations of the paper. What is one -or more- drawback or limitation of the proposal, and how would you improve it?)
The lack of experimental results has a negative impact on the quality of the paper but, this is almost balanced by the fact that a lot of interesting insights on the design of their ML infrastructure are given.  


## Discussion

[//]: # ( Replace this text with at least one thing about the paper you would like to discuss in class. )
It would be interesting to speculate on the reasons why customized hardware like ASICs and FPGAs, wasn't taken into account when developing such infrastructure and the impact of that decision.    