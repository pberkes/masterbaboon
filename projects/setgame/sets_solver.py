import numpy
import itertools
ndims = 4
nfeatures = 3
ncards = 12
# functions to manage cards
# -------------------------
def random_deck():
    # initialize cards deck
    cards = numpy.array([card for card in itertools.product(range(nfeatures), repeat=ndims)]).T
    n = cards.shape[1]
    # shuffle
    return cards[:,numpy.random.permutation(n)]
def random_cards():
    return random_deck()[:,:ncards]
# solution checker
# ----------------
def same(x):
    """Returns True if all elements are the same."""
    return numpy.all(x == x[0])
def different(x):
    """Returns True if all elements are different."""
    return len(numpy.unique(x)) == len(x)
def is_set(cards, indices):
    """Checks that the cards indexed by 'indices' form a valid set."""
    ndims = cards.shape[0]
    
    #if len(indices) != ndims-1:
    #    return False
    
    subset = cards[:,indices]
    for dim in range(ndims):
        # cards must be all the same or all different for all dimensions
        if not same(subset[dim,:]) and not different(subset[dim,:]):
            return False
    return True
# solvers
# -------
def find_sets(cards):
    """Brute-force Sets solver."""
    return [indices for indices in itertools.combinations(range(cards.shape[1]), 3)
            if is_set(cards, indices)]
def find_sets2(cards):
    ndims, ncards = cards.shape
    solutions = []
    for idx1, idx2 in itertools.combinations(range(ncards-1), 2):
        c1, c2 = cards[:,idx1], cards[:,idx2]
        candidates = cards[:,idx2+1:]
        indices = numpy.arange(idx2+1,ncards)
        for d in range(ndims):
            cd = candidates[d,:]
            if c1[d]==c2[d]:
                equals = (cd==c1[d])
                candidates = candidates[:,equals]
                indices = indices[equals]
            else:
                differents = numpy.logical_and(cd!=c1[d], cd!=c2[d])
                candidates = candidates[:,differents]
                indices = indices[differents]
            if candidates.shape[1]==0:
                break
        else:
            solutions.extend([(idx1,idx2,i) for i in indices])
    return solutions
def find_sets3(cards, indices=None):
    nd, n = cards.shape
    c0 = cards[0,:]
    if indices is None:
        indices = numpy.arange(n)
    
    groups = [(c0==f).nonzero()[0] for f in range(nfeatures)]
    
    # equals
    solequal = []
    for g in groups:
        if len(g)<3: continue
        #print nd,g,cards[1:nd,g]
        #if nd<=3: print cards[:,g]        #if nd>1:
        solequal += find_sets3(cards[1:nd,g],indices[g])
        #else:
        #    print 'aaaaaaaaaaaaaa',nd
        #    solequal += [comb for comb in itertools.combinations(indices[g], 3)]
    # different
    soldiff = [(indices[i0],indices[i1],indices[i2])
               for i0 in groups[0] for i1 in groups[1] for i2 in groups[2]
               if is_set(cards, (i0, i1, i2))]
    #soldiff = [(indices[candidates[0]], indices[candidates[1]], indices[candidates[2]])
    #          for candidates in itertools.product(*groups)
    #          if is_set(cards, candidates)]
    return solequal + soldiff
        
#nsolutions = [len(find_sets2(random_cards())) for i in range(10000)]
cards = random_cards()
print find_sets(cards)
print find_sets2(cards)
print find_sets3(cards)
def onegame():
    nsolutions = []
    deck = random_deck()
    pos = ncards
    cards = deck[:,:pos]
    while True:
        # find all sets
        sets = find_sets2(cards)
        nsets = len(sets)
        if nsets>0:
            # choose a random set
            chosen = sets[numpy.random.randint(len(sets))]
            # remove cards from chosen set
            idx = [i for i in range(cards.shape[1]) if i not in chosen]
            cards = cards[:,idx]
            # add new cards
            if cards.shape[1]<12:
                nadd = 12-cards.shape[1]
                cards = numpy.concatenate((cards, deck[:,pos:pos+nadd]), axis=1)
                pos += nadd
        else:
            #print 'no sets found', pos
            if pos>=deck.shape[1]:
                break # game is over
            # add additional cards
            cards = numpy.concatenate((cards, deck[:,pos:pos+3]), axis=1)
            pos += 3
        nsolutions.append(nsets)
    return nsolutions
#nsolutions = []
#for i in range(1000):
#    nsolutions += onegame()
