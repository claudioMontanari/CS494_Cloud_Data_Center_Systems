# Review of "One Trillion Edges: Graph Processing at Facebook-Scale"
Claudio Montanari (cmonta9) 


## Summary
[//]: # (Replace this text with a one or two sentence summary of the paper)

The paper is about some scalability and performance improvements done on the Apache Giraph framework at Facebook; in particular the handling of graphs up to one trillion edges was made possible. Other key extensions done on the Pregel model are presented; finally, the new system is evaluated against some real-world workload and applications. 


## Problem Description
[//]: # (Replace with text with a description of the problem they were trying to solve and why this is an important problem.)

Current frameworks for graph processing fail when it comes down to real-world graphs that are in the order of trillion of edges; in addition they are more difficult to integrate in HDFS for several reasons (i.e. implemented in languages like C++ not directly supported by HDFS). Thus, companies decided to compromise on performance and implement graph application on top of their already deployed MapReduce infrastructure.


## Contributions
[//]: # ( Replace this text with a summary of the contributions of the paper. What is the hypothesis of the work?  What is the proposed solution, and what key insight guides their solution?)

These are the main contributions given to the Apache Giraph framework:

- __Flexible input format:__ Giraph input model required to be vertex centric, they generalized this concept so that different format and also different sources are allowed as input to the same Giraph job.
- __Parallelization support:__ since Giraph applications are scheduled as MapReduce jobs their parallelization don't exploit multithreading inside a single worker. Thus, Giraph was extended to enable more workers per machine and worker local multithreading.
- __Memory optimizations:__ Giraph flexible model was overloading with work the JVM and the memory since data types were stored as different Java objects. Thus, an ad-hoc serialization method for the edges was provided; plus an interface that leverages Java primitives based on FastUtil takes care of edge stores.    
- __Sharded aggregators:__ aggregators are usually implemented using Zookeeper but this solution is limited by the size and complexity of the aggregators. Thus, they bypassed Zookeeper so that a node aggregator is randomly assigned to one of the workers.

The contributions to the compute model instead were focused on enabling a more flexible system; in particular: 

- They added some state changing API that can be called to initialize/finalize the computation on a node.
- They implemented a system to compute aggregated operations on the master node with a low synchronization overhead. 
- They extended the messaging interface with new types of messages that can be exchanged between nodes.
- They enabled in-memory messaging handling for very large messages (the message update must be associative and commutative). 


## Evaluation
[//]: # ( Replace this text with a summary of the evaluation in this paper. What did the paper evaluate and was it appropriate?)

The proposed solution was tested against several workloads and three main applications: _label propagation_, _PageRank_ and _friends of friends score_. Relevant speedup in terms of CPU time and elapsed time were measured while benchmarking against an Hive/Hadoop equivalent ecosystem.  


## Limitations and Possible Improvements
[//]: # ( Replace this text with a discussion of the limitations of the paper. What is one -or more- drawback or limitation of the proposal, and how would you improve it?)

As the authors state in the future work section that one big limitation is due to inefficient graph partitioning when the application is network bound. While the second one is due to the fact that sometimes the developer might be willing to deal with asynchronous computing if the  speedup gain is relevant; and this is not possible so far, since their implementation is based on a BSP (Bulk Synchronous Processing) model.


## Discussion
[//]: # ( Replace this text with at least one thing about the paper you would like to discuss in class. )

It can be interesting to discuss about how graph partitioning affects network bound applications and what are the main techniques used so far to face this problem.