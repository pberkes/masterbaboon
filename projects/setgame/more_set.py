import pylab
import scipy
from sets_solver import find_sets2, one_game, random_cards

# distribution of number of sets in random draws with 15 cards
nsolutions_indep = []
for i in range(150000):
    cards = random_cards(ncards=15)
    nsolutions_indep.append(len(find_sets2(cards)))

freq, bins, _ = pylab.hist(nsolutions_indep, bins=range(-1,14), normed=1, hold=0)
print 'Prob of 0 sets for the independent case', freq[1], 'or 1 in', 1./freq[1]

nsolutions = []
n15 = []
for i in range(5000):
    count15 = 0
    for cards in one_game():
        if cards.shape[1] > 12:
            count15 += 1
            nsolutions.append(len(find_sets2(cards)))
    n15.append(count15)

freq, bins, _ = pylab.hist(nsolutions, bins=range(-1,14), normed=1, hold=0)
print 'Prob of 0 sets for 15 cards', freq[1], 'or 1 in', 1./freq[1]
# ('Prob of 0 sets for 15 cards', 0.011852615305333677, 'or 1 in', 84.369565217391298)

print 'number of triplets in 12 cards', scipy.comb(12, 3)
print 'number of new triplets when adding 3 cards', 3 * scipy.comb(12, 2) + scipy.comb(3, 2) * 12 + 1
