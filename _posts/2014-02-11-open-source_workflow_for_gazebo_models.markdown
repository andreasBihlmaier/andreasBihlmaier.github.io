---
layout: default
title: Open-Source Workflow to Create Geometrically and Visually Accurate Gazebo Models
---

A robot simulation can only be as useful and accurate as the utilized models.
This post is only concerned with geometric models, future ones will also concern kinematics.
There are many options available for each part of a worflow: CAD modeling, mesh export, mesh format conversion and mesh simplification.
In what follows I\'ll describe _one_ workflow completly based on open-source components that works for me, i.e. is fast, extensive and reliable.

The targeted simulator is [Gazebo](http://gazebosim.org/) (and the models also work as [Markers](http://wiki.ros.org/rviz/DisplayTypes/Marker) in [rviz](http://wiki.ros.org/rviz)).
One important aspect of mesh models that is often neglected are [per-vertex normals](http://en.wikipedia.org/wiki/Vertex_normal) (compared to mere per-face normals).
This is very unfortunate if the simulated models should be visually accurate / realistically looking - which is important if you also want to test vision algorithms with [simulated sensors](http://gazebosim.org/wiki/Tutorials/1.9/ROS_Motor_and_Sensor_Plugins#Camera).
Especially for rounded objects, [Phong shading](http://en.wikipedia.org/wiki/Phong_shading) based on vertex normals of the real ([CSG](http://en.wikipedia.org/wiki/Constructive_solid_geometry)) CAD surfaces, will look much more realistic than without.


CAD modeling
------------
We use [FreeCAD](http://freecadweb.org/) as CAD program.
It is open-source, based on a parametric CAD kernel ([OpenCASCADE](http://www.opencascade.org/)), supports many import/export formats and has a good [Python API](http://freecadweb.org/api/).
I\'m not going into the process of modelling with FreeCAD here.
There are many tutorials out there.
Yet, in case you do not like the existing ones and you suppose to benefit from another one here, just [drop me a note](mailto:andreas.bihlmaier@gmx.de).

To continue, let\'s assume the object is modelled.
We\'ll use the union of a box and a cylinder (just click \"Create box\" and \"Create cylinder\" in the \"Part\" workbench, select both and click \"Make a union\" to get the example shape).
![Cylinder fused with box](/images/medium/freecad_cylinder_box.jpg)
This means there is a geometrically _exact_ representation of the object we want to use in Gazebo.
Unfortunately, most real-time graphics engines do not work with CSG, therefore we have to approximate the actual geometry by a triangle mesh.


Mesh export
-----------
We can achieve this using the \"Mesh design\" workbench\'s \"Create mesh from shape\" function (Tessellation settings: \"Standard\", Surface deviation=1.0):
![Mesh from shape](/images/medium/freecad_mesh_from_shape.jpg)
This works well, but once we load the object into Gazebo, we recognize that the cylinder part does not look very round.
![Gazebo mesh from shape](/images/medium/gazebo_mesh_from_shape-cutout.jpg)
One solution would be to increase the number of triangles, i.e. decrease the \"surface deviation\" parameter.
Unfortunately, this goes along with a (big) rendering performance degradation.
If we only care that the objects looks to be round (in contrast to its geometry actually being rounder), we can use Gazebo\'s support for vertex normals and Phong shading.

This [FreeCAD macro](https://github.com/andreasBihlmaier/FreeCAD/blob/master/export_obj_with_normals.FCMacro) (copy to `~/.FreeCAD/`) exports FreeCAD parts together with their vertex normals as Wavefront .obj file.
It works by querying the parametric part representation for the actual normal at each vertex position.
This is completely different and superior to using a \"smooth\" feature (e.g. in Blender \"Transform\" -> \"Shading: Smooth\") on the mesh after export.
Note: The script is not implemented very efficiently at the moment, thus the export may take a while depending on the final mesh size.
![Macro to export mesh with normals](/images/medium/freecad_mesh_with_normals.jpg)


Mesh format conversion
----------------------
Gazebo supports .stl and Collada. dae files, whereas the former does not at all support vertex normals.
Our exported .obj mesh can be converted to a .dae file _preserving the vertex normals_ using this [Python script](https://github.com/andreasBihlmaier/ahbconvert/blob/master/scripts/obj2dae.py):  
`./obj2dae.py -u cm cylinderbox.obj cylinderbox.dae`

The resulting mesh is rendered much smoother in Gazebo:
![Gazebo mesh with normals](/images/medium/gazebo_mesh_with_normals-cutout.jpg)



Mesh materials
--------------
This post is about creating geometrically and visually accurate Gazebo models.
We have achieved geometrical accuracy through using a parametric CAD program.
Visual accuracy in relation to geometry is also given by exporting the actual vertex normals.
What is missing are proper material definitions and textures for each part of the mesh - this will be covered in a future post.


Mesh simplification
-------------------
Although we avoided excessively detailed mesh geometries by substituting vertex normals for more triangles, the meshes are most likely too detailed as collision bodies.
I want to point two paths towards simplified meshes, i.e. having less triangles, to be used as [SDF](http://gazebosim.org/sdf/dev.html) `<collision>` property.
The first is to allow higher deviations through FreeCAD\'s tessellation settings.

The second path is to simplify our visual mesh.
Blender has a [\"Decimate\"](http://wiki.blender.org/index.php/Doc:2.6/Manual/Modifiers/Generate/Decimate) modifier.
And [MeshLab](http://meshlab.sourceforge.net/) offers several mesh simplification techniques.
Below is an example using the \"Quadric Edge Collapse Decimation\", reducing the mesh faces to 1/2 of the original:
![MeshLab simplify](/images/medium/meshlab_simplify.jpg)

Now that we have our models, enjoy simulating.
