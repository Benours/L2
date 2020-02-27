#include <cstdlib>
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <string>

#pragma once

using namespace std;

struct noeud {
  int val;
  noeud* pere;
  noeud* filsG;
  noeud* filsD;

  noeud (int);
  int dessiner(ofstream&, int);
};

class ArbreBinaire {
  public:
    noeud* racine;
    ArbreBinaire();
    void dessiner(string);
    void remplacer(noeud*, noeud*);
};
