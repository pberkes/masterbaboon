import numpy
import itertools

ndims = 4
nfeatures = 3
ncards = 12

# functions to manage cards
# -------------------------

def random_deck():
    # initialize cards deck
    cards = numpy.array([card for card in itertools.product(range(nfeatures),
                                                            repeat=ndims)]).T
    n = cards.shape[1]
    # shuffle
    return cards[:, numpy.random.permutation(n)]

def random_cards():
    return random_deck()[:, :ncards]

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

    subset = cards[:, indices]
    for dim in range(ndims):
        # cards must be all the same or all different for all dimensions
        if not same(subset[dim, :]) and not different(subset[dim, :]):
            return False
    return True

# solvers
# -------

def find_sets(cards):
    """Brute-force Sets solver."""
    return [indices
            for indices in itertools.combinations(range(cards.shape[1]), 3)
            if is_set(cards, indices)]

def find_sets2(cards):
    ndims, ncards = cards.shape
    all_features = set([0, 1, 2])

    # solutions contain the indices of the cards forming sets
    solutions = []
    # iterate over all pairs
    for idx1, idx2 in itertools.combinations(range(ncards - 1), 2):
        c1, c2 = cards[:, idx1], cards[:, idx2]

        # compute card that would complete the set
        missing = numpy.empty((ndims,), dtype='i')
        for d in range(ndims):
            if c1[d] == c2[d]:
                # same feature on this dimension -> missing card also has same
                missing[d] = c1[d]
            else:
                # different features -> find third missing feature
                missing[d] = list(all_features - set([c1[d], c2[d]]))[0]

        # look for missing card in the cards array
        where_idx = numpy.flatnonzero(numpy.all(cards[:, idx2 + 1:].T == missing,
                                                axis=1))
        # append to solutions if found
        if len(where_idx) > 0:
            solutions.append((idx1, idx2, where_idx[0] + idx2 + 1))

    return solutions

def find_sets3(cards, indices=None):
    nd, n = cards.shape
    c0 = cards[0, :]
    if indices is None:
        indices = numpy.arange(n)

    groups = [(c0 == f).nonzero()[0] for f in range(nfeatures)]

    # equals
    solequal = []
    for g in groups:
        if len(g) < 3: continue
        solequal += find_sets3(cards[1:nd, g], indices[g])
    # different
    soldiff = [(indices[i0], indices[i1], indices[i2])
               for i0 in groups[0] for i1 in groups[1] for i2 in groups[2]
               if is_set(cards, (i0, i1, i2))]
    return solequal + soldiff

def one_game():
    deck = random_deck()
    pos = ncards
    cards = deck[:,:pos]
    yield cards
    
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

        yield cards
