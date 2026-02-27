import csv

filename = 'obst.csv'  # your CSV file

with open(filename, newline='') as csvfile:
    reader = csv.reader(csvfile)
    # 0,0 corresponds to the top-left cell
    for y, row in enumerate(reader):
        for x, cell in enumerate(row):
            if cell.strip().lower() == 'z':
                print(f"li a2, {x}")
                print(f"li a3, {y}")
                print("call draw_at")
