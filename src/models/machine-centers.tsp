import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

import "./scanners.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model MachineCenter {
  @key id: int64;
  @example("CNC_1") no: string;
  @example("CNC Homag 1") name: string;
  @example("CNC_1") scan_code: string;
  @example("CNC") machine_type_code: string;
}

model MachineCenterWithScanners {
  ...MachineCenter;
  scanners: Scanner[];
}

model MachineCenterBody {
  no: MachineCenter.no;
  name: MachineCenter.name;
  scan_code: MachineCenter.scan_code;
  machine_type_code: MachineCenter.machine_type_code;
}
