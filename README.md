### A simple url shortner
  Slinky is a super simple url shortner written in `Ruby` with the help of `docker`, `Postgres`, `Sinatra` and `Rspec`   
  
## How to run
`docker-compose up`   
It will migrate the database automatically. No need to do anything else.  
  
## How to run test
`docker-compose -f docker-compose.rspec.yml up`  
  
## Thoughts on scaling
- The initial implemantaion is using a simple micro serivce architecture as illustrated below:
  
 ![micro service simple schema](https://raw.githubusercontent.com/sizief/slinky/master/documentation/slinky-simple.jpg)
  
- However if we are going to scale the system, probably these points can be improved:
  
![micro service advanced schema](https://raw.githubusercontent.com/sizief/slinky/master/documentation/slinky-advanced.jpg)
  
* Decoupling the `stats` service from the `main` service and create a separate service for `stats`
* Adding a `job` service to prevent micro seconds delay of writing to `stats` before retrieving urls
* Adding a Router, `Sinatra` could be an option
* Adding a load balancer, probably `Nginx` 
