import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model MachineType{
  @key id: int64;
  code: string;
  name: string;
}

model MachineTypeBody{
  code: string;
  name: string;
}

