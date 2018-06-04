

all:
	git clone https://github.com/clasp-developers/trivial-garbage.git ../trivial-garbage
	git clone https://github.com/clasp-developers/bordeaux-threads.git ../bordeaux-threads
	git clone https://github.com/clasp-developers/cffi.git ../cffi
	git clone https://github.com/clasp-developers/cl-fad.git ../cl-fad
	git clone https://github.com/clasp-developers/trivial-gray-streams.git ../trivial-gray-streams
	git clone https://github.com/clasp-developers/usocket.git ../usocket
	git clone https://github.com/clasp-developers/uuid.git ../uuid
	git clone https://github.com/drmeister/cl-jupyter.git ../cl-jupyter
	git clone https://github.com/clasp-developers/cl-jupyter-widgets.git ../cl-jupyter-widgets
	git clone https://github.com/clasp-developers/cl-nglview.git ../cl-nglview
	git clone https://github.com/clasp-developers/cl-bqplot.git ../cl-bqplot


clean:
	rm -rf ../trivial-garbage
	rm -rf ../bordeaux-threads
	rm -rf ../cffi
	rm -rf ../cl-fad
	rm -rf ../trivial-gray-streams
	rm -rf ../usocket
	rm -rf ../uuid
	rm -rf ../cl-jupyter
	rm -rf ../cl-jupyter-widgets
	rm -rf ../cl-nglview
	rm -rf ../cl-bqplot

