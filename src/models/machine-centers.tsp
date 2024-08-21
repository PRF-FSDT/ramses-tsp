import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model MachineCenter{
  @key id: int64;
  no: string;
  name: string;
  scan_code: string;
  machine_type_code: string;
}

model MachineCenterBody{
  name: string;
  scan_code: string;
  machine_type_code: string;
}

