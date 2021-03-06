within Exergy.XThermoCycle.Components.HeatFlow.HeatTransfer;
model Ideal "Ideal: Heat transfer without thermal resistance"

  extends
    Exergy.XThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones;
equation
  T_fluid = thermalPortL.T;
  annotation(Documentation(info="<html>
<p><big>Ideal heat transfer without thermal resistance. </p>
<p></p>
</html>"));
end Ideal;
