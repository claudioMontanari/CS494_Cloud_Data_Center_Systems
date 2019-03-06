# Review of "Realtime Data Processing at Facebook"
Claudio Montanari (cmonta9) 


## Summary
[//]: # (Replace this text with a one or two sentence summary of the paper)
This paper can be considered as a design manual to build a system for Big Data real-time processing. The authors go through all the main design decisions and most important qualities of such a system. Their intuitions are supported by a description of the real-time architecture implemented at Facebook and by how some applications they deployed take advantage of it.    


## Problem Description
[//]: # (Replace with text with a description of the problem they were trying to solve and why this is an important problem.)
When building a real-time Big Data processing system at a company like Facebook not only many different requirements must be satisfied, but also conflicting ones (i.e. fast prototyping vs high performance). Developing a set of good and reliable design decisions in such a context was the main problem faced by the authors.   


## Contributions
[//]: # ( Replace this text with a summary of the contributions of the paper. What is the hypothesis of the work?  What is the proposed solution, and what key insight guides their solution?)
Under the assumptions that seconds of latency are enough and that ACID properties are not always necessary, the authors provide some key insights about 5 main design decisions they had to face:  

- __Language Paradigm:__ which impacts both on the easiness of use and on how much control over the system the application writer has. As a consequence, they allowed SQL (easy to use), Python (fast prototyping) and C++ (greatest flexibility) applications.
- __Data transfer:__ which heavily impacts on fault tolerance, reliability, easiness of debugging and performance. Since latency requirements were in the order of second they trade on performance in order to have a persistent message bus (which enhance all the other properties).
- __Processing Semantics:__ which determines correctness and fault tolerance on a processing element. In such a case, since there were many different exigences to satisfy, the authors allowed for different processing semantics, letting the application writer decide which one to use. 
- __State Saving Mechanisms:__ which impacts fault-tolerance on stateful processors. Even in this case since they had different demands they implemented multiple fault tolerance solutions (i.e. local database or remote database models). 
- __Back-filling Processing:__ for several reasons (i.e. for debugging or testing of a new feature) data re-processing is something quite common; thus, they provided different solutions to store and retrieve such data, most of them rely on Hive. 

The overall principle that guided the authors' intuitions was: "keep the system simple". Which is in line with and enhance Facebook's culture of "move fast" and "iterate". This led to the creation of multiple, tailored and simple sub-systems in their architecture (Puma, Stylus, Swift, Scribe, etc...). 


## Evaluation
[//]: # ( Replace this text with a summary of the evaluation in this paper. What did the paper evaluate and was it appropriate?)
The paper evaluation mainly relies on giving some use case scenario that were faced at Facebook and demonstrating how a combination of elements of the new system could satisfy different requirements.  


## Limitations and Possible Improvements
[//]: # ( Replace this text with a discussion of the limitations of the paper. What is one -or more- drawback or limitation of the proposal, and how would you improve it?)
Since a wide range of systems are described the reader can only have an high level idea of how they really work / are implemented. For the same reason, few performance analysis are presented to the reader.  


## Discussion
[//]: # ( Replace this text with at least one thing about the paper you would like to discuss in class. )
Facebook is a company that faces a lot of different scenarios when dealing with real-time data processing; so it makes sense for them to have such an heterogeneous system. It might be interesting discussing how, other (maybe smaller) companies, would have faced the implementation of such a system and if they would have adopted the same design decisions taken by Facebook.  


