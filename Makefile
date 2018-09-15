rho-kompiled: rho.k
	kompile $^ --backend java
t:
	krun tests/test.rho
s: rho.k
	kompile $^ --backend java
	krun tests/test.rho
