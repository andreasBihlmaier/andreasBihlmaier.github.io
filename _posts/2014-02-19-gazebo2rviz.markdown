---
layout: default
comments: true
title: gazebo2rviz
---

Gazebo and rviz are different programs used for different purposes - simulation and visualization.
Yet, if one desires to have a simulation environment that behaves as close to the real system as required and offers the same functionality, gazebo and rviz are often used together.
Instead of visualizing the real sensor data in rviz, the data is provided by sensors simulated within gazebo.  
Getting to the point of this post: I wanted to have all simulated entities automatically imported into rviz through the [TF](http://wiki.ros.org/rviz/DisplayTypes/TF) and [Marker](http://wiki.ros.org/rviz/DisplayTypes/Marker) plugin.

[gazebo2rviz](https://github.com/andreasBihlmaier/gazebo2rviz) contains the ROS nodes I came up with to achieve the above set goal.
The package contains two (Python) nodes:
* _gazebo2tf_ translates /gazebo/link_states to TF in a hierarchical manner corresponding to SDF `<include>`.
* _gazebo2marker_ retrieves the current gazebo models from /gazebo/model_states, parses their corresponding SDF file and sends visualization_msgs/Marker for each mesh messages to /visualization_marker used by the rviz Marker plugin.
With this solution no plugin for either gazebo or rviz is required, only already available interfaces are used.

Here is a small usage example:  
Start gazebo and add some objects (be aware that at the moment not all gazebo models will work, see below)
![Gazebo with some mesh-based models](/images/medium/gazebo2rviz_gazebo.jpg)

Start rviz, add TF and Marker plugin
![Rviz with TF and Marker plugin](/images/medium/gazebo2rviz_rviz_empty.jpg)

Launch gazebo2rviz nodes: `roslaunch gazebo2rviz gazebo2rviz.launch`

From now everything that happens in gazebo, e.g. moving, adding or deleting a model will also be visualized in rviz
![Rviz showing the current gazebo world](/images/medium/gazebo2rviz_rviz_tf_and_markers.jpg)


The package is work in progress, i.e. not free of bugs, and there some desired features are still missing, e.g. support for non-mesh `<visual>` SDF elements.
If you find gazebo2rviz usefull and fix bugs or add features that you require, please send be a pull request.
