## Microservice Architecture example on using Azure Functions
This repo contains a reference example of implementing a microservice architecture using azure functions.

## function
This folder contains the function app code. Currently this consists of three simple functions as detailed below.

### Function1
This function demonstrates a typical HTTP trigger. It takes the input message and publishes it to a servicebus topic.

### Function2
This function triggers whenever a message is published to the servicebus. It pushes the received message into a storage queue.

### Function3
This function [polls a storage queue](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-queue#trigger---polling-algorithm) for new messages.

## terraform
This folder contains the infrastructure definition needed to run the above function app.