from elevator.models import Building
import elevator.ui.user_data


def main():
    print("Elevator simulation")
    print("Calculate elevator requirements with a simple set of parameters\n")
    simulation_values = elevator.ui.user_data.collect_parameters()
    print(simulation_values)
    print("new line")


if __name__ == "__main__":
    main()
