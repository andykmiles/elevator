from elevator import models


def test_building_construct():
    b = models.Building(1, 100)
    assert len(b.floor_occupancy) == 1


def test_occupancy_construct():
    random_numbers = [10]
    models.random.randrange = lambda n: random_numbers.pop(0)
    b = models.Building(10, 10000)
    assert b.floor_occupancy == [10000 / 10]
