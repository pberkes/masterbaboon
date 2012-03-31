import mechanize
import re
import time
import itertools

HEADERS = ('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071613 Fedora/3.0.1-1.fc9 Firefox/3.0.1')

def google_search(query):
    """ Collect number of Google hits for the query. """
    br = mechanize.Browser()
    br.addheaders = [HEADERS]
    br.set_handle_robots(False)
    
    br.open("http://www.google.com")
    br.select_form(nr=0)
    br.form['q'] = query
    br.submit()

    response = br.response().read()
    match = re.search('resultStats.*?results', response)

    if match is None:
        n = 0
    else:
        print '  ', match.group()
        try:
            snippet = match.group()
            nr_str = re.search('[0-9][0-9\,]*', snippet).group()
            n = int(nr_str.replace(',', ''))
        except ValueError:
            # we end up here when the number of responses is zero,
            # but we match a result like "About Perl ..." and then
            # "... more results"
            n = 0

    print '  -> ', n

    time.sleep(2.0)
    return n


languages = ['BASIC', 'C++', 'C#', 'Cobol', 'Java', 'Javascript', 'LISP',
             'Python', 'Perl', 'Ruby']
sentences = [
    '"{} for {} developers"',
    '"{} for {} programmers"'
    ]


# collect results
results = {}
for l1, l2 in itertools.product(languages, languages):
    print '\n{} for {} developers'.format(l1, l2)
    popularity = 0
    for s in sentences:
        query = s.format(l1, l2)
        popularity += google_search(query)
    results[l1, l2] = popularity
    


# print out table
NCHARS = 13
title = 'X for Y devs'.rjust(NCHARS)
for l1 in languages:
    title = title + l1.rjust(NCHARS)
print title

for l1 in languages:
    line = l1.rjust(NCHARS)
    for l2 in languages:
        n = results[l1, l2] / (results[l1, l1] + 1.0)
        line = line + str(int(n+0.5)).rjust(NCHARS)
    print line
