

all:
	git clone https://github.com/clasp-developers/trivial-garbage.git ../trivial-garbage
	git clone https://github.com/clasp-developers/bordeaux-threads.git ../bordeaux-threads
	git clone https://github.com/clasp-developers/cffi.git ../cffi
	git clone https://github.com/clasp-developers/cl-fad.git ../cl-fad
	git clone https://github.com/clasp-developers/trivial-gray-streams.git ../trivial-gray-streams
	git clone https://github.com/clasp-developers/usocket.git ../usocket
	git clone https://github.com/clasp-developers/uuid.git ../uuid

clean:
	rm -rf ../trivial-garbage
	rm -rf ../bordeaux-threads
	rm -rf ../cffi
	rm -rf ../cl-fad
	rm -rf ../trivial-gray-streams
	rm -rf ../usocket
	rm -rf ../uuid
