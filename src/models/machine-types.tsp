import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model MachineType {
  @key id: int64;
  @example("CNC") code: string;
  @example("CNC") name: string;
}

model MachineTypeBody {
  code: MachineType.code;
  name: MachineType.name;
}
