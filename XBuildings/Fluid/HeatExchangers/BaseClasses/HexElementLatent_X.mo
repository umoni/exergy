within Exergy.XBuildings.Fluid.HeatExchangers.BaseClasses;
model HexElementLatent_X "Element of a heat exchanger"
 // extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement(
 extends Exergy.XBuildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement_X(
    redeclare final Exergy.XBuildings.Fluid.MixingVolumes.MixingVolume   vol1,
    redeclare final Exergy.XBuildings.Fluid.MixingVolumes.MixingVolumeMoistAir  vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=energyDynamics,
        final initialize_p=initialize_p2,
        final simplify_mWat_flow=false));
    //redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(

//redeclare final Exergy.XBuildings.Fluid.MixingVolumes.MixingVolumeMoistAir  vol2(

  Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange masExc(redeclare
      final package Medium = Medium2) "Model for mass exchange"
    annotation (Placement(transformation(extent={{48,-44},{68,-24}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen(
    T(final quantity="ThermodynamicTemperature",
      final unit = "K", displayUnit = "degC", min=0))
    "Temperature sensor of metal"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
public
  Utilities.ViewPort viewPort
    annotation (Placement(transformation(extent={{90,88},{110,108}})));
  Utilities.ViewRoute viewRoute(nSubSystem=3)
    annotation (Placement(transformation(extent={{50,84},{70,104}})));
equation
  connect(temSen.T, masExc.TSur) annotation (Line(points={{28,0},{36,0},{36,-26},
          {46,-26}},                    color={0,0,127}));
  connect(masExc.mWat_flow, vol2.mWat_flow) annotation (Line(points={{69,-32},{
          80,-32},{80,-52},{14,-52}},  color={0,0,127}));
  connect(masExc.TLiq, vol2.TWat) annotation (Line(points={{69,-38},{72,-38},{
          72,-55.2},{14,-55.2}},
                             color={0,0,127}));
  connect(vol2.X_w, masExc.XInf) annotation (Line(points={{-10,-64},{-20,-64},
          {-20,-34},{46,-34}}, color={0,0,127}));
  connect(Gc_2, masExc.Gc) annotation (Line(
      points={{40,-100},{40,-42},{46,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.port, con1.solid) annotation (Line(
      points={{8,0},{-66,0},{-66,20},{-60,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(viewRoute.viewTotal, viewPort) annotation (Line(points={{69.8,93.9},{82.9,
          93.9},{82.9,98},{100,98}}, color={28,108,200}));

  connect(vol1.viewOutput, viewRoute.viewOutput[1]) annotation (Line(points={{9.6,
          50.2},{49.9,50.2},{49.9,91.8}}, color={28,108,200}));
  connect(vol2.viewOutput, viewRoute.viewOutput[2]) annotation (Line(points={{-7.6,
          -50.2},{-7.6,26},{22,26},{22,93.8},{49.9,93.8}}, color={28,108,200}));
  connect(mas.viewOutput, viewRoute.viewOutput[3]) annotation (Line(
        points={{-97.8,9.6},{-97.8,48},{-24,48},{-24,95.8},{49.9,95.8}},
        color={28,108,200}));
  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger with humidity condensation of fluid 2 and
with dynamics of the fluids and the solid.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement\">
Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement</a>
for a description of the physics.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for <code>mas</code> to avoid a warning during translation.
</li>
<li>
September 11, 2013, by Michael Latentter:<br/>
First implementation.
</li>
</ul>
</html>"),    Icon(graphics={
        Polygon(
          points={{-56,-52},{-58,-58},{-60,-66},{-58,-74},{-54,-76},{-44,-76},{-38,
              -70},{-40,-62},{-44,-50},{-50,-38},{-56,-52}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-34},{-28,-40},{-30,-48},{-28,-56},{-24,-58},{-14,-58},{-8,
              -52},{-10,-44},{-14,-32},{-20,-20},{-26,-34}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-50},{6,-56},{4,-64},{6,-72},{10,-74},{20,-74},{26,-68},{24,
              -60},{20,-48},{14,-36},{8,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,-24},{42,-30},{40,-38},{42,-46},{46,-48},{56,-48},{62,-42},
              {60,-34},{56,-22},{50,-10},{44,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end HexElementLatent_X;
