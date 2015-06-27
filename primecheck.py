def primecheck(p):
    def primecalc(d):
        while p%d != 0:
            d += 1
        if p == d:
            return bool(True)
        else:
            if p%d == 0:
                return bool(False)
    d = 2
    if p == 1:
        return bool(False)
    elif p == 2:
        return bool(True)
    elif p%d == 0:
        return bool(False)
    else:
        d += 1
        return primecalc(d)
