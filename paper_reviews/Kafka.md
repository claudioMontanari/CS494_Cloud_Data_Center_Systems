# Review of "Kafka: a Distributed Messaging System for Log Processing"
Claudio Montanari (cmonta9) 


## Summary

[//]: # (Replace this text with a one or two sentence summary of the paper)
The paper provide a description of Kafka: a system for real-time and low latency log data processing developed at LinkedIn.   

## Problem Description

[//]: # (Replace with text with a description of the problem they were trying to solve and why this is an important problem.)
In many contexts log data analysis (user interactions, clicks etc..) is no more an off production job; instead, several companies now need to process such data in real time. This generates a set of new challenges mainly because of the size of such data stream.


## Contributions

[//]: # ( Replace this text with a summary of the contributions of the paper. What is the hypothesis of the work?  What is the proposed solution, and what key insight guides their solution?)
Kafka comes with a standard Publisher-Subscriber messaging architecture: we have a number of _Producers_ which can publish some messages related to a certain _Topic_. Such messages are then managed by a _Broker_ and can be pulled by a set of _Consumers_ subscribed to that _Topic_. 

Some of the key insights that made Kafka performance better are the following:

- Avoiding the use of an index for the messages: messages are addressed using the logical offset in the log.   
- Avoiding explicit caching of messages, instead they rely on the underlying file system page cache. 
- _Brokers_ are stateless which means that the information on how much data has been consumed is maintained by the _Consumer_. From one side this makes messages deletion tricky but, on the other hand, it reduces the _Broker_ overhead.  
- There is no central "master" node, thus consumers coordinates themselves in a decentralized fashion. They rely on Zookeeper for this purpose.  
- They choose to guarantee at-least-one delivery instead of exactly-once (not really needed and too slow).



## Evaluation

[//]: # ( Replace this text with a summary of the evaluation in this paper. What did the paper evaluate and was it appropriate?)
Kafka has been evaluated in terms of both _Producers_ and _Consumers_ throughput against Apache ActiveMQ and RabbitMQ. Unfortunately, only synthetic tests are provided.    


## Limitations and Possible Improvements

[//]: # ( Replace this text with a discussion of the limitations of the paper. What is one -or more- drawback or limitation of the proposal, and how would you improve it?)
Kafka, at the time of the paper (2011), wasn't a fault tolerant system as we would expect: if a _Broker_ goes down any message stored on it and not yet consumed becomes unavailable. Furthermore, since there is no data replication, if the _Broker_ storage system is permanently damaged, the data are lost. 


## Discussion

[//]: # ( Replace this text with at least one thing about the paper you would like to discuss in class. )
It could be interesting to see how Kafka evolved from 2011 and discuss about what new features have been added to the system, especially with respect to fault tolerance. 