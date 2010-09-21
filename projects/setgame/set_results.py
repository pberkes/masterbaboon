import pylab
from sets_solver import find_sets2, one_game, random_cards


# distribution of number of sets in random draws
nsolutions_indep = []
for i in range(10000):
    cards = random_cards()
    nsolutions_indep.append(len(find_sets2(cards)))
freq, bins, _ = pylab.hist(nsolutions_indep, bins=range(-1,14), normed=1, hold=0)
print 'Prob of 0 sets for the independent case', freq[1], 'or 1 in', 1./freq[1]

# distribution of number of sets during a game
nsolutions = []
for i in range(5000):
    for cards in one_game():
        nsolutions.append(len(find_sets2(cards)))

freq, bins, _ = pylab.hist(nsolutions, bins=range(-1,14), normed=1, hold=0)
print 'Prob of 0 sets for the game case', freq[1], 'or 1 in', 1./freq[1]

# TODO: are there correlations within games?
