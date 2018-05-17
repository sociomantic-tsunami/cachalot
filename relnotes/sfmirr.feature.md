### Add extra backup mirrors for D-APT

Extra mirrors for the D-APT repositories are added to the apt sources list,
for extra remedy when the master is down. A very dumb heuristic is implemented:
If `apt update` fails, we try a different mirror (2 times) and then we give up.
If `apt update` failed for another reason, this means it will be tried 2 more
times uselessly.
