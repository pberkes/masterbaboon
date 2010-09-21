import pylab
import scipy
from sets_solver import find_sets2, one_game, random_cards

# distribution of number of sets in random draws with 15 cards
nsolutions_indep = []
for i in range(150000):
    cards = random_cards(ncards=15)
    nsolutions_indep.append(len(find_sets2(cards)))

pylab.gcf().set_size_inches(11, 6.4)
freq, bins, _ = pylab.hist(nsolutions_indep, bins=range(-1,14), normed=1, hold=0)
pylab.draw()
print 'Prob of 0 sets for the independent case', freq[1], 'or 1 in', 1./freq[1]
#('Prob of 0 sets for the independent case', 0.00038668213395202477, 'or 1 in', 2586.1034482758619)

nsolutions = []
n15 = []
for i in range(5000):
    count15 = 0
    for cards in one_game():
        if cards.shape[1] > 12:
            count15 += 1
            nsolutions.append(len(find_sets2(cards)))
    n15.append(count15)

pylab.gcf().set_size_inches(11, 6.4)
freq, bins, _ = pylab.hist(nsolutions, bins=range(-1,14), normed=1, hold=0)
pylab.draw()
print 'Prob of 0 sets for 15 cards', freq[1], 'or 1 in', 1./freq[1]
# ('Prob of 0 sets for 15 cards', 0.010681255698840693, 'or 1 in', 93.621951219512198)

freq, bins, _ = pylab.hist(n15, bins=range(-1,14), normed=1, hold=0)


print 'number of triplets in 12 cards', scipy.comb(12, 3)
print 'number of new triplets when adding 3 cards', 3 * scipy.comb(12, 2) + scipy.comb(3, 2) * 12 + 1

# save
import cPickle
f = open('more_set_results.pickle', 'w')
cPickle.dump((nsolutions_indep, nsolutions, n15), f)
f.close()
