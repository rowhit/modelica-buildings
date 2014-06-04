within Buildings.Electrical.Transmission.Grids;
record GridInHome_AL70 "Simplified grid for benchmarking (AL70)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes=21,
    Nlinks=20,
    L=16.0*ones(Nlinks,1),
    FromTo=[[1,2];   [2,3];   [3,4];   [4,5];   [5,6];   [6,7];   [7,8];   [8,9];   [9,10];  [10,11];
            [11,12]; [12,13]; [13,14]; [14,15]; [15,16]; [16,17]; [17,18]; [18,19]; [19,20]; [20,21]],
    cables={LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70()});
    extends Modelica.Icons.UnderConstruction;
  annotation (Documentation(info="<html>
<p>Schematic of the grid</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/IEEE_34.png\"/></p>
</html>"));
end GridInHome_AL70;