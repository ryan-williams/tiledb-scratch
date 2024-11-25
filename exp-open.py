import sys
import tiledbsoma
print(tiledbsoma.Experiment.open(sys.argv[1]))
