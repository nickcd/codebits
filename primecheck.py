def primecheck(p):
    d = 2
    if p%d == 0:
        print "Number is not a prime."
    elif p == d:
        print "Number is a prime."
    else:
        d += 1
        def primecheck(d):
            while p%d != 0:
                d += 1
            if p == d:
                print "Number is a prime."
            else:
                if p%d == 0:
                    print "Number is not a prime."
        primecalc(d)
