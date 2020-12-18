# MorphoHub_paper： <Petabyte-Scale Multi-Morphometry of Single Neurons for Whole Brains>
All the morphoHub related tools and code will be updated here.
Designed by Shengdian Jiang, 2020-02-12
Email: allencenter@seu.edu.cn

MorphoHub have the following components:
1. Brain_conversion:
    -For converting 2D formatted images into TeraFly format.
2. Level-0_generation:
    -For the generation of TeraFly format Level-0 data.
3. Dendrite_generation:
    -For parallel generation of dendritic data
    -app2 parameters: (highlight the important parameters with *****)
        #channel = 0
        *****#bkg_thresh = (10 15 20 25 30 35)*****
        #length_thresh = 5
        #SR_ratio = 0.333333
        *****#is_gsdt = 0*****
        *****#is_gap = 1*****
        #cnn_type = 2
        *****#b_256cube = 0*****
        *****#b_radiusFrom2D = 0*****
        *****#b_resample = 1*****
        #b_intensity = 0
        #b_brightfiled = 0
4. Bouton_generation:(Level-3)
    -For the generation of bouton.
5. MorphoHub_datamanagement:
    -L1 and L2 generation and management
    -Visualization-based analysis
    -user management
    -Level control

