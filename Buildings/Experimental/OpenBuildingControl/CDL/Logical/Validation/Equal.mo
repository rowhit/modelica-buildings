within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Equal "Validation model for the Equal block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp1(
    duration=5,
    offset=-2,
    height=6)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-50,8},{-30,28}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp2(
    duration=5,
    offset=-3,
    height=8) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

<<<<<<< HEAD
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.EqualStatus equal1
    annotation (Placement(transformation(extent={{2,-8},{22,12}})));
=======
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equal1
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
>>>>>>> origin/issue762_sampler_fix

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp3(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Modelica.Blocks.Discrete.TriggeredSampler triggeredSampler
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(ramp1.y, equal1.u1)
    annotation (Line(points={{-29,18},{-16,18},{-16,0},{-2,0}},
                                                           color={0,0,127}));
  connect(ramp2.y, equal1.u2) annotation (Line(points={{-29,-20},{-16,-20},{-16,
          -8},{-2,-8}},
                    color={0,0,127}));
  connect(ramp3.y, triggeredSampler.u)
    annotation (Line(points={{21,50},{38,50},{38,50}}, color={0,0,127}));
  connect(equal1.y, triggeredSampler.trigger) annotation (Line(points={{21,0},{
          36,0},{36,38.2},{50,38.2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Equal.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Equal;
