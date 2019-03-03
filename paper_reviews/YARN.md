# Review of "Apache Hadoop YARN: Yet Another Resource Negotiator"
Claudio Montanari (cmonta9) 


## Summary
In the paper the authors first analyze the weaknesses and problems of Apache Hadoop: from one side the framework was focused only on a "map-reduce" programming model with a centralized control logic; on the other hand, a wide portion of the programming community needed a more flexible and scalable solution (which leads to some improper workaround). Then, a description of the YARN architecture and of its implementation is given. Finally, the proposed solution is evaluated over a real world deployment at Yahoo! and compared to other frameworks.  


## Problem Description

Apache Hadoop was implemented for handling massive and data intensive MapReduce jobs but very often this programming paradigm was bypassed (implementing "map-only" jobs). This highlighted the two main problems of Hadoop: the need to support other programming models and the need to decouple the control logic from the data processing to allow for a more scalable job scheduling. 
Also, due to the massive usage of MapReduce applications, such new system must not be a radical redesign of its predecessor; so that the effort from the programming community to move to YARN would be minimal. 

[//]: # (Replace with text with a description of the problem they were trying to solve and why this is an important problem.)



## Contributions

YARN is a reliable and scalable resource manager build on top of HDFS which also enables efficient scheduling of different data processing or operational jobs. The YARN architecture comes with three main component:

- Resource Manager (RM): demon that tracks resource usage and liveliness on a cluster of nodes; it is also responsible to grant leases on such resources, expressed in terms of "containers" (i.e. 2GB RAM, 1 CPU), to competing application.  

- Node Manager (NM): demon that runs on each node responsible for: monitoring resource status (i.e. availability and faults) and notifying such information to the RM using an heartbeat-based communication.

- Application Master (AM): process that coordinates the execution of an application in a cluster (it can be a static set of processes, long-running services etc.). It communicates its resources demand with the RM and dynamically updates them if something changes in the running cluster environment (i.e. in case of faults or scarcity/abundance of resources).

In such a way it's possible to have many applications coexist efficiently on the same cluster. Furthermore, other useful features have been added, such as locality awareness, backward compatibility, fault tolerance and authentication.

[//]: # ( Replace this text with a summary of the contributions of the paper. What is the hypothesis of the work?  What is the proposed solution, and what key insight guides their solution?)


## Evaluation
YARN has been evaluated at Yahoo! over a cluster of 2500 nodes in terms of job throughput and average resource utilization, varying the workload in terms of: number of applications and containers per job. The authors were able to demonstrate almost a X2 in terms of CPU utilization. In addition, other more tailored benchmarks have been tested like sorting algorithms (establishing a world record) and MapReduce benchmarks.      
Finally, they presented a list of popular frameworks (Apache Hadoop MapReduce, Apache Tez...) that already moved to YARN and their consequent benefits.

[//]: # ( Replace this text with a summary of the evaluation in this paper. What did the paper evaluate and was it appropriate?)


## Limitations and Possible Improvements
YARN uses a batch processing approach which can lead to a lot of read/write to disk. This does not represent a critical issue as long as we do not care about real-time / low latency processing. Also, it can be non optimal in the case of long iterative jobs (very common in Machine Learning) where we should try to take advantage of in-memory processing.    


[//]: # ( Replace this text with a discussion of the limitations of the paper. What is one -or more- drawback or limitation of the proposal, and how would you improve it?)


## Discussion
YARN was able to attract a wide portion of the programming community, how the needs of such community are changed in the last 5 years and what YARN should do to tackle such new needs? 

[//]: # ( Replace this text with at least one thing about the paper you would like to discuss in class. )
