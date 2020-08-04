%==================================================================%%   calc_legendre.m%%%	Markus Junghoefer	[1995]%% This will compute the associated Legendre polynomial%%          P  m (x)%             l%% m and l are integers satisfying :  0 <= m <= l, while x lies in the range-1 <= x <= 1%% x == cos(phi)		function [LPOL] = calc_legendre(l, m, x)%=================================================================% Check that input variables are correctif ((m < 0) | (m > l) | (abs(x) > 1.0))	error('Bad arguments in routine calc_legendre')endpmm = 1.0;if (m > 0)	somx2 = sqrt((1.0 - x) * (1.0 + x));	fact = 1.0;	for i = 1: m		pmm = pmm * (-1.0 * fact * somx2);		fact = fact + 2.0;	endendif (l == m)	LPOL = pmm;	return;else	pmmp1 = x * (2 * m + 1) * pmm;	if (l == (m + 1))		LPOL = pmmp1;		return;	else		for ll = (m + 2):l,			pll = (x * (2 * ll - 1) * pmmp1 - (ll + m - 1) * pmm) / (ll - m);			pmm = pmmp1;			pmmp1 = pll;		end		LPOL = pll;		return;	endendLPOL=LPOLreturn;