#include <cstdlib>
#include <iostream>
#include <unistd.h>
#include <string>
#include <fstream>
#include "ArbreBinaire.h"

noeud::noeud(int valeur) {
  pere = NULL;
  filsG = NULL;
  filsD = NULL;
  val = valeur;
}

ArbreBinaire::ArbreBinaire() {
  racine = NULL;
}

void fauxNoeud(int c, string cote, ofstream& output) {
  output << "  " << cote << c << " [label=" << c << ", style = invis];" << endl;
  output << "  N" << c << "-> " << cote << c << " [style=invis];" << endl;
}

int noeud::dessiner(ofstream& output, int c)
{
  output << "  N" << c << " [label = " << val << "];" << endl;
  int d = c;
  if (filsG) {
    output << "  N" << c << " -> N" << (c+1) << ";" << endl;
    d = filsG->dessiner(output, c+1);
    if (!filsD) fauxNoeud(c, "D", output);
  }
  if (filsG or filsD) fauxNoeud(c, "C", output); 
  if (filsD) {
    if (!filsG) fauxNoeud(c, "G", output);
    output << "  N" << c << " -> N" << (d+1) << ";" << endl;
    d = filsD->dessiner(output, d+1);
  }
  return d;
}

void ArbreBinaire::dessiner(string name)
{
  ofstream output;
  output.open(name + ".dot");
  output << "digraph G {" << endl;
  output << "  node [style=filled];" << endl;
  
  if (racine) racine->dessiner(output, 0);

  output << "}" << endl;
  output.close();

  if (!system(NULL)) exit (EXIT_FAILURE);
  string s = "dot -Tpdf " + name + ".dot > " + name + ".pdf";
  int i = system(s.c_str());
  if (i != 0) exit (EXIT_FAILURE);
}
  
void ArbreBinaire::remplacer(noeud* x, noeud* z)
{
    noeud* p = x->pere;
    x->pere = NULL;
    if (!p) racine = z;
    else if (x == p->filsG) p->filsG = z;
    else p->filsD = z;
    if (z) z->pere = p;
}


