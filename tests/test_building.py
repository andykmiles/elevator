import elevator.models


def test_new_building():
    building = elevator.models.Build(floors=10)
    assert building.floors == 10
