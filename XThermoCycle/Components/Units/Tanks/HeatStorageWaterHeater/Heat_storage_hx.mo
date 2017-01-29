within Exergy.XThermoCycle.Components.Units.Tanks.HeatStorageWaterHeater;
model Heat_storage_hx
  "Stratified tank with an internal heat exchanger and ambient heat losses (nodal model)"

replaceable package MainFluid = ThermoCycle.Media.StandardWater
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium "Main fluid"   annotation (choicesAllMatching = true);
replaceable package SecondaryFluid =
      ThermoCycle.Media.StandardWater          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Secondary fluid"  annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Length htot=1 "Total height of the tank";
  parameter Modelica.SIunits.Length h1=0.3
    "Height of the bottom of the heat exchanger";
  parameter Modelica.SIunits.Length h2=0.6
    "Height of the top of the heat exchanger";

  parameter Integer N=15 "Total number of cells";
  parameter Integer N1=integer(h1*N/htot)
    "Cell corresponding to the bottom of the heat exchanger";
  parameter Integer N2=integer(h2*N/htot)
    "Cell corresponding to the top of the heat exhcanger";

  parameter Modelica.SIunits.Area A_amb=2
    "Total heat exchange area from the tank to the ambient" annotation(group="Tank");
  parameter Modelica.SIunits.Area A_hx=1
    "Total heat exchanger area from in the heat exchanger" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.Volume V_tank=0.3 "Total capacity of the tank" annotation(group="Tank");
  parameter Modelica.SIunits.Volume V_hx=0.005
    "Internal volume of the heat exchanger" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1
    "Nominal mass flow rate in the heat exchanger" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_amb=1
    "Heat transfer coefficient between the tank and the ambient" annotation(group="Tank");
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_hx=4000
    "Nominal heat transfer coefficient in the heat exchanger" annotation(group="Heat exchanger");

parameter Modelica.SIunits.Mass M_wall_hx= 5
    "Mass of the metal wall between the two fluids" annotation(group="Heat exchanger");
parameter Modelica.SIunits.SpecificHeatCapacity c_wall_hx= 500
    "Specific heat capacity of metal wall" annotation(group="Heat exchanger");
parameter Boolean FlowReversal = false
    "Allow flow reversal (might complexify the final system of equations)";
 parameter Modelica.SIunits.Pressure pstart_tank=1E5
    "Tank pressure start value"      annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_inlet_tank=273.15+10
    "Tank inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_outlet_tank=273.15+60
    "Tank outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_tank[N]=linspace(
        MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_inlet_tank),MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_outlet_tank),
        N) "Start value of enthalpy vector (initialized by default)" annotation (Dialog(tab="Initialization"));

  parameter Modelica.SIunits.Pressure pstart_hx=1E5
    "Heat exchanger pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_inlet_hx=273.15+70
    "Heat exchanger inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_outlet_hx=273.15+50
    "Heat exchanger outlet temperature start value"
     annotation (Dialog(tab="Initialization"));

  parameter Boolean steadystate_tank=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean steadystate_hx=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(tab="Initialization"));

  Exergy.XThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc flow1Dim(
    redeclare package Medium = SecondaryFluid,
    A=A_hx,
    V=V_hx,
    Mdotnom=Mdot_nom,
    Unom=Unom_hx,
    steadystate=steadystate_hx,
    N=N2 - N1 + 1,
    pstart=100000,
    Tstart_inlet=363.15,
    Tstart_outlet=343.15) annotation (Placement(transformation(
          extent={{20,-84},{-16,-50}})));
  Cell1DimInc_2ports cell1DimInc_hx[N](
    redeclare package Medium = MainFluid,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    each Vi=V_tank/N,
    each Mdotnom=1,
    each Unom=U_amb,
    each Unom_hx=Unom_hx,
    each Ai=A_amb/N,
    each pstart=pstart_tank,
    hstart=hstart_tank,
    each A_hx=1/(N2 - N1 + 1),
    each FlowReversal=FlowReversal)
    annotation (Placement(transformation(extent={{-16,-10},{18,24}})));

  ThermoCycle.Interfaces.HeatTransfer.ThermalPortConverter thermalPortConverter(N=N2 - N1
         + 1)
    annotation (Placement(transformation(extent={{-8,-4},{12,-32}})));

  Exergy.XThermoCycle.Components.HeatFlow.Walls.MetalWall metalWall(
    Aext=A_hx,
    Aint=A_hx,
    c_wall=c_wall_hx,
    M_wall=M_wall_hx,
    Tstart_wall_1=Tstart_inlet_hx - 5,
    Tstart_wall_end=Tstart_outlet_hx - 5,
    steadystate_T_wall=false,
    N=N2 - N1 + 1) annotation (Placement(transformation(extent={{-18,
            -56},{21,-28}})));

protected
Real Tsf_[N](min=0);
Real Twall_[N](min=0);

public
record SummaryBase
  replaceable Arrays T_profile;
  record Arrays
   parameter Integer n;
   Real[n] Tsf(min=0);
   Real[n] Twall(min=0);
   Real[n] Twf(min=0);
  end Arrays;
end SummaryBase;
replaceable record SummaryClass = SummaryBase;
SummaryClass Summary( T_profile( n=N, Tsf = Tsf_,  Twall = Twall_, Twf = cell1DimInc_hx.T));

ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_ext
    annotation (Placement(transformation(extent={{-14,48},{16,60}}),
        iconTransformation(extent={{-40,-6},{-34,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeA MainFluid_su(redeclare package Medium =
        MainFluid) annotation (Placement(transformation(extent={{-52,-94},{-32,-74}}),
                   iconTransformation(extent={{-42,-84},{-32,-74}})));
  ThermoCycle.Interfaces.Fluid.FlangeB SecondaryFluid_ex(redeclare package
      Medium = SecondaryFluid)
                   annotation (Placement(transformation(extent={{-64,-76},{-44,-56}}),
        iconTransformation(extent={{34,-36},{46,-24}})));
  ThermoCycle.Interfaces.Fluid.FlangeB MainFluid_ex(redeclare package Medium =
        MainFluid) annotation (Placement(transformation(extent={{-14,72},{6,
            92}}),
        iconTransformation(extent={{-6,80},{6,92}})));
  ThermoCycle.Interfaces.Fluid.FlangeA SecondaryFluid_su(redeclare package
      Medium = SecondaryFluid)
                        annotation (Placement(transformation(extent={{54,-76},{74,
            -56}}),iconTransformation(extent={{34,28},{46,40}})));
equation

/* Connection of the different cell of the tank in series */
  for i in 1:N - 1 loop
    connect(cell1DimInc_hx[i].OutFlow, cell1DimInc_hx[i + 1].InFlow);
  end for;

/* Connection of the different cell of the tank in series */
  for i in 1:N loop
    connect(Wall_ext,cell1DimInc_hx[i].Wall_int);
  end for;

  for i in 1:N1-1 loop
    Tsf_[i]=273.15;
    Twall_[i]=273.15;
  end for;

  for i in 1:(N2 - N1+1) loop
    connect(thermalPortConverter.single[i], cell1DimInc_hx[N1 + i - 1].HXInt);
  end for;

    Tsf_[N1:N2]=flow1Dim.Summary.T[end:-1:1];
    Twall_[N1:N2]=metalWall.T_wall[end:-1:1];

  for i in N2+1:N loop
    Tsf_[i]=273.15;
    Twall_[i]=273.15;
  end for;

  connect(thermalPortConverter.multi, metalWall.Wall_int) annotation (Line(
      points={{2,-22.9},{2,-29.35},{1.5,-29.35},{1.5,-37.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_ext, flow1Dim.Wall_int) annotation (Line(
      points={{1.11,-46.2},{1.11,-52.0584},{2,-52.0584},{2,-59.9167}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MainFluid_su, cell1DimInc_hx[1].InFlow) annotation (Line(
      points={{-42,-84},{-51,-84},{-51,7},{-16,7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cell1DimInc_hx[N].OutFlow, MainFluid_ex) annotation (Line(
      points={{18,7.17},{68,7.17},{68,82},{-4,82}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SecondaryFluid_ex, flow1Dim.OutFlow)
                                           annotation (Line(
      points={{-54,-66},{-54,-66.8583},{-13,-66.8583}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.InFlow, SecondaryFluid_su)
                                          annotation (Line(
      points={{17,-67},{60.5,-67},{60.5,-66},{64,-66}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Line(
      points={{-0.4,-12.26},{-0.4,-9.445},{-0.08,-9.445},{-0.08,-6.63},{2.32,
          -6.63},{2.32,-1.5}},
      color={255,0,0},
      smooth=Smooth.None), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=5000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{-40,60},{40,88}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,72},{40,-84}},
          lineColor={215,215,215},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Line(
          points={{40,34},{-10,34},{20,22},{-10,12},{20,2},{-8,-10},{22,-20},{-8,
              -32},{38,-32}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{22,-36},{34,-32},{22,-28}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,-84},{40,-84},{40,74}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,74},{-40,-84}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,66},{40,66}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>Nodal model of a stratified tank, with the following hypotheses:</p>
<p><ul>
<li>No heat transfer between the different nodes</li>
<li>The internal heat exchanger is discretized in the same way as the tank: each cell of the heat exchanger corresponds to one cell of the tank and exchanges heat with that cell only.</li>
<li>Incompressible fluid in both the tank and the heat exchanger</li>
</ul></p>
<p><br/>The tank is discretized using a modified version of the incompressible Cell1Dim model adding an additional heat port. The heat exchanger is modeled using the Flow1Dim component and a wall component.</p>
</html>"));
end Heat_storage_hx;
