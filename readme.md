Notes from playing around with swagger codegen.

1. Generate stubs from an openapi doc 'petstore.json':

```
docker run --rm -v ${PWD}:/local swaggerapi/swagger-codegen-cli-v3 generate     -i /local/petstore.json     -l nodejs-server     -o /local/nodejs-server
```

note: there is also a fork of this project with a similar containerized workflow, tbd which is better: https://github.com/OpenAPITools/openapi-generator

2. Change the generated api/openapi.yaml servers key to

```
servers:
- url: http://localhost:8080
```

3. build the result into an image and run:

```
docker image build -t petstore:dev .
docker container run -p 8080:8080 petstore:dev
```

note: seems to install packages ala npm install at runtime, push this into the build.

4. hit docs at http://localhost:8080/docs/

5. curl an endpoint:

```
curl -X GET "http://localhost:8080/pet/0" -H "accept: application/json" -H "api_key: pika"
```

that api_key is obviously fake, will need to implement something later.

following the logic:
 - the /pet/{ID} route is listed in the oapi spec under paths: /pet/{petId}
 - that spec lists `operationId: getPetById` as the function name for the backend logic
 - `controllers/Pet.js` implements and exports a function getPetById, which like any good controller, chews up the request, passes relevant parameters onto the business logic implemented in PetService.js, and takes action against a promise returned by that business logic.
 - `service/PetService.js` defines getPetById as a function that actually defines said promise; default is some dummy logic that just returns the example response, but change this and rebuild to suit. This is where we'd connect to mongo, get some data, structure it into a json response and hand it back. Also, the template only defines resolve() results; there's an opportunity here to do reject() as well if mongo doesn't give us something reasonable.