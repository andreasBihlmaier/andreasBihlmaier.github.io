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


Mesh export
-----------


Mesh format conversion
----------------------


Mesh simplification
-------------------
