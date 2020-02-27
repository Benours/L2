#include <cstdlib>
#include <iostream>
#include <unistd.h>
#include <string>
#include "ABR.h"

using namespace std;

//------------------------------------------------------
// Inserer un noeud z dans l'arbre A
//------------------------------------------------------

void ABR::inserer(int k)
{
  // A compléter
	if (racine == NULL){
	racine = new noeud(k);	
	}
	else{
		noeud* val = new noeud(k);
		noeud* rac = racine;
		noeud* p = new noeud(0);
		while(rac != NULL){
			p = rac;
			if (k < rac->val){
				rac = rac->filsG;
			}
			else{
				rac = rac->filsD;
			}
		}
		val->pere = p;
		if(val->val < p->val){
			p->filsG = val;
		}
		else {
			p->filsD = val;
		}
	}
}

//------------------------------------------------------
// Parcours infixe
//------------------------------------------------------

void ABR::parcoursInfixe(noeud* x)
{
  // A compléter
	if(x != NULL){
		parcoursInfixe(x->filsG);
		printf("%i; ", x->val);
		parcoursInfixe(x->filsD);
	}
}

//------------------------------------------------------
// Noeud de valeur minimale dans l'arbre
//------------------------------------------------------

noeud* ABR::minimum(noeud* x)
{
  // A compléter
	while(x->filsG != NULL){
		x = x->filsG;
	}
	return x;
}

//------------------------------------------------------
// Recherche d'un noeud de valeur k
//------------------------------------------------------

noeud* ABR::rechercher(int k)
{
  // A compléter
	noeud* x = racine;
	while((x != NULL) and (x->val != k)){
		if(k < x->val){
			x = x->filsG;
		}
		else{
			x = x->filsD;
		}
	}
	return x;
}

//------------------------------------------------------
// Recherche du successeur du noeud x
//------------------------------------------------------

noeud* ABR::successeur(noeud *x)
{
  // A compléter
	if(x->filsD != NULL){
		return minimum(x->filsD);
	}
	noeud* p = x->pere;
	while((p != NULL) and (x == p->filsD)){
		x = p;
		p = x->pere;
	}
	return p;
}

//------------------------------------------------------
// Suppression d'un noeud
//------------------------------------------------------

void ABR::supprimer(noeud* z)
{
  // A compléter
	if(z->filsG == NULL){
		remplacer(z,z->filsD);
	}
	else if(z->filsD == NULL){
		remplacer(z,z->filsG);
	}
	else{
		noeud* y = successeur(z);
		remplacer(y, y->filsD);
		remplacer(z,y);
		y->filsD = z->filsD;
		y->filsG = z->filsG;
		z->filsD = NULL;
		z->filsG = NULL;
		if(y->filsD != NULL){
			(y->filsD)->pere = y;
		}
		if(y->filsG != NULL){
			(y->filsG)->pere = y;
		}
	}
}


//------------------------------------------------------
// Rotations
//------------------------------------------------------

void ABR::rotationGauche(noeud* z)
{
  // A compléter
	if(z->filsD != NULL){
		noeud* y = z->filsD;
		if(z->pere != NULL){
			if(z->pere->filsG == z){
				z->pere->filsG = y;
				y->pere = z->pere;
			}
			else{
				z->pere->filsD = y;
				y->pere = z->pere;
			}
		}
		else{
			racine = y;
			y->pere = NULL;
		}
		z->filsD = y->filsG;
		y->filsG = z;
		z->pere = y;
	}
	else{
		printf("Erreur: Il n'a pas de fils droit!\n");
	}
}

void ABR::rotationDroite(noeud* z)
{
  // A compléter
	if(z->filsG != NULL){
		noeud* x = z->filsG;
		if(z->pere != NULL){
			if(z->pere->filsD == z){
				z->pere->filsD = x;
				x->pere = z->pere;
			}
			else{
				z->pere->filsG = x;
				x->pere = z->pere;
			}
		}
		else{
			racine = x;
			x->pere = NULL;
		}
		z->filsG = x->filsD;
		x->filsD = z;
		z->pere = x;
	}
	else{
		printf("Erreur: Il n'a pas de fils gauche!\n");
	}
}
