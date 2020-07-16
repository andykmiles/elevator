import pysnooper
import random


class Building:
    def __init__(self, floors, sqft_per_floor):
        self.floors = floors
        self.sqft_per_floor = sqft_per_floor
        self.floor_occupancy = []
        for _ in range(floors):
            self.floor_occupancy.append(
                random.randrange(
                    round(sqft_per_floor / 120, 0), round(sqft_per_floor / 80, 0), 1
                )
            )

