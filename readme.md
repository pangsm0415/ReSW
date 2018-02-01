What is it?
===========================================================================

This repository contains an MATLAB implementation of the following paper:
 
Shanmin Pang, Jihua Zhu, Jiaxing Wang, Vicente Ordonez and Jianru Xue,
Discriminative CNN image representations via replication equation for object retrieval, submitted to Pattern Recognition. 

This code implements
a) ReSW image representation
b) Image/object retrieval based on ReSW on public datasets: Oxford5k, Paris6k and Holidays.

The code is written by: Jin Ma (m799133891@stu.xjtu.edu.cn); Shanmin Pang (pangsm@xjtu.edu.cn).
If you have any question, please contact Jin Ma or Shanmin Pang.

Setup
===========================================================================
Dependencies
1.	MatConvNet v1.0-beta18 or above (http://www.vlfeat.org/matconvnet/).
2.	Optional but highly recommended: Yael_matlab (http://yael.gforge.inria.fr/index.html). All affiliated functions used in this program have already been contained in ¡®utils¡¯ folder.
3.	For siaMAC features, see this page: siaMAC(http://cmp.felk.cvut.cz/cnnimageretrieval/)
4.  For netvlad features, see this page: netvlad (https://github.com/Relja/netvlad)

Models
Three models used in our experiment are as follows:
1. Vgg16: imagenet-matconvnet-vgg-verydeep-16 (http://www.vlfeat.org/matconvnet/models/imagenet-matconvnet-vgg-verydeep-16.mat)
2. SiaMAC: retrievalSfM120k-siamac-vgg (http://cmp.felk.cvut.cz/cnnimageretrieval/networks/retrieval-SfM-120k/retrievalSfM120k-gem-vgg.mat)
3. Netvlad: The best model of netvlad(VGG-16+NetVLAD+whitening, trained on Pittsburgh) http://www.di.ens.fr/willow/research/netvlad/data/models/vd16_pitts30k_conv5_3_vlad_preL2_intra_white.mat

Dataset
1.	Oxford5k: http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/
2.	Paris6k: http://www.robots.ox.ac.uk/~vgg/data/parisbuildings/
3.	INRIA Holidays: https://lear.inrialpes.fr/~jegou/data.php#holidays
4.	Flickr 100k: http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/flickr100k.html

Execution
===========================================================================
1.	Extract features: See 'feature_extract.m'/'feature_query.m'/'feature_100k.m' file, please change the pathname to the correct folder where you store images. 
2.	'Test.m' file shows details of our experiment, including computation of final representation and image retrieval process.



