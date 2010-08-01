import unittest
import numpy
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

if __name__=='__main__':
    unittest.main()
