import unittest
import numpy
import itertools
import sets_solver

class TestSets(unittest.TestCase):
    def test_is_set(self):
        cards=numpy.array([[1,1,1,2,0],
                           [0,1,2,2,2],
                           [0,1,2,2,2],
                           [0,1,2,2,2]])
        self.assertTrue(sets_solver.is_set(cards, [0,1,2]))
        self.assertFalse(sets_solver.is_set(cards, [0,1,3]))
        self.assertTrue(sets_solver.is_set(cards, [2,3,4]))

    def test_find_sets2(self):
        for i in range(100):
            cards = sets_solver.random_cards()
            sets = sets_solver.find_sets(cards)
            sets2 = sets_solver.find_sets2(cards)
            self.assertEqual(sets, sets2)

    def test_find_sets3(self):
        for i in range(100):
            cards = sets_solver.random_cards()
            sets = sets_solver.find_sets(cards)
            sets3 = sets_solver.find_sets3(cards)
            for s in sets3:
                s = list(s)
                s.sort()
                self.assertTrue(tuple(s) in sets)

    def test_one_game(self):
        all_cards = set()
        old_nsets = -1
        game = sets_solver.one_game()
        for cards in game:
            ncards = cards.shape[1]

            assert ncards % 3 == 0
            
            if ncards < 12:
                # this is only possible at the end of the deck
                left = len(list(game))
                assert left < 3
                
            if cards.shape[1] == 15:
                assert old_nsets == 0
                
            old_nsets = len(sets_solver.find_sets2(cards))
            cards_list = [tuple(c) for c in cards.T]
            all_cards = all_cards.union(set(cards_list))
            
        # all cards must have been played
        cards = [card for card in itertools.product(range(3), repeat=4)]
        assert all_cards == set(cards)

if __name__=='__main__':
    unittest.main()
