DEVICE=enp38s0f1 

deps:
	sudo apt install speedtest-cli
run-seattle1:
	GATEWAY=204.13.164.252 ./connect.sh
	python3 parse.py `ls -Art baseline*.log | tail -n 1`
	python3 parse.py `ls -Art data*.log | tail -n 1`
	mv baseline.csv baseline-seattle1-`date +%m_%d_%H_%M`.csv
	mv data.csv data-seattle1-`date +%m_%d_%H_%M`.csv
run-seattle2:
	GATEWAY=204.13.164.207 ./connect.sh
	python3 parse.py `ls -Art baseline*.log | tail -n 1`
	python3 parse.py `ls -Art data*.log | tail -n 1`
	mv baseline.csv baseline-seattle2-`date +%m_%d_%H_%M`.csv
	mv data.csv data-seattle2-`date +%m_%d_%H_%M`.csv
run-amsterdam:
	GATEWAY=37.218.242.191 ./connect.sh
	python3 parse.py `ls -Art baseline*.log | tail -n 1`
	python3 parse.py `ls -Art data*.log | tail -n 1`
	mv baseline.csv baseline-amsterdam-`date +%m_%d_%H_%M`.csv
	mv data.csv data-amsterdam-`date +%m_%d_%H_%M`.csv
loss-new:
	sudo tc qdisc add dev ${DEVICE} root netem loss 1% 25%
loss-change:
	sudo tc qdisc change dev ${DEVICE} root netem loss 10% # 20%
loss-reset:
	sudo tc qdisc change dev ${DEVICE} root netem loss 0%
perf-seattle1:
	iperf3 -c 204.13.164.252 -p 4445 -R
perf-seattle2:
	iperf3 -c 204.13.164.207 -p 4445 -R | tee -a perf-seattle2.log
extract-data:
	./doextract.sh
clean:
	rm *.log
