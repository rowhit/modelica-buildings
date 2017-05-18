within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
block TriggeredSampler "Triggered sampling of continuous signals"
<<<<<<< HEAD
  //extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real y_start=0 "initial value of output signal";

  Modelica.Blocks.Interfaces.RealInput u "Connector with a Real input signal"
                                                        annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector with a Real output signal"                annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
=======

  parameter Real y_start=0 "initial value of output signal";

  Interfaces.RealInput u "Connector with a Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Connector with a Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanInput trigger "Signal that triggers the sampler"
    annotation (Placement(
>>>>>>> origin/issue762_sampler_fix
        transformation(
        origin={0,-118},
        extent={{-20,-20},{20,20}},
        rotation=90)));
<<<<<<< HEAD
=======
initial equation
  y = y_start;
>>>>>>> origin/issue762_sampler_fix
equation
  when trigger then
    y = u;
  end when;
initial equation
  y = y_start;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{25.0,-10.0},{45.0,10.0}}),
      Line(points={{-100.0,0.0},{-45.0,0.0}},
        color={0,0,127}),
      Line(points={{45.0,0.0},{100.0,0.0}},
        color={0,0,127}),
      Line(points={{0.0,-100.0},{0.0,-26.0}},
        color={255,0,255}),
      Line(points={{-35.0,0.0},{28.0,-48.0}},
        color={0,0,127}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-45.0,-10.0},{-25.0,10.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-25,-10},{-45,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,-10},{25,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-45,0}}, color={0,0,255}),
        Line(points={{45,0},{100,0}}, color={0,0,255}),
        Line(points={{-35,0},{28,-48}}, color={0,0,255}),
        Line(points={{0,-100},{0,-26}}, color={255,0,255})}),
    Documentation(info="<html>
<p>
Samples the continuous input signal whenever the trigger input
signal is rising (i.e., trigger changes from <b>false</b> to
<b>true</b>) and provides the sampled input signal as output.
Before the first sampling, the output signal is equal to
the initial value defined via parameter <b>y0</b>.
</p>
<<<<<<< HEAD
=======
</html>", revisions="<html>
<ul>
<li>
May 17, 2017, by Milica Grahovac:<br/>
First revision, based on the implementation of the
Modelica Standard Library.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
>>>>>>> origin/issue762_sampler_fix
</html>"));
end TriggeredSampler;
