#define HEAPIFY(L, Var, n, i) if(UNLINT(TRUE)) { \
var/largest = i; \
var/j; \
do { \
    j = largest; \
    var/l = 2 * largest; \
    var/r = 2 * largest + 1; \
    if(l <= n) { \
        if(L[l]:Var > L[largest]:Var) { \
            largest = l; \
        } \
        if((r <= n) && (L[r]:Var > L[largest]:Var)) { \
            largest = r; \
        } \
    } \
    L.Swap(j, largest); \
} while(largest != j);}

#define SORT(L, Var) if(UNLINT(TRUE)) { \
var/N = L.len; \
for(var/k in round(N / 2) to 1 step -1) { \
    HEAPIFY(L, Var, N, k); \
} \
for(var/k in N to 2 step -1) { \
    L.Swap(1, k); \
    HEAPIFY(L, Var, k - 1, 1); \
}}
