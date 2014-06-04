within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACTransformerFull
  "AC AC transformer for single phase systems with impedances on both primary and secondary side"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(redeclare package PhaseSystem =
          PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(redeclare package PhaseSystem =
          PhaseSystem_p));
  parameter Modelica.SIunits.Voltage Vhigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.SIunits.Voltage Vlow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.SIunits.ApparentPower VAbase
    "Nominal power of the transformer";
  parameter Modelica.SIunits.Frequency f(start=60) "Nominal frequency";
  parameter Buildings.Electrical.Types.PerUnit R1(min=0)
    "Resistance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L1(min=0)
    "Inductance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit R2(min=0)
    "Resistance on side 2 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L2(min=0)
    "Inductance on side 2 of the transformer (pu)";
  parameter Boolean magEffects = false
    "If =true introduce magnetization effects"
    annotation(Evaluate=true, Dialog(group="Magnetization"));
  parameter Buildings.Electrical.Types.PerUnit Rm(min=0)
    "Magnetization resistance (pu)" annotation(Evaluate=true, Dialog(group="Magnetization", enable = magEffects));
  parameter Buildings.Electrical.Types.PerUnit Lm(min=0)
    "Magnetization inductance (pu)" annotation(Evaluate=true, Dialog(group="Magnetization", enable = magEffects));
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(Evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.SIunits.Efficiency eta "Efficiency of the transformer";
  Modelica.SIunits.Power LossPower[2] "Loss power";
protected
  parameter Modelica.SIunits.AngularVelocity omega_n = 2*Modelica.Constants.pi*f;
  parameter Real N = Vhigh/Vlow "Winding ratio";
  parameter Modelica.SIunits.Resistance Rbase_high = Vhigh^2/VAbase
    "Base impedance of the primary side";
  parameter Modelica.SIunits.Resistance Rbase_low = Vlow^2/VAbase
    "Base impedance of the secondary side";
  Modelica.SIunits.Impedance Z1[2] = {Rbase_high*R1, omega*L1*Rbase_high/omega_n};
  Modelica.SIunits.Impedance Z2[2] = {Rbase_low*R2, omega*L2*Rbase_low/omega_n};
  Modelica.SIunits.Impedance Zrm[2] = {Rbase_high*Rm, 0}
    "Magnetization impedance - resistance";
  Modelica.SIunits.Impedance Zlm[2] = {0, omega*Lm*Rbase_high/omega_n}
    "Magnetization impedance - impedence";
  Modelica.SIunits.Voltage V1[2] "Voltage at the winding - primary side";
  Modelica.SIunits.Voltage V2[2] "Voltage at the winding - secondary side";
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
  Modelica.SIunits.Power Sp = sqrt(Pow_p[1]^2 + Pow_p[2]^2)
    "Apparent power terminal p";
  Modelica.SIunits.Power Sn = sqrt(Pow_n[1]^2 + Pow_n[2]^2)
    "Apparent power terminal n";
  Modelica.SIunits.AngularVelocity omega "Angular velocity";
  Modelica.SIunits.Current Im[2] "Magnetization current";
equation
  assert(sqrt(Pow_p[1]^2 + Pow_p[2]^2) <= VAbase*1.01,"The load power of transformer is higher than VAbase");

  // Angular velocity
  omega = der(PhaseSystem_p.thetaRef(terminal_p.theta));

  // Efficiency
  eta = Buildings.Utilities.Math.Functions.smoothMin(
        x1=  sqrt(Pow_p[1]^2 + Pow_p[2]^2) / (sqrt(Pow_n[1]^2 + Pow_n[2]^2) + 1e-6),
        x2=  sqrt(Pow_n[1]^2 + Pow_n[2]^2) / (sqrt(Pow_p[1]^2 + Pow_p[2]^2) + 1e-6),
        deltaX=  0.01);

  // Ideal transformation
  V2 = V1/N;
  terminal_p.i[1] + (terminal_n.i[1] - Im[1])*N = 0;
  terminal_p.i[2] + (terminal_n.i[2] - Im[2])*N = 0;

  // Magnetization current
  if magEffects then
    Im = Buildings.Electrical.PhaseSystems.OnePhase.divide(V1, Zrm) +
         Buildings.Electrical.PhaseSystems.OnePhase.divide(V1, Zlm);
  else
    Im[1] = 0;
    Im[2] = 0;
  end if;

  // Losses due to the impedance - primary side
  terminal_n.v = V1 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_n.i, Z1);

  // Losses due to the impedance - secondary side
  terminal_p.v = V2 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_p.i, Z2);

  // Loss of power
  LossPower = Pow_p + Pow_n;

  // The two sides have the same reference angle
  terminal_p.theta = terminal_n.theta;

  if ground_1 then
    Connections.potentialRoot(terminal_n.theta);
  end if;
  if ground_2 then
    Connections.root(terminal_p.theta);
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-140,60},{-80,20}},
          lineColor={11,193,87},
          textString="1"),
        Text(
          extent={{-130,100},{-70,60}},
          lineColor={11,193,87},
          textString="AC"),
        Text(
          extent={{70,100},{130,60}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{80,60},{140,20}},
          lineColor={0,120,120},
          textString="2"),
        Line(
          points={{-80,-40},{-120,-40}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,-40},{-106,-14}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,
              255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-102,-16},{-114,-24},{-118,-42}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier),
        Line(
          points={{80,-40},{120,-40}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{80,-40},{106,-14}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{102,-16},{114,-24},{118,-42}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier),
        Line(
          points={{-100,40},{-94,40},{-92,44},{-88,36},{-84,44},{-80,36},{-76,44},
              {-72,36},{-70,40},{-64,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-64,46},{-52,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,46},{-40,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,46},{-28,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,40},{-26,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,40},{0,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-6,20},{6,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,8},{6,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-4},{6,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,20},{0,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,-16},{0,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{0,-40},{-90,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{14,40},{14,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{20,20},{8,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,8},{8,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-4},{8,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,20},{14,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{14,-16},{14,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{14,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-80,60},{-64,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{-54,60},{-38,48}},
          lineColor={0,120,120},
          textString="L"),
        Line(
          points={{66,40},{72,40},{74,44},{78,36},{82,44},{86,36},{90,44},{94,36},
              {96,40},{100,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-54,-6.61288e-15}},
          color={0,127,127},
          origin={14,40},
          rotation=180),
        Ellipse(
          extent={{26,46},{38,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,46},{50,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,46},{62,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,40},{62,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{76,60},{92,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{36,60},{52,48}},
          lineColor={0,120,120},
          textString="L"),
        Line(
          points={{-26,-1},{-10,-1},{-9,4},{-5,-4},{-1,4},{3,-4},{7,4},{10,-5},{
              12,-1},{22,-1}},
          color={0,127,127},
          smooth=Smooth.None,
          origin={-45,2},
          rotation=90),
        Ellipse(
          extent={{-36,18},{-24,6}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,6},{-24,-6}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-6},{-24,-18}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,18},{-30,-18}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-28,-2.09669e-15}},
          color={0,127,127},
          origin={-28,40},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-1.53415e-16,-6}},
          color={0,127,127},
          origin={-30,18},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-1.53415e-16,-6}},
          color={0,127,127},
          origin={-30,-24},
          rotation=180),
        Line(
          points={{-44,24},{-20,24},{-20,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{-44,-24},{-20,-24},{-20,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-70,22},{-54,10}},
          lineColor={0,120,120},
          textString="Rm"),
        Text(
          extent={{-70,-8},{-54,-20}},
          lineColor={0,120,120},
          textString="Lm")}),
    Documentation(info="<html>
<p>
This is an AC AC converter, based on a power balance between both QS circuit sides.
The paramater <i>conversionFactor</i> defines the ratio between averaged the QS rms voltages.
The loss of the converter is proportional to the power transmitted at the second circuit side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the second circuit side.
Furthermore, reactive power on both QS side are set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACTransformerFull;