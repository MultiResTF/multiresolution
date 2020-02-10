The following files accompany the paper https://arxiv.org/abs/1908.11413

The examples use the following datafiles which must be downloaded and placed
into the folder indicated in the code. Moreover, the TT-toolbox (https://github.com/oseledets/TT-Toolbox) and tensor toolbox (http://www.tensortoolbox.org/) need to be installed to run the examples using the tensor-train or the canonical decomposition, respectively.

## Data files:
[3] Daniel Schwen, File:NYC wideangle south from Top of the Rock.jpg, 2005, Distributed under a Creative Commons Attribution-Share Alike 2.5 Generic license. Available at https://commons.wikimedia.org/wiki/File:NYC_wideangle_south_from_Top_of_the_Rock.jpg, accessed Jan. 29, 2019.

[13] NASA Goddard Space Flight Center, Visible Earth, 2002, Available at https://visibleearth.nasa.gov/view.php?id=57723, accessed Jan. 29, 2019.

[14] NASA Jet Propulsion Laboratory, AVIRIS Data, Data available at https://aviris.jpl.nasa.gov/data/free_data.html, accessed Jan. 17, 2019.

[16] Oregon State University, SAMSON dataset, Data available at https://opticks.org/display/opticks/Sample+Data, accessed Jan. 17, 2019.

[23] US Army Corps of Engineers, HyperCube, Data available at https://www.erdc.usace.army.mil/Media/Fact-Sheets/Fact-Sheet-Article-View/Article/610433/hypercube/, accessed Jan.
17, 2019.

[12] Liyuan Li, Weimin Huang, Irene Yu-Hua Gu, and Qi Tian, Statistical modeling of complex
backgrounds for foreground object detection, IEEE Trans. Image Process. 13 (2004), no. 11,
1459–1472. Data accessible at http://vis-www.cs.umass.edu/~narayana/castanza/I2Rdataset/


## Files:
### Example Files:

each of these run a different example

ex_2d.m

ex_aviris.m

ex_bootstrap.m

ex_mall.m

ex_samson.m

ex_urban.m

ex_watersurface.m

check_recovery.m - confirms local convergence guarantees

### Main files:
iterate_multiscale_TT.m/iterate_multiscale_candecomp_f.m - runs the alternating decomposition algorithm into

the multiresolution TT-format/canonical format

one_iteration_TT.m/one_iteration_candecomp_f.m - finds the optimum scale tensor at a given scale.

### Remaining files:
helper files
