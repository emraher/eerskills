import pandas as pd

def process(data):
    # Process the data
    try:
        df = pd.read_csv(data)
        res = []
        for index, row in df.iterrows():
            if row['val'] > 10:
                res.append(row['val'] * 2)
        return res
    except:
        print("Error")

# Main execution
if __name__ == "__main__":
    file = "input.csv"
    out = process(file)
    print(out)
