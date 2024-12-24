This directory contains code to recreate the examples from Beverly Xu, "cHyRRT and
cHySST: Two Motion Planning Tools for Hybrid Dynamical Systems," in Hybrid Systems
Computational & Control, ACM (2025).

The virtual machine was developed on an HP ENVY x360 Convertible 15-es2xxx, a x64-
based PC with a 12th Gen Intel(R) Core (TM) i7-1260P, 2100 Mhz Processor with 12
Cores. The virtual machine was allocated 1 CPU core and 4 GB (4096 MB) of memory and
has a Ubuntu (64-bit) guest operating system. Link to .ova file: http://tiny.cc/c6owzz
  
It requires the Oracle VirtualBox application, which can be downloaded from
https://www.virtualbox.org/
Import the OVA File into VirtualBox
1. Launch VirtualBox on your computer.
1. Click on File in the top menu and select Import Appliance.
1. In the dialog box, click the Choose button and navigate to the location of the
OVA file `hyrrt-hysst-image.ova`.
1. Select the OVA file and click Open. Enter `cHyRRTcHySST` when prompted for a password to log in to `beverlyxu`.
Within the virtual machine, at `~/Documents/Github/` you will find two folders,
`hybridRRT-Ccode` and `hybridSST-Ccode`. The contents within `hybridRRT-Ccode` can be
used to simulate the results presented in Figures 4, 5b, and 5c. The contents within
`hybridSST-Ccode` can be used to simulate the result presented in Figure 5a and the analysis presented in Figure 6. Below are instructions to generate and visualize each figure above, from the command line.

## Testing/Run examples
Start RViz2 by opening a new Terminal window and entering  `rviz2`. Next, open another Terminal window for the following instructions. 
```bash
cd ~/Documents/Github
```
Next, you will enter the Bash commands corresponding to  the figure you would like to generate. Note that the following outputs will appear in the Terminal window when running these examples, and are expected behaviors:
* `solution status: Approximate solution` indicates that a solution, where the final state is within the specified tolerance of the goal state set, has been found. In accordance with OMPL style, we refer to such a valid solution outside of the goal state set as an “approximate solution,” while a valid solution within the goal set is an “exact solution.”
* `Warning: State validity checker not set! No collision checking is performed at line 63 in ./src/ompl/base/src/SpaceInformation.cpp`. We use our own collision checker (in order to offer users the ability to check for collisions involving inputs/hybrid time), so we don’t use the OMPL `Planner` class's validity checkers, and therefore this warning can be safely ignored.

Now, to generate each figure:
* Figure 4a: 
```bash
cd hybridRRT-Ccode/examples/visualize
./generate4a.bash
```
* Figure 4b: 
```bash
cd hybridRRT-Ccode/examples/visualize
./generate4b.bash
```
* Figure 4c: 
```bash
cd hybridRRT-Ccode/examples/visualize
./generate4c.bash
```
* Figure 5a: 
```bash
cd hybridSST-Ccode/examples/visualize
./generate5a.bash
```
* Figure 5b: 
```bash
cd hybridRRT-Ccode/examples/visualize
./generate5b.bash
```
* Figure 5c: 
```bash
cd hybridRRT-Ccode/examples/visualize
./generate5c.bash
```
* Figure 6: 
```bash
cd hybridSST-Ccode/examples
./figure6.bash
```
Bash will then prompt the user to enter a desired batch size (between 1 and 7) and a desired number of iterations (any integer greater than or equal to zero).  

## Instructions for Reuse
Create a file, `example_name.cpp` in `${rootDirectory}/examples/`. Replace `example_name` with the desired name of your file. Next, within your file, enter the following: 
```C++
#include "../HySST.h"	// or HyRRT.h if using cHyRRT
#include "ompl/base/Planner.h"
#include "ompl/base/spaces/RealVectorStateSpace.h"
#include "ompl/geometric/PathGeometric.h"
#include <fstream> // For file I/O
#include <iomanip> // For formatting output
```
Then, you will need to instantiate all necessary functions and attributes to initialize the motion planner, along with any optional functions and attributes as needed. See `HySST.h` for full method signatures and either `HySST.h` or the `README.md` in either tool directory for full attribute requirements. Below is a list of all mandatory functions and attributes. 
* continuousSimulator_ 
* discreteSimulator_
* flowSet_
* jumpSet_
* unsafeSet_
* tM_
* maxJumpInputValue_
* minJumpInputValue_
* maxFlowInputValue_
* minFlowInputValue_
* flowStepDuration_
* pruningRadius_ (only for cHySST)
* selectionRadius_ (only for cHySST)

After you have instantiated all necessary methods and variables, enter the following, customizing as instructed by the in-line comments:
```C++
int main()
{
ompl::base::RealVectorStateSpace *statespace = new ompl::base::RealVectorStateSpace(0);
    statespace->addDimension(-1, 1); // Add however many dimensions there states in your state space


    ompl::base::StateSpacePtr space(statespace);


    // Construct a space information instance for this state space
    ompl::base::SpaceInformationPtr si(new ompl::base::SpaceInformation(space));


    si->setup();


    // Set start state. Here, we set it to be (1, 2)
    ompl::base::ScopedState<> start(space);
    start->as<ompl::base::RealVectorStateSpace::StateType>()->values[0] = 1;
    start->as<ompl::base::RealVectorStateSpace::StateType>()->values[1] = 2;


    // Set goal state. Here, we set it to be (5, 4)
    ompl::base::ScopedState<> goal(space);
    goal->as<ompl::base::RealVectorStateSpace::StateType>()->values[0] = 5;
    goal->as<ompl::base::RealVectorStateSpace::StateType>()->values[1] = 4;


    // Create a problem instance
    ompl::base::ProblemDefinitionPtr pdef(new ompl::base::ProblemDefinition(si));


    // Set the start and goal states
    pdef->setStartAndGoalStates(start, goal);


    ompl::geometric::HySST cHySST(si);	// to use HyRRT: ompl::geometric::HyRRT cHyRRT(si);


    // Set parameters
    cHySST.setProblemDefinition(pdef);
    cHySST.setup();
```
Now, you will assign your previously instantiated methods and variables to the tool, using the corresponding “set” function. For example, we can set `tM_` with the following code snippet:
```
    cHySST.setTm(tM_);
```
In general, the setter methods can be referenced as `cHySST.set___();`, where the name of the attribute (without the rear underscore) will replace the underline in `cHySST.set___();`. See `HySST.h` for full setter method signatures. 

To close out our example file, we will execute the tool by invoking the `solve` method as follows:

```C++
    // attempt to solve the planning problem within 10 seconds. Can replace with any other termination condition
    ompl::base::PlannerStatus solved = cHySST.solve(ompl::base::timedPlannerTerminationCondition(10));
    std::cout << "solution status: " << solved << std::endl;


    // print path to RViz2 data file
    std::ofstream outFile("../../examples/visualize/src/points.txt");	// address relative to the location of this executable, ${rootDirectory}/build/examples/
    pdef->getSolutionPath()->as<ompl::geometric::PathGeometric>()->printAsMatrix(outFile); 	// output trajectory into output file for visualization
}
```

Now, if using cHyRRT, add the following code snippet to line 17 of ~/Documents/Github/hybridRRT-Ccode/examples/CMakeLists.txt:
```CMake
# Add executable for user example
add_executable(example_name example_name.cpp)
target_link_libraries(example_name HyRRT ${OMPL_LIBRARIES})
```

If using cHySST, add the following lines to line 17 of ~/Documents/Github/hybridSST-Ccode/examples/CMakeLists.txt:

```CMake
# Add executable for user example
add_executable(example_name example_name.cpp)
target_link_libraries(example_name HySST ${OMPL_LIBRARIES})
```
Finally, we will build the example. In a new Terminal window, run the following (replace all instances of `hybridSST-Ccode` with `hybridRRT-Ccode` if using cHyRRT):
```Bash
cd  ~/Documents/Github/hybridSST-Ccode/build/examples
make
./example_name
cd  ~/Documents/Github/hybridSST-Ccode/examples/visualize
./rosrun.bash
```


Beverly Xu
November 2024
