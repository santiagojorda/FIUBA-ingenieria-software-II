#!/bin/bash
# Este script recibe dos parametros: 
#  * nombre del equipo: en minuscula
#  * ambiente: test o prod
# El script requiere kubectl y espera que este ya configurado con conexion al cluster

set -e

EQUIPO=$1
AMBIENTE=$2

function crear_ambiente() {
  EQUIPO=$1
  AMBIENTE=$2
  NAMESPACE="$1-$2"
  echo "$NAMESPACE"
  
  kubectl create namespace $NAMESPACE

  sleep 3
  
  kubectl apply -n $NAMESPACE -f $AMBIENTE.configmap.yaml

  sleep 3

  kubectl apply -n $NAMESPACE -f service.yaml

  sleep 3

  kubectl apply -n $NAMESPACE -f deployment.yaml

  sleep 3

  kubectl apply -n $NAMESPACE -f $AMBIENTE.ingress.yaml

}

# TODO: validar parametros

crear_ambiente $EQUIPO $AMBIENTE
