import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model RoutingCode {
  @key id: int64;
  @example("DRILL_V") code: string;
  @example("drill vertically") name: string;
  @example("/icons/drill-vert.png") icon: string | null;
  @example("CNC") machine_type_code: string | null;
  @example("MC1") preferred_mc_no: string | null;
  @example(30) setup_time_sec: int32;
  @example(90) run_time_sec: int32;
  display_position: int32 | null;
}

model RoutingCodeBody {
  code: RoutingCode.code;
  name: RoutingCode.name;
  icon: RoutingCode.icon;
  machine_type_code: RoutingCode.machine_type_code;
  preferred_mc_no?: RoutingCode.preferred_mc_no;
  setup_time_sec: RoutingCode.setup_time_sec;
  run_time_sec: RoutingCode.run_time_sec;
  display_position: RoutingCode.display_position;
}
