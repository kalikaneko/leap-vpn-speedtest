deps:
	sudo apt install speedtest-cli
run-seattle:
	GATEWAY=204.13.164.252 ./connect.sh
	python3 parse.py `ls -Art baseline*.log | tail -n 1`
	python3 parse.py `ls -Art data*.log | tail -n 1`
	mv baseline.csv baseline-seattle-`date +%m_%d_%H_%M`.csv
	mv data.csv data-seattle-`date +%m_%d_%H_%M`.csv
run-amsterdam:
	GATEWAY=37.218.242.191 ./connect.sh
	python3 parse.py `ls -Art baseline*.log | tail -n 1`
	python3 parse.py `ls -Art data*.log | tail -n 1`
	mv baseline.csv baseline-amsterdam-`date +%m_%d_%H_%M`.csv
	mv data.csv data-amsterdam-`date +%m_%d_%H_%M`.csv
clean:
	rm *.log
