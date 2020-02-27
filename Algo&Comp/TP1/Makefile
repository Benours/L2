DOT=$(wildcard *.dot)

all: tests

%: %.cc ABR.cc ArbreBinaire.cc
	g++ -Wall -Wpedantic $^ -o $@

clean:
	rm -f $(DOT) $(DOT:.dot=.pdf)
