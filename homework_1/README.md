# CS 494 - Cloud Data Center Systems

## Homework 1

### Setup Script

In order to properly set up the HDFS and Spark frameworks for the given network configuration ( 1 leader, 3 followers) do what follows:

- Set up parallel-ssh on the cluster:
	- Do `ssh-keygen -t rsa` on the leader node
	- Copy the public key into __~/.ssh/authorized_keys__ for each machine in the cluster
	- On the master add into a file called slaves the hostname of the nodes in the cluster 

- Run __init_script.sh__ with root privileges (don't use  sudo you just have to have root permissions on the cluster)

To check that the installation was successful execute on the master node `parallel-ssh -h slaves -P jps` and expect to have a similar output:

```
follower-1: 7959 DataNode
follower-1: 8142 Worker
follower-1: 8453 Jps
follower-2: 7996 DataNode
follower-2: 8152 Worker
follower-2: 8464 Jps
follower-3: 7953 DataNode
follower-3: 8107 Worker
follower-3: 8416 Jps
leader: 8710 NameNode
leader: 8977 SecondaryNameNode
leader: 9178 Master
leader: 9534 Jps
```

__OBS:__ In order to have an always working environment you have to add the path to `/users/claudio/hadoop-2.7.6/bin/` and to `/users/claudio/hadoop-2.7.6/sbin/ ` in the `$PATH` variable. To permanently do that, update `$PATH` in /etc/environment using `sudo`.