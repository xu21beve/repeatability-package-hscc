This directory contains code to recreate the examples from Beverly Xu, "cHyRRT and cHySST: Two Motion Planning Tools for Hybrid Dynamical Systems," in Hybrid Systems Computational & Control
  (_____), ACM (2025).
  
  It requires the Docker Engine, which can be downloaded from
  https://docs.docker.com/engine/install/
  
After Docker is installed, you must pull the Docker image using
```bash
docker pull ghcr.io/xu21beve/docker-image:latest
```

Finally, you can run the Docker image and open an interactive sh shell using 
```bash
docker run -i ghcr.io/xu21beve/docker-image
```

Within the Docker image, you will find two folders, `hybridRRT-Ccode` and `hybridSST-Ccode`. The contents within `hybridRRT-Ccode` can be used to simulate the results presented in Figures 3, 4a, and 4b.  The contents within `hybridSST-Ccode` can be used to simulate the result presented in Figure 4c. Below are instructions to generate and visualize each figure above, from the command line.

* Figure 3: 
```bash
cd hybridRRT-Ccode/build/examples
./bouncing_ball
cd ../../examples/visualize
./rosrun.bash
```

./rosrun.bash will query users in the Bash shell to:
```bash
$ Enter index (0-) of the desired x-coordinates:
$ Enter index (0-) of the desired y-coordinates:
$ (Optional) Enter index (0-) of the desired z-coordinates. If no z-coordinates are desired, press return:
```
For the x-coordinates, we will enter 4 to generate Figures 3a and 3b, or 2 to generate Figure 3c. For the y-coordinates, we will enter 0. For the z-coordinates, we will not enter anything, and only return.

* Figure 4a and 4b:
```bash
cd hybridRRT-Ccode/build/examples
./multicopter
cd ../../examples/visualize
./rosrun.bash
```

./rosrun.bash will query users in the Bash shell to:
```bash
$ Enter index (0-) of the desired x-coordinates:
$ Enter index (0-) of the desired y-coordinates:
$ (Optional) Enter index (0-) of the desired z-coordinates. If no z-coordinates are desired, press return:
```
For the x-coordinates, we will enter 0. For the y-coordinates, we will enter 1. For the z-coordinates, we will not enter anything, and only return.


* Figure 4c:
```bash
cd hybridSST-Ccode/build/examples
./multicopter
cd ../../examples/visualize
./rosrun.bash
```
./rosrun.bash will query users in the Bash shell to:
```bash
$ Enter index (0-) of the desired x-coordinates:
$ Enter index (0-) of the desired y-coordinates:
$ (Optional) Enter index (0-) of the desired z-coordinates. If no z-coordinates are desired, press return:
```
For the x-coordinates, we will enter 0. For the y-coordinates, we will enter 1. For the z-coordinates, we will not enter anything, and only return.

Beverly Xu
November 2024#
