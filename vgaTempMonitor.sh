#!/bin/bash
# Author: Diego Narducci
# E-mail: diego.narducci88@gmail.com

#Versão 0.1a -> Versão inicial.
######################################################
# Script de monitoramento de temperadura da placa de video, onde tem um setpoint para tomada de ação e 2 logs: um te temperatura minima outro de maxima, sao salvos em 2 arquiuvos no diretório corrente..
# Criei esse script por uma necessidade minha em monitorar a temperatura da placa de video enquanto realizava algo que gerasse extresse na mesma, assim que a temperatura da vga alcança o valor da variavel nvidiaTempMax automaticamente o programa ou jogo é fechado, o moniytoramento é feito a cada 30 segundos.
#
# Utilização: ao executar ./vgaTempMonitor.sh, o programa ira criar 2 arquivos de log no diretorio corrente e ficará em loop, os logs seráo sempre atualizados com as maiores e menores temperaturas segfuidos da data e hoŕario da leitura fgeita
# se a temp lida for maior do que a temp estipulada nba variavel "nvidiaTempMax" seraõ encerrados os programas *** com o comando pkilklk]
# obs1 : os logs nao sao deletados automaticamente apos o término do script, a cada execução, os logs antigos serão soibreescritos
# obs2: para encerrar o programa feche a janela do terminal ou aperte ctrl + c.
######################################################

start=0 # Variavel de controle
nvidiaTempMax=71 # temperatura limite

echo "" > logTempMax.log # zerar arquivo de log
echo "" > logTempMin.log # ...
while true
do
	if [ "$start" == 0 ]
	then	# testa se é a primeira execução...
		start=1
	        tempMax=$(nvidia-smi | grep -i "%" | cut -c 9-10) # le a temp e armazena na variavel
		tempMin=$(nvidia-smi | grep -i "%" | cut -c 9-10) # ...
		echo "$tempMax graus - $(date)" > logTempMax.log # anexa no arquivo de log a primeira temp lida
		echo "$tempMin graus - $(date)" > logTempMin.log # ...
		sleep 30 # aguardar 30 segundos
	fi

	temp=$(nvidia-smi | grep -i "%" | cut -c 9-10) # lê temperatura...

	if [ "$temp" -gt "$tempMax" ] # verifica se temp atual é maior que a maxima registrada anteriormente
	then
		tempMax=$temp
		echo "$tempMax graus - $(date)" >> logTempMax.log # anexa no log
	fi

	if [ "$temp" -lt "$tempMin" ] # verifica se temp atual é menor que a maxima registrada anteriormente
	then
		tempMin=$temp
		echo "$tempMin graus - $(date)" >> logTempMin.log # anexa no log
	fi


	if [ "$temp" -gt "$nvidiaTempMax" ] # condicional para tomada de ação caso a temp lida seja maior do que estipulado na variuavel nvidiaTempMax
		then
			# ação a ser tomada qdo a temp passar do limite
			sudo pkill -9 -e .*steam.* # procura pela string do nome do programa que esteja em execuçao e encerra com sinal 9
			sudo pkill -9 -e .*hl2.* # ...

	fi
		sleep 30 # aguardar 30 segundos
done
