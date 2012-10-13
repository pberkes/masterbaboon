import numpy as np

# Parameter: probability of sticking with one language
prob_stick = 0.9


# Read data from file
# comments is set to a random character other than the default, #, to avoid
# `loadtxt` getting confused by C#
data = np.loadtxt('x_for_y_devs.csv', skiprows=1, comments='^', dtype='S')

n_languages = data.shape[0]
languages = data[:,0]
hits = data[:,1:].astype('f8')

# Pre-process data.
# By the end of pre-processing, hits[i,j] will be the probability of transitioning
# from language j to language i

# find dangling nodes, and replace the column by a uniform probability
cols_one_nonzero_indices = np.where((hits>0).sum(axis=0)==1)[0]
hits[:, cols_one_nonzero_indices] = 1

# remove the X->X entries, which are just Google noise
hits[range(n_languages), range(n_languages)] = 0

# normalize all columns to get a stochastic matrix
def normalize_columns(x):
    return x / x.sum(axis=0)

hits = normalize_columns(hits)

# set probability of sticking to same language to for the final google matrix
google = (1.0 - prob_stick) * hits + prob_stick * np.eye(n_languages)


# compute stationary solution using the power method
v = np.ones((n_languages,)) / n_languages
for i in range(1000):
    v = np.dot(google, v)


# print result, sorted by the probability of developers using a language!
sort_idx = v.argsort()
line_template = '{lang:>15}   {prob:.6f}'
print '{lang:>15}   {prob}'.format(lang='Language', prob='P=')
for idx in sort_idx[::-1]:
    print line_template.format(lang=languages[idx], prob=v[idx])

