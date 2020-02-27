#include <iostream>
#include "Tas.h"

using namespace std;


// ====================
//  TAS ET TRI PAR TAS
// ====================

void afficher(int n, int* T)
{
  // A compléter
	for (int i = 0; i < n; i++){
		printf("%i ", T[i]);
	}
} 

bool estTasMax(int n, int* T)
{
	bool estMax = true;
	for (int i = 0; i < n; i++){
		if (!((2 * i + 1) >= n || (2 * i + 2) >= n )){
			if (T[i] < T[2 * i + 1] || T[i] < T[2 * i + 2]){
				estMax = false;
			}
		}
	}
  return estMax; // A modifier...
}

bool estTasMin(int n, int* T)
{
	bool estMin = true;
	for (int i = 0; i < n; i++){
		if ((2 * i + 1) < n) {
			if (T[i] > T[2 * i + 1]){
				estMin = false;
			}
			else{
				if ((2 * i + 2) < n ){
					if (T[i] > T[2 * i + 2]){
						estMin = false;
					}
				}
			}
		}
		
	}
  return estMin; // A modifier...
}

void tableauManuel(int n, int* T)
{
  // A compléter
	int nombre;
	for (int i = 0; i < n; i++){
		std::cin >> nombre;
		T[i] = nombre;
	}
}

void tableauAleatoire(int n, int* T, int m, int M)
{
  // A compléter
	srand(time(NULL));
	for (int i = 0; i < n; i++){
		T[i] = rand()%(M - m + 1) + m;
	}
}

void entasser(int n, int* T, int i)
{
  // A compléter
	int ech;
	int m = i;
	int g = 2 * i + 1;
	int d = 2 * i + 2;
	if (g < n and T[g] > T[m]){
		m = g;
	}
	if (d < n and T[d] > T[m]){
		m = d;
	}
	if (m != i){
		ech = T[i];
		T[i] = T[m];
		T[m] = ech;
		entasser(n, T, m);
	}
}

void tas(int n, int* T)
{
  // A compléter
	while (!estTasMax(n, T)){
		for (int i = 0; i < n; i++){
			if (2 * i - 1 < n || 2 * i + 2 < n){
				entasser(n, T, i);
			}
		}
	}
}

int* trier(int n, int* T)
{
  	int* Ttrie = new int[n];
  	int x = 0;
  	int z = 0;
  	int ech;
  	for (int i = 0; i < n; i++){
  		entasser(n, T, i);
  	}
  	for (int i = n - 1; i >= 0; i--){
		Ttrie[i] = T[0];
		T[0] = T[i];
		entasser(i, T, 0);
  	}

  return Ttrie; // A modifier...
}

void trierSurPlace(int n, int* T)
{
  // A compléter
	int ech;
	for (int i = (n / 2) - 1; i >= 0; i--){
		entasser(n, T, i);
	}
	for (int i = n - 1; i >= 0; i--){
		ech = T[i];
		T[i] = T[0];
		T[0] = ech;
		entasser(i, T, 0);
	}
}

