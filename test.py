import sys
from tiledbsoma import Experiment

exp_uri = sys.argv[1]
with Experiment.open(exp_uri, 'r') as exp:
    print(f"Measurements: {', '.join(exp.ms.keys())}")
