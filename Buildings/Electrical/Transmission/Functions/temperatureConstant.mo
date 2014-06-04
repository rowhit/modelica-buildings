within Buildings.Electrical.Transmission.Functions;
function temperatureConstant
  "Function that returns the temperature constant of the material (used to determine the temperature dependence of the resistivity)"
  input Buildings.Electrical.Types.VoltageLevel voltageLevel "Voltage level";
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low
    "Type of cable (if low voltage)";
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med
    "Type of cable (if medium voltage)";
  output Modelica.SIunits.Temperature M "Temperature constant of the material";
protected
  Buildings.Electrical.Transmission.Materials.Material material;
algorithm

  // Select the cable depending on the voltage level of the line
  if voltageLevel == Buildings.Electrical.Types.VoltageLevel.Low then
    material := cable_low.material;
  elseif voltageLevel == Buildings.Electrical.Types.VoltageLevel.Medium then
    material := cable_med.material;
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level should be Low or Medium " +
        String(voltageLevel) + " A. The material cannot be choose, selected Copper as default.");
    material := Buildings.Electrical.Transmission.Materials.Material.Cu;
  end if;

  // Depending on the material define the constant
  if material == Buildings.Electrical.Transmission.Materials.Material.Al then
    M := 228.1 + 273.15;
  elseif material == Buildings.Electrical.Transmission.Materials.Material.Cu then
    M := 234.5 + 273.15;
  else
    Modelica.Utilities.Streams.print("Warning: the material is not known, missing the temperature constant " +
        String(material) + " A. The material cannot be choose, selected Copper as default.");
    M := 234.5 + 273.15;
  end if;

annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the temperature coefficient of a cable.
</p>
<p>
This temperature coefficient of a cable <i>M</i> is used to
compute how the resistance of a cable <i>R(T)</i> vary depending on the temperature <i>T</i>.
The variation is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R(T) = R<sub>ref</sub> (M + T)/(M + T<sub>ref</sub>)
</p>
<p>
where the resistance <i>R<sub>ref</sub></i> is the reference value of the resistance, <i>M</i> is the
 temperature coefficient of the cable material, and <i>T<sub>ref</sub></i> is the referemnce temperature.
</p>
<p>
The temperature coefficient depends on the material of the cable.
</p>
<h4>Copper</h4>
<p align=\"center\" style=\"font-style:italic;\">
M = 234.5 + 273.15 K
</p>
<h4>Aluminium</h4>
<p align=\"center\" style=\"font-style:italic;\">
M = 228.1 + 273.15 K
</p>
</html>"));
end temperatureConstant;