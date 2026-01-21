import logging
from pathlib import Path
from typing import List

import pandas as pd

def process_sensor_readings(file_path: str, threshold: float = 10.0) -> List[float]:
    """
    Load sensor data and double values exceeding threshold.

    Parameters
    ----------
    file_path : str
        Path to CSV file containing 'value' column.
    threshold : float
        Cutoff value for filtering.

    Returns
    -------
    List[float]
        Processed sensor readings.
    
    Raises
    ------
    FileNotFoundError
        If file does not exist.
    """
    path = Path(file_path)
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {file_path}")

    try:
        sensor_data = pd.read_csv(path)
    except pd.errors.EmptyDataError:
        logging.warning("Empty data file provided")
        return []

    # Vectorized operation instead of loop
    high_readings = sensor_data.loc[sensor_data['value'] > threshold, 'value']
    processed_values = (high_readings * 2.0).tolist()

    return processed_values

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    results = process_sensor_readings("data/sensors.csv")
    print(results)
