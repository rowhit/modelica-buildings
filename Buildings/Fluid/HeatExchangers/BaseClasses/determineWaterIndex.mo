within Buildings.Fluid.HeatExchangers.BaseClasses;
function determineWaterIndex
  "Determine the index of water in a 2-component medium model"
  input String[:] substanceNames "names of substances of media";
  output Integer idxWat "index of water";
protected
  Boolean found(fixed=false) "Flag, used for error checking";
  Integer N = size(substanceNames, 1) "number of substances";
algorithm
  assert(N==2, "The implementation is only valid if Medium.nX=2.");
  found:=false;
  idxWat := 1;
  for i in 1:N loop
    if Modelica.Utilities.Strings.isEqual(
        string1=substanceNames[i],
        string2="water",
        caseSensitive=false) then
        idxWat := i;
        found := true;
    end if;
  end for;
  assert(found,
    "Did not find medium species 'water' in the medium model. " +
    "Change medium model.");
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
Given an array of strings representing substance names, this function returns
the integer index of the substance named \"water\" (case-insensitive).
</p>

<p>
This function is useful to automate lookup up the index of water within a media
so as to avoid hard-coding or guessing what the index will be. Typically, this
function would be run once at initialization time.
</p>
</html>"));
end determineWaterIndex;
