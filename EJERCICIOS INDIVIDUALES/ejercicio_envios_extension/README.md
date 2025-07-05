# Ejercicio Envios

Desarrollar una aplicación que permita cotizar el envío de paquetes.

Cada envío incluye un conjunto de paquetes, tiene un volumen máximo de 10 litros y costo variable que está dado por:
* La suma del costo individual de cada paquete
* Un recargo del 10% en el caso de desperdicio (cuando el volumen total del envío es menor a 5 litros)


Los paquetes  pueden ser:
* cuadrados: de volumen 1 y su depende de la cantidad de cuadrados en el envio; hasta 3 paquetes el costo es de 2, por encima de ello el costo es de 1.
* redondos: de volumen 2 y costo 4
* triangulares: de volumen 3 y costo 3

Al mismo tiempo cada envío tiene que cumplir con ciertas restricciones:
* Solo pueden incluir un paquete triangular salvo que todos los paquetes del envío sean triangulares
* Todo envío debe incluir al menos un paquete
* Ningun envio puede incluir más de 8 paquetes

