#!/bin/bash
# Author: Diego Narducci
# E-mail: diego.narducci88@gmail.com

#Versão 0.1a -> Versão inicial.
######################################################
# Script de monityoramento de temperadura da placa de video, onde tem um setpoint para tomada de ação e 2 logs: um te temperatura minima outro de maxima, sao salvos em 2 arquiuvos no diretório corrente..
# Criei esse script por uma necessidade minha em monitorar a temperatura da placa de video enquanto realizava algo que gerasse extresse na mesma, assim que a temperatura da vga alcança o valor da variavel nvidiaTempMax automaticamente o programa ou jogo é fechado, o moniytoramento é feito a cada 30 segundos.

######################################################

start=0
nvidiaTempMax=71 # temperatura limite

echo "" > logTempMax.log
echo "" > logTempMin.log
while true
do
	if [ "$start" == 0 ]
	then
		start=1
	        tempMax=$(nvidia-smi | grep -i "%" | cut -c 9-10)
		tempMin=$(nvidia-smi | grep -i "%" | cut -c 9-10)
		echo "$tempMax graus - $(date)" > logTempMax.log
		echo "$tempMin graus - $(date)" > logTempMin.log
		sleep 30 # aguardar 30 segundos
	fi

	temp=$(nvidia-smi | grep -i "%" | cut -c 9-10)

	if [ "$temp" -gt "$tempMax" ]
	then
		tempMax=$temp
		echo "$tempMax graus - $(date)" >> logTempMax.log
	fi

	if [ "$temp" -lt "$tempMin" ]
	then
		tempMin=$temp
		echo "$tempMin graus - $(date)" >> logTempMin.log
	fi


	if [ "$temp" -gt "$nvidiaTempMax" ]
		then
			# ação a ser tomada qdo a temp passar do limite
			sudo pkill -9 -e .*steam.*
			sudo pkill -9 -e .*hl2.*

	fi
		sleep 30 # aguardar 30 segundos
done
