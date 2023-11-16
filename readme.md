# Opstergo interview task

## Idea

Let's create HA master-slave, and some tasks around Redis DB.

Goal of this task is to create scripts and resources enabling local Kubernetes, required services, and data for development purposes.


## Guidelines and organisation

 * each written script should be verbose, and guide developer if something is missing
 * don't use Helm for deplyoment
 * for ease of use, script prefix should start with two digits number, ie. `00-minikube-up.sh` (already provided)
 * each script should have it's undo (inverse) "sister" script that deletes stuff
 * inverse scripts should start with prefix 99, decreasing with each new script, ie. `99-minikube-down.sh` deletes minikube installation created with `00-minikube-up.sh`
 * all services installed on kubernetes should be exposed "outside" Kubernetes to host service as well
 * It is okay if you don't know and don't finish task completely - please send any solution and reach out to us
 * If you have any questions - ask us on careers@opstergo.com
 * Deadline is one month from the moment you have recieved the task - take any needed time, it won't reflect the interview itself


## Task

### Redis

`01-redis-up.sh`
`98-redis-down.sh`

Architect Redis master-slave installation, and implement it. 
 * Master Redis node should have persistent storage, and data should survive pod restarts/deletion.
 * Slave Redis node doesn't need persistence, just need to follow master upon each start
 * minikube is started with 2 nodes, ensure that master and slave should never run on same k8s node

(note: suggesting simple solution, without sentinels and other advanced mechanisms)

**Kubernetes namespace**: `redis`

    
#### Redis (master) data import / clean

`redisImport.sh`
`redisClean.sh`

 * investigate and implement redis import within script `redisImport.sh`
 * data for import is placed inside `import/redis/data.txt`
 * create additional script for deleting all redis data called `redisClean.sh`     


#### (Recurring) tasks

`02-redis-info.sh`
`97-redis-info-downq.sh`

Write k8s recurring task that will output result of redis command `INFO replication` every 1minute.



### Final polish

`_dev_vars.sh`
    
 * `minikube ip` is not stable across `minikube start` / `minikube delete` commands
    * create script `_dev_vars.sh` and 
    * export ENV variables `REDIS_MASTER_HOST_PORT` reflecting redis master to use within running host
    * export ENV variables `REDIS_SLAVE_HOST_PORT` reflecting redis slave to use within running host
    * by sourcing script `source ./_dev_vars.sh`, current terminal session should have correct `REDIS_*` values, ie. `printenv|grep REDIS_`
      ```
      REDIS_MASTER_HOST_PORT=192.168.64.26:32400
      REDIS_SLAVE_HOST_PORT=192.168.64.26:32401
      ```


## Useful commands

  * start redis interactive shell: `kubectl -n redis exec -it deploy/redis -- /usr/local/bin/redis-cli`
  * execute redis command (`keys *`) from cli: `kubectl -n redis exec -it deploy/redis -- /usr/local/bin/redis-cli keys \*`
  * get k8s pods (from namespace -n `redis`): `kubectl -n redis get pods`
  * check pod's logs: `kubectl -n redis logs POD_NAME`
  * https://redis.io/commands/replicaof
  
